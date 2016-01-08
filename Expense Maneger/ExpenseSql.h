//
//  ExpenseSql.h
//  Expense Maneger
//
//  Created by Admin on 12/25/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expense.h"
#import <sqlite3.h>

@interface ExpenseSql : NSObject

+(void)addExpense:(sqlite3*)database exp:(Expense*)exp;
+(void)deleteExpense:(sqlite3*)database exp:(Expense*)exp;
+(Expense*)getExpense:(sqlite3*)database exname:(NSString*)exname;
+(NSArray*)getExpenses:(sqlite3*)database;

@end
