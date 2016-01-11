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

@interface ExpenseSql()

@end

@implementation ExpenseSql

static NSString* EXPENSE_TABLE = @"EXPENSES";
static NSString* TIMEINMILLISECOND = @"TIMEINMILLISECOND";
static NSString* EXPENSE_NAME = @"NAME";
static NSString* EXPENSE_CATEGORY = @"CATEGORY";
static NSString* EXPENSE_AMOUNT = @"AMOUNT";
static NSString* EXPENSE_DATE = @"DATE";
static NSString* EXPENSE_IMAGE = @"IMAGE_NAME";

+(BOOL)createTable:(sqlite3*)database{
    char* errormsg;
    
    NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT)",EXPENSE_TABLE,TIMEINMILLISECOND,EXPENSE_NAME,EXPENSE_CATEGORY,EXPENSE_AMOUNT,EXPENSE_DATE,EXPENSE_IMAGE];
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
    NSString* query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@,%@,%@,%@,%@,%@) values (?,?,?,?,?,?);",EXPENSE_TABLE,TIMEINMILLISECOND,EXPENSE_NAME,EXPENSE_CATEGORY,EXPENSE_AMOUNT,EXPENSE_DATE,EXPENSE_IMAGE];
    
  
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil) == SQLITE_OK){
        
        NSString* st_timeInMillisecond = [NSString stringWithFormat:@"%@", exp.timeInMillisecond];
        sqlite3_bind_text(statment, 1, [st_timeInMillisecond UTF8String],-1,NULL);
        
        sqlite3_bind_text(statment, 2, [exp.exname UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 3, [exp.excategory UTF8String],-1,NULL);
      
        sqlite3_bind_double(statment, 4, [exp.examount doubleValue]);
        
        NSString* st_exdate = [NSString stringWithFormat:@"%@", exp.exdate];
        sqlite3_bind_text(statment, 5, [st_exdate UTF8String],-1,NULL);
        
        sqlite3_bind_text(statment, 6, [exp.eximage UTF8String],-1,NULL);
        if(sqlite3_step(statment) == SQLITE_DONE){
            return;
        }
    }
    NSLog(@"ERROR: addExpense failed %s",sqlite3_errmsg(database));
}


+(void)deleteExpense:(sqlite3 *)database exp:(Expense *)exp{
}

+(Expense*)getExpense:(sqlite3 *)database exname:(NSString *)exname{
    return nil;
}

+(NSArray*)getExpenses:(sqlite3 *)database{
    NSMutableArray* data = [[NSMutableArray alloc] init];
    sqlite3_stmt *statment;
 
    if (sqlite3_prepare_v2(database,"SELECT * from EXPENSES;", -1,&statment,nil) == SQLITE_OK){
        while(sqlite3_step(statment) == SQLITE_ROW){
            
            NSNumber* timeInMillisecond = [NSNumber numberWithLong:(long)sqlite3_column_text(statment,0)];
            NSString* exname = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,1)];
            NSString* excategory = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,2)];
            
            NSNumber* examount = [NSNumber numberWithDouble:(double)sqlite3_column_double(statment,3)];
            NSString* exdate = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,4)];
            NSString* eximage = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,5)];
            
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            NSDate* my_exdate = [dateFormat dateFromString:exdate];
            
            Expense* exp = [[Expense alloc] init:timeInMillisecond exname:exname excategory:excategory examount:examount exdate:my_exdate eximage:eximage];
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


@end
