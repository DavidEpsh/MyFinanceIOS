//
//  ModelParse.h
//  Expense Maneger
//
//  Created by Admin on 1/6/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import <UIKit/UIKit.h>

@interface ModelParse : NSObject

-(void)deleteExpense:(Expense*)exp;
-(void)saveImage:(UIImage*)image withName:(NSString*)eximage;
-(UIImage*)getImage:(NSString*)eximage;
-(BOOL)login:(NSString*)user pwd:(NSString*)pwd;
-(BOOL)signup:(NSString*)user pwd:(NSString*)pwd;
-(NSArray*)getExpensesFromDate:(NSString*)date;
-(NSArray*)getAllRelevantExpenses;
-(void)getAllRelevantExpensesAsync;
-(NSString*)getCurrentUser;
-(void)updateExpense:(Expense *)exp;
-(void)addExp:(Expense*)exp withParse:(BOOL)withParse;

-(void)addUserSheetsToParse:(NSString*)userNmae sheetId:(NSString*)sheetId;
-(void)addSheet:(NSString*)sheetName sheetId:(NSString*)sheetId;


@end
