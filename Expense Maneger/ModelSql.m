//
//  ModelSql.m
//  Expense Maneger
//
//  Created by Admin on 12/25/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import "ModelSql.h"
#import "ExpenseSql.h"

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
        
        
        //Creating tables (first time - in "Model")
        char* errormsg;
        
        res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS EXPENSES (TIMEINMILLISECOND TIMESTAMP(8) PRIMARY KEY, NAME TEXT, CATEGORY TEXT, AMOUNT, DATE TEXT, IMAGE_NAME TEXT)", NULL, NULL, &errormsg);
        
        if(res != SQLITE_OK){
            NSLog(@"ERROR: failed creating EXPENSES table");
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


@end
