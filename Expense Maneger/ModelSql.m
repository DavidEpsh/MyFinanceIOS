//
//  ModelSql.m
//  Expense Maneger
//
//  Created by Admin on 12/25/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import "ModelSql.h"
#import "ExpenseSql.h"
#import "LastUpdateSql.h"


@implementation ModelSql

-(id)init{
    self = [super init];
    if (self) {
        
        //Getting database reference
        NSFileManager* fileManager = [NSFileManager defaultManager];
        
        NSArray* paths = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        
        NSURL* directoryUrl = [paths objectAtIndex:0];
        
        NSURL* fileUrl = [directoryUrl URLByAppendingPathComponent:@"database.sqlite"];

        //Open the database
        NSString* filePath = [fileUrl path];
        
        const char* cFilePath = [filePath UTF8String];
        
        int res = sqlite3_open(cFilePath,&database);
        
        if(res != SQLITE_OK){
            NSLog(@"ERROR: fail to open db");
            database = nil;
        }
        
        [ExpenseSql createTable:database];
        [LastUpdateSql createTable:database];
        
        //Creating tables (first time - in "Model")
        char* errormsg;
        
        res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS EXPENSES (TIMEINMILLISECOND TEXT PRIMARY KEY, NAME TEXT, CATEGORY TEXT, AMOUNT INTEGER, DATE TEXT, IMAGE_NAME TEXT, USER_NAME TEXT, SHEET_ID TEXT, IS_REPEATING INTEGER, IS_SAVED INTEGER)", NULL, NULL, &errormsg);
        
        if(res != SQLITE_OK){
            NSLog(@"ERROR: failed creating EXPENSES table");
        }
        
        res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS SHEETS (SHEET_ID TEXT PRIMARY KEY, SHEET_NAME TEXT)", NULL, NULL, &errormsg);
        
        if(res != SQLITE_OK){
            NSLog(@"ERROR: failed creating SHEETS table");
        }
        
        res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS USERS_SHEETS (USER_NAME TEXT, SHEET_ID TEXT, FOREIGN KEY(SHEET_ID) REFERENCES SHEETS(SHEET_ID) PRIMARY KEY(USER_NAME, SHEET_ID))", NULL, NULL, &errormsg);
        
        if(res != SQLITE_OK){
            NSLog(@"ERROR: failed creating USER_SHEETS table");
        }
    }
    return  self;
}

-(void)addExpense:(Expense *)exp{
    [ExpenseSql addExpense:database exp:exp];
}
-(void)deleteExpense:(Expense *)exp{
    [ExpenseSql deleteExpense:database exp:exp];
}

-(Expense*)getExpense:(NSString *)expenseId{
    return [ExpenseSql getExpense:database exname:expenseId];
}

-(NSArray*)getExpenses{
    return [ExpenseSql getExpenses:database];
}

-(NSString*)getExpensesLastUpdateDate{
    return [ExpenseSql getLastUpdateDate:database];
}

-(void)setExpensesLastUpdateDate:(NSString*)date{
    [ExpenseSql setLastUpdateDate:database date:date];
}

-(void)updateExpenses:(NSArray*)expenses{
    [ExpenseSql updateExpenses:database expenses:expenses];
}

-(void)updateExpense:(Expense *)expense{
    [ExpenseSql updateExpense:database expense:expense];
}

-(BOOL)login:(NSString*)user pwd:(NSString*)pwd{
    return  NO;
}

-(BOOL)Signup:(NSString*)user pwd:(NSString*)pwd{
    return  NO;
}

// Adding Sheets
+(void)addSheet:(sqlite3 *)database sheetName:(NSString *)sheetName sheetId:(NSString *)sheetId{
    
    if([ModelSql hasSheetId:database sheetId:sheetId]){
        
    }else{
        sqlite3_stmt *statment;
        
        const char *sqlStatement =[[NSString stringWithFormat:@"SELECT * from SHEETS WHERE SHEET_ID = '%@'", sheetId] cStringUsingEncoding:NSUTF8StringEncoding];
        
        if (sqlite3_prepare_v2(database, sqlStatement, -1,&statment,nil) == SQLITE_OK){
            while(sqlite3_step(statment) == SQLITE_ROW){
                sqlite3_bind_text(statment, 1, [sheetId UTF8String], -1, NULL);
                sqlite3_bind_text(statment, 2, [sheetName UTF8String], -1, NULL);
            }
        }else{
            NSLog(@"ERROR: check sheet failed %s",sqlite3_errmsg(database));
        }
    }
}

+(BOOL)hasSheetId:(sqlite3*)database sheetId:(NSString*)sheetId{
    sqlite3_stmt *statment;
    
    const char *sqlStatement =[[NSString stringWithFormat:@"SELECT * from SHEETS WHERE SHEET_ID = '%@'", sheetId] cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (sqlite3_prepare_v2(database, sqlStatement, -1,&statment,nil) == SQLITE_OK){
        while(sqlite3_step(statment) == SQLITE_ROW){
            return true;
        }
    }else{
        NSLog(@"ERROR: check sheet failed %s",sqlite3_errmsg(database));
        return nil;
    }
    return false;
}
// Adding sheets



@end
