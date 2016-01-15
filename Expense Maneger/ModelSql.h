//
//  ModelSql.h
//  Expense Maneger
//
//  Created by Admin on 12/25/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Model.h"
#import "Expense.h"

@interface ModelSql : NSObject{

   sqlite3* database;
}

-(void)deleteExpense:(Expense*)exp;
-(NSString*)getExpensesLastUpdateDate;
-(void)setExpensesLastUpdateDate:(NSString*)date;
-(void)updateExpenses:(NSArray*)expenses;
-(void)addSheet:(NSString *)sheetName sheetId:(NSString *)sheetId;
-(void)updateExpense:(Expense *)expense;
-(NSArray*)getExpensesForSheet:(NSString*)sheetId;
-(void)addExp:(Expense*)exp withParse:(BOOL)withParse;
-(void)newExpense:(Expense*)exp withParse:(BOOL)withParse;
//-(void)addUserSheet:(NSString *)userName sheetId:(NSString *)sheetId;
-(BOOL)checkHasLocalUserSheet:(NSString*)sheetId;
-(void)addUserSheetToSQL:(NSString *)userName sheetId:(NSString *)sheetId;
-(NSArray*)getAllSheetNames;

@end
