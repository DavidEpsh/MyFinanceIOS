//
//  Model.h
//  Expense Maneger
//
//  Created by Admin on 12/24/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expense.h"
#import <sqlite3.h>
#import <UIKit/UIKit.h>

@protocol GetExpensesListener <NSObject>

-(void)done:(NSArray*)data;

@end

@interface Model : NSObject{
}

@property NSString* user;

+(Model*)instance;
//-(void)getExpensesAsynch:(void(^)(NSArray*))blockListener;
-(void)getExpenseImage:(Expense*)exp block:(void(^)(UIImage*))block;
-(void)saveExpenseImage:(Expense*)exp image:(UIImage*)image block:(void(^)(NSError*))block;
-(void)login:(NSString*)user pwd:(NSString*)pwd block:(void(^)(BOOL))block;
-(void)signup:(NSString*)user pwd:(NSString*)pwd block:(void(^)(BOOL))block;
-(void)getAllRelevantExpensesAsync:(void(^)(NSError*))block;
-(void)addExp:(Expense*)exp withParse:(BOOL)withParse;
-(void)updateExpense:(Expense*)exp;
//-(void)newExpense:(Expense*)exp withParse:(BOOL)withParse;
-(NSString*)getCurrentUser;
-(void)addUserSheet:(NSString *)userName sheetId:(NSString *)sheetId withParse:(BOOL)withParse;
//-(BOOL)checkHasLocalUserSheet:(NSString *)sheetId;
-(void)done:(NSArray*)data;

-(NSArray*)getExpensesForSheet:(NSString*)sheetId useSheetName:(BOOL)useSheetName;
-(void)addSheet:(NSString *)sheetName sheetId:(NSString *)sheetId withParse:(BOOL)withParse;
-(NSArray*)getAllSheetNames;
-(NSString*)getSheetId:(NSString*)sheetName;

@end


