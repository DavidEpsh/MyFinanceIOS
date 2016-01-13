//
//  ExpenseSql.m
//  Expense Maneger
//
//  Created by Admin on 12/25/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import "ExpenseSql.h"
#import <sqlite3.h>
#import "Expense.h"
#import "LastUpdateSql.h"
#import "Model.h"

@interface ExpenseSql()

@end

@implementation ExpenseSql

static NSString* EXPENSE_TABLE = @"EXPENSES";
static NSString* TIMEINMILLISECOND = @"TIMEINMILLISECOND";
static NSString* EXPENSE_NAME = @"NAME";
static NSString* EXPENSE_CATEGORY = @"CATEGORY";
static NSString* EXPENSE_AMOUNT = @"AMOUNT";
static NSString* EXPENSE_DATE = @"DATE";
static NSString* EXPENSE_IMAGE = @"EXPENSE_IMAGE";
static NSString* USER_NAME = @"USER_NAME";
static NSString* SHEET_ID = @"SHEET_ID";
static NSString* IS_REPEATING = @"IS_REPEATING";
static NSString* IS_SAVED = @"IS_SAVED";
static NSString* USER_SHEETS= @"USERS_SHEETS";


+(BOOL)createTable:(sqlite3*)database{
    char* errormsg;
    
    NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ INTEGER , %@ INTEGER)",EXPENSE_TABLE,TIMEINMILLISECOND,EXPENSE_NAME,EXPENSE_CATEGORY,EXPENSE_AMOUNT,EXPENSE_DATE,EXPENSE_IMAGE, USER_NAME, SHEET_ID, IS_REPEATING, IS_SAVED];
    int res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errormsg);
    if(res != SQLITE_OK){
        NSLog(@"ERROR: failed creating EXPENSES table");
        return NO;
    }
    return YES;
}

+(NSString*)getLastUpdateDate:(sqlite3*)database{
    return [LastUpdateSql getLastUpdateDate:database forTable:EXPENSE_TABLE];
}

+(void)setLastUpdateDate:(sqlite3*)database date:(NSString*)date{
    [LastUpdateSql setLastUpdateDate:database date:date forTable:EXPENSE_TABLE];
}



+(void)addExpense:(sqlite3 *)database exp:(Expense*)exp{
    sqlite3_stmt *statment;
    NSString* query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values (?,?,?,?,?,?,?,?,?,?);",EXPENSE_TABLE,TIMEINMILLISECOND,EXPENSE_NAME,EXPENSE_CATEGORY,EXPENSE_AMOUNT,EXPENSE_DATE,EXPENSE_IMAGE, USER_NAME, SHEET_ID, IS_REPEATING, IS_SAVED];
    
  
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil) == SQLITE_OK){
        NSString* st_timeInMillisecond = [NSString stringWithFormat:@"%@", exp.timeInMillisecond];
        sqlite3_bind_text(statment, 1, [st_timeInMillisecond UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 2, [exp.exname UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 3, [exp.excategory UTF8String],-1,NULL);
        sqlite3_bind_int(statment, 4, [exp.examount intValue]);
        sqlite3_bind_text(statment, 5, [exp.exdate UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 6, [exp.eximage UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 7, [exp.userName UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 8, [exp.sheetId UTF8String],-1,NULL);
        sqlite3_bind_int(statment, 9, [exp.isRepeating intValue]);
        sqlite3_bind_int(statment, 10, [exp.isSaved intValue]);
        if(sqlite3_step(statment) == SQLITE_DONE){
            return;
        }
    }
    NSLog(@"ERROR: addExpense failed %s",sqlite3_errmsg(database));
}


+(void)deleteExpense:(sqlite3 *)database exp:(Expense *)exp{
    sqlite3_stmt *statment;
    NSString* query = [NSString stringWithFormat:@"UPDATE EXPENSES SET IS_SAVED = '%@' WHERE TIMEINMILLISECOND = '%@'", @(0), exp.userName];
    
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil) == SQLITE_OK){
        if(sqlite3_step(statment) == SQLITE_DONE){
            return;
        }
    }
    NSLog(@"ERROR: addExpense failed %s",sqlite3_errmsg(database));
}


+(Expense*)getExpense:(sqlite3 *)database exname:(NSString *)expenseId{
    sqlite3_stmt *statment;
    
    NSString* currUser = [Model instance].user;
    
    const char *sqlStatement =[[NSString stringWithFormat:@"SELECT * from EXPENSES WHERE TIMEINMILLISECOND = '%@'",currUser ] cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (sqlite3_prepare_v2(database, sqlStatement, -1,&statment,nil) == SQLITE_OK){
        while(sqlite3_step(statment) == SQLITE_ROW){
            
            NSString* timeInMillisecond = [NSString stringWithFormat:@"%s", sqlite3_column_text(statment,0)];
            NSString* exname = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,1)];
            NSString* excategory = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,2)];
            NSNumber* examount = [NSNumber numberWithInt:(int)sqlite3_column_int(statment,3)];
            NSString* exdate = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,4)];
            NSString* eximage = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,5)];
            NSString* userName = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,6)];
            NSString* sheetId = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,7)];
            NSNumber* isRepeating = [NSNumber numberWithInt:(int)sqlite3_column_int(statment,8)];
            NSNumber* isSaved = [NSNumber numberWithInt:(int)sqlite3_column_int(statment,9)];
            
            return [[Expense alloc] init:timeInMillisecond exname:exname excategory:excategory examount:examount exdate:exdate eximage:eximage userName:userName sheetId:sheetId isRepeating:isRepeating isSaved:isSaved];

        }
    }else{
        NSLog(@"ERROR: addExpense failed %s",sqlite3_errmsg(database));
        return nil;
    }
    return nil;
}


+(NSArray*)getExpenses:(sqlite3 *)database{
    NSMutableArray* data = [[NSMutableArray alloc] init];
    sqlite3_stmt *statment;

    NSString* currUser = [Model instance].user;
    
    const char *sqlStatement =[[NSString stringWithFormat:@"SELECT * from EXPENSES WHERE USER_NAME = '%@'",currUser ] cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (sqlite3_prepare_v2(database, sqlStatement, -1,&statment,nil) == SQLITE_OK){
        while(sqlite3_step(statment) == SQLITE_ROW){
            
            NSString* timeInMillisecond = [NSString stringWithFormat:@"%s", sqlite3_column_text(statment,0)];
            NSString* exname = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,1)];
            NSString* excategory = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,2)];
            NSNumber* examount = [NSNumber numberWithInt:(int)sqlite3_column_int(statment,3)];
            NSString* exdate = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,4)];
            NSString* eximage = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,5)];
            NSString* userName = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,6)];
            NSString* sheetId = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,7)];
            NSNumber* isRepeating = [NSNumber numberWithInt:(int)sqlite3_column_int(statment,8)];
            NSNumber* isSaved = [NSNumber numberWithInt:(int)sqlite3_column_int(statment,9)];
            //NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];
            //[dateFormat setDateFormat:@"dd/MM/yyyy"];
            //NSString* my_exdate = [dateFormat dateFromString:exdate];
            
            Expense* exp = [[Expense alloc] init:timeInMillisecond exname:exname excategory:excategory examount:examount exdate:exdate eximage:eximage userName:userName sheetId:sheetId isRepeating:isRepeating isSaved:isSaved];
            [data addObject:exp];
        }
    }else{
        NSLog(@"ERROR: addExpense failed %s",sqlite3_errmsg(database));
        return nil;
    }
    return data;
}

+(NSArray*)getExpensesForSheet:(sqlite3*)database sheetId:(NSString*)sheetId{
        NSMutableArray* data = [[NSMutableArray alloc] init];
        sqlite3_stmt *statment;
    
    const char *sqlStatement =[[NSString stringWithFormat:@"SELECT * from EXPENSES WHERE SHEET_ID = '%@'",sheetId ] cStringUsingEncoding:NSUTF8StringEncoding];
        
    if (sqlite3_prepare_v2(database, sqlStatement, -1,&statment,nil) == SQLITE_OK){
        while(sqlite3_step(statment) == SQLITE_ROW){
                
            NSString* timeInMillisecond = [NSString stringWithFormat:@"%s", sqlite3_column_text(statment,0)];
            NSString* exname = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,1)];
            NSString* excategory = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,2)];
            NSNumber* examount = [NSNumber numberWithInt:(int)sqlite3_column_int(statment,3)];
            NSString* exdate = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,4)];
            NSString* eximage = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,5)];
            NSString* userName = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,6)];
            NSString* sheetId = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,7)];
            NSNumber* isRepeating = [NSNumber numberWithInt:(int)sqlite3_column_int(statment,8)];
            NSNumber* isSaved = [NSNumber numberWithInt:(int)sqlite3_column_int(statment,9)];
                
            Expense* exp = [[Expense alloc] init:timeInMillisecond exname:exname excategory:excategory examount:examount exdate:exdate eximage:eximage userName:userName sheetId:sheetId isRepeating:isRepeating isSaved:isSaved];
            [data addObject:exp];
        }
    }else{
        NSLog(@"ERROR: addExpense failed %s",sqlite3_errmsg(database));
        return nil;
    }
    return data;
}

+(void)updateExpenses:(sqlite3*)database expenses:(NSArray*)expenses{
    for (Expense* exp in expenses) {
        [ExpenseSql addExpense:database exp:exp];
    }
}

+(void)updateExpense:(sqlite3*)database expense:(Expense *)exp{
    sqlite3_stmt *statment;
    NSString* query = [NSString stringWithFormat:@"UPDATE EXPENSES SET IS_SAVED = '%@' WHERE TIMEINMILLISECOND = '%@'", @(0), exp.userName];
    
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil) == SQLITE_OK){
            
        sqlite3_bind_text(statment, 1, [exp.timeInMillisecond UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 2, [exp.exname UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 3, [exp.excategory UTF8String],-1,NULL);
        sqlite3_bind_int(statment, 4, [exp.examount intValue]);
        sqlite3_bind_text(statment, 5, [exp.exdate UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 6, [exp.eximage UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 7, [exp.userName UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 8, [exp.sheetId UTF8String],-1,NULL);
        sqlite3_bind_int(statment, 9, [exp.isRepeating intValue]);
        sqlite3_bind_int(statment, 10, [exp.isSaved intValue]);
        
        char* errmsg;
        sqlite3_exec(database, "COMMIT", NULL, NULL, &errmsg);
        return;
        
    }
    NSLog(@"ERROR: addExpense failed %s",sqlite3_errmsg(database));
    }

// Adding Sheets
+(void)addSheet:(sqlite3 *)database sheetName:(NSString *)sheetName sheetId:(NSString *)sheetId{
    
    if(![ExpenseSql hasSheetId:database sheetId:sheetId]){
        
        sqlite3_stmt *statment;
        NSString* query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@,%@) values (?,?);", @"SHEETS",SHEET_ID, @"SHEET_NAME"];
        
        if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil) == SQLITE_OK){
            sqlite3_bind_text(statment, 1, [sheetId UTF8String],-1,NULL);
            sqlite3_bind_text(statment, 2, [sheetName UTF8String],-1,NULL);
            
            if(sqlite3_step(statment) == SQLITE_DONE){
                return;
            }
        }
        NSLog(@"ERROR: addExpense failed %s",sqlite3_errmsg(database));
    }
}

+(BOOL)hasSheetId:(sqlite3*)database sheetId:(NSString*)sheetId{
    sqlite3_stmt *statment;
    
    const char *sqlStatement =[[NSString stringWithFormat:@"SELECT * from SHEETS WHERE SHEET_ID = '%@'", sheetId] cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (sqlite3_prepare_v2(database, sqlStatement, -1,&statment,nil) == SQLITE_OK){
        while(sqlite3_step(statment) == SQLITE_ROW){
            return YES;
        }
    }else{
        NSLog(@"ERROR: check sheet failed %s",sqlite3_errmsg(database));
        return NO;
    }
    return NO;
}

+(void)addUserSheet:(sqlite3 *)database userName:(NSString *)userName sheetId:(NSString *)sheetId{
    
    if(![ExpenseSql hasUserSheet:database sheetId:sheetId] && ![ExpenseSql hasLocalUserSheet:database sheetId:sheetId]){
        
        sqlite3_stmt *statment;
        NSString* query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@,%@) values (?,?);", USER_SHEETS,USER_NAME, SHEET_ID];
        
        if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil) == SQLITE_OK){
            sqlite3_bind_text(statment, 1, [userName UTF8String],-1,NULL);
            sqlite3_bind_text(statment, 2, [sheetId UTF8String],-1,NULL);
            
            if(sqlite3_step(statment) == SQLITE_DONE){
                return;
            }
        }
        NSLog(@"ERROR: addExpense failed %s",sqlite3_errmsg(database));
    }
}

+(BOOL)hasUserSheet:(sqlite3*)database sheetId:(NSString*)sheetId{
    sqlite3_stmt *statment;
    NSString* userName = [Model instance].user;
    const char *sqlStatement =[[NSString stringWithFormat:@"SELECT * from USERS_SHEETS WHERE SHEET_ID = '%@' AND USER_NAME = '%@'", sheetId, userName] cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (sqlite3_prepare_v2(database, sqlStatement, -1,&statment,nil) == SQLITE_OK){
        while(sqlite3_step(statment) == SQLITE_ROW){
            return YES;
        }
    }else{
        NSLog(@"ERROR: check sheet failed %s",sqlite3_errmsg(database));
        return NO;
    }
    return NO;
}

+(BOOL)hasLocalUserSheet:(sqlite3*)database sheetId:(NSString*)sheetId{
    sqlite3_stmt *statment;
    NSString* userName = [Model instance].user;
    const char *sqlStatement =[[NSString stringWithFormat:@"SELECT * from USERS_SHEETS WHERE SHEET_ID = '%@' AND USER_NAME = '%@'", sheetId, userName] cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (sqlite3_prepare_v2(database, sqlStatement, -1,&statment,nil) == SQLITE_OK){
        while(sqlite3_step(statment) == SQLITE_ROW){
            return YES;
        }
    }else{
        NSLog(@"ERROR: check sheet failed %s",sqlite3_errmsg(database));
        return NO;
    }
    return NO;
}


@end
