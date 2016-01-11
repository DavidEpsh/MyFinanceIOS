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
        
        NSURL* fileUrl = [directoryUrl URLByAppendingPathComponent:@"database.db"];

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
        
        res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS USER_SHEETS (USER_NAME TEXT, SHEET_ID TEXT, FOREIGN KEY(SHEET_ID) REFERENCES SHEETS(SHEET_ID) PRIMARY KEY(USER_NAME, SHEET_ID))", NULL, NULL, &errormsg);
        
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

-(Expense*)getExpense:(NSString *)exname{
    return [ExpenseSql getExpense:database exname:exname];
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


-(BOOL)login:(NSString*)user pwd:(NSString*)pwd{
    return  NO;
}

-(BOOL)signup:(NSString*)user pwd:(NSString*)pwd{
    return  NO;
}

@end
