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

-(void)addExp:(Expense*)exp withParse:(BOOL)withParse;

-(void)updateExpense:(Expense*)exp;

-(void)getAllRelevantExpensesAsync;
-(void)newExpense:(Expense*)exp withParse:(BOOL)withParse;
-(NSString*)getCurrentUser;
-(NSArray*)getExpensesForSheet:(NSString*)sheetId;
-(void)addUserSheetToSQL:(NSString *)userName sheetId:(NSString *)sheetId;
-(BOOL)checkHasLocalUserSheet:(NSString *)sheetId;
-(void)addSheetToSql:(NSString*)sheetName sheetId:(NSString*)sheetId;

-(void)done:(NSArray*)data;


@property NSString* user;
+(Model*)instance;


-(void)addSheet:(NSString *)sheetName sheetId:(NSString *)sheetId;

-(void)getExpensesAsynch:(void(^)(NSArray*))blockListener;
-(void)getExpenseImage:(Expense*)exp block:(void(^)(UIImage*))block;
-(void)saveExpenseImage:(Expense*)exp image:(UIImage*)image block:(void(^)(NSError*))block;

-(void)login:(NSString*)user pwd:(NSString*)pwd block:(void(^)(BOOL))block;
-(void)signup:(NSString*)user pwd:(NSString*)pwd block:(void(^)(BOOL))block;
-(void)getAllRelevantExpensesAsync:(void(^)(NSError*))block;
@end


