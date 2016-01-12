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

@interface ModelSql : NSObject<ModelProtocol>{

   sqlite3* database;
}

-(NSString*)getExpensesLastUpdateDate;
-(void)setExpensesLastUpdateDate:(NSString*)date;
-(void)updateExpenses:(NSArray*)expenses;
-(void)addSheet:(NSString *)sheetName sheetId:(NSString *)sheetId;
-(void)updateExpense:(Expense *)expense;

@end
