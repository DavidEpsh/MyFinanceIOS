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

@interface ModelParse : NSObject <ModelProtocol>

-(NSArray*)getExpensesFromDate:(NSString*)date;
-(NSArray*)getAllRelevantExpenses;
-(NSString*)getCurrentUser;

@end
