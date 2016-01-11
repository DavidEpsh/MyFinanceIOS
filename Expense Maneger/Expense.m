//
//  Expense.m
//  Expense Maneger
//
//  Created by Admin on 12/24/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import "Expense.h"

@implementation Expense

-(id)init:(NSString*)timeInMillisecond exname:(NSString*)exname excategory:(NSString*)excategory examount:(NSNumber*)examount exdate:(NSString*)exdate eximage:(NSString*)eximage userName:(NSString*)userName sheetId:(NSString*)sheetId isRepeating:(NSNumber*)isRepeating isSaved:(NSNumber*)isSaved {
    self = [super init];
    if (self){
        _timeInMillisecond = timeInMillisecond;
        _exname = exname;
        _excategory = excategory;
        _examount = examount;
        _exdate = exdate;
        _eximage = eximage;
        _userName = userName;
        _sheetId = sheetId;
        _isRepeating = isRepeating;
        _isSaved = isSaved;
    }
    return  self;
}

@end
