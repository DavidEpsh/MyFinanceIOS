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

@protocol ModelProtocol <NSObject>

-(void)addExp:(Expense*)exp withParse:(BOOL)withParse;
-(void)deleteExpense:(Expense*)exp;
-(Expense*)getExpense:(NSString*)exname;
-(NSArray*)getExpenses;
-(void)saveImage:(UIImage*)image withName:(NSString*)eximage;
-(UIImage*)getImage:(NSString*)eximage;
-(void)updateExpense:(Expense*)exp;
-(BOOL)login:(NSString*)user pwd:(NSString*)pwd;
-(BOOL)signup:(NSString*)user pwd:(NSString*)pwd;
-(void)getAllRelevantExpensesAsync;
-(void)newExpense:(Expense*)exp withParse:(BOOL)withParse;
-(NSString*)getCurrentUser;
-(NSArray*)getExpensesForSheet:(NSString*)sheetId;
-(void)addUserSheetToSQL:(NSString *)userName sheetId:(NSString *)sheetId;
-(BOOL)checkHasLocalUserSheet:(NSString *)sheetId;
-(void)addSheetToSql:(NSString*)sheetName sheetId:(NSString*)sheetId;

@end

@protocol GetExpensesListener <NSObject>

-(void)done:(NSArray*)data;

@end


@interface Model : NSObject{
    id<ModelProtocol> parseModelImpl;
    id<ModelProtocol> sqlModelImpl;
    
}

@property NSString* user;

+(Model*)instance;

-(void)addExp:(Expense*)exp withParse:(BOOL)withParse;
-(void)addSheet:(NSString *)sheetName sheetId:(NSString *)sheetId;
-(void)updateExpense:(Expense*)exp;
-(void)getExpensesAsynch:(void(^)(NSArray*))blockListener;
-(void)getExpenseImage:(Expense*)exp block:(void(^)(UIImage*))block;
-(void)saveExpenseImage:(Expense*)exp image:(UIImage*)image block:(void(^)(NSError*))block;
-(NSString*)getCurrentUser;
-(void)login:(NSString*)user pwd:(NSString*)pwd block:(void(^)(BOOL))block;
-(void)signup:(NSString*)user pwd:(NSString*)pwd block:(void(^)(BOOL))block;
-(void)getAllRelevantExpensesAsync:(void(^)(NSError*))block;
-(NSArray*)getExpensesForSheet:(NSString*)sheetId;
-(void)newExpense:(Expense*)exp withParse:(BOOL)withParse;
-(void)addSheetToSql:(NSString*)sheetName sheetId:(NSString*)sheetId;
-(void)addUserSheetToSQL:(NSString *)userName sheetId:(NSString *)sheetId;
-(BOOL)checkHasLocalUserSheet:(NSString *)sheetId;

@end


