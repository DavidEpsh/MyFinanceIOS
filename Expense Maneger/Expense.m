//
//  Expense.m
//  Expense Maneger
//
//  Created by Admin on 12/24/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import "Expense.h"

@implementation Expense

-(id)init:(NSNumber*)timeInMillisecond exname:(NSString*)exname excategory:(NSString*)excategory examount:(NSNumber*)examount exdate:(NSDate*)exdate eximage:(NSString*)eximage{
    self = [super init];
    if (self){
        _timeInMillisecond = timeInMillisecond;
        _exname = exname;
        _excategory = excategory;
        _examount = examount;
        _exdate = exdate;
        _eximage = eximage;
    }
    return  self;
}

@end
