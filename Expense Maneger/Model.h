//
//  Model.h
//  Expense Maneger
//
//  Created by Admin on 12/24/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expense.h"
#import <UIKit/UIKit.h>

@protocol ModelProtocol <NSObject>

-(void)addExpense:(Expense*)exp;
-(void)deleteExpense:(Expense*)exp;
-(Expense*)getExpense:(NSString*)exname;
-(NSArray*)getExpenses;

-(void)saveImage:(UIImage*)image withName:(NSString*)eximage;
-(UIImage*)getImage:(NSString*)eximage;

@end

@protocol GetExpensesListener <NSObject>

-(void)done:(NSArray*)data;

@end


@interface Model : NSObject<ModelProtocol>{
    id<ModelProtocol> modelImpl;
}

+(Model*)instance;

-(void)addExpense:(Expense*)exp;

-(void)getExpensesAsynch:(void(^)(NSArray*))blockListener;
-(void)getExpenseImage:(Expense*)exp block:(void(^)(UIImage*))block;
-(void)saveExpenseImage:(Expense*)exp image:(UIImage*)image block:(void(^)(NSError*))block;

@end


