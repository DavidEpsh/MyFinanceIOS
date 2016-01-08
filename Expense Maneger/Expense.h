//
//  Expense.h
//  Expense Maneger
//
//  Created by Admin on 12/24/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expense : NSObject

@property NSNumber* timeInMillisecond;
@property NSString* exname;
@property NSString* excategory;
@property NSNumber* examount;
@property NSDate* exdate;
@property NSString* eximage;

-(id)init:(NSNumber*)timeInMillisecond exname:(NSString*)exname excategory:(NSString*)excategory examount:(NSNumber*)examount exdate:(NSDate*)exdate eximage:(NSString*)eximage;

@end
