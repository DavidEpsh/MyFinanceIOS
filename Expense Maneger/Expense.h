//
//  Expense.h
//  Expense Maneger
//
//  Created by Admin on 12/24/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expense : NSObject

@property NSString* timeInMillisecond;
@property NSString* exname;
@property NSString* excategory;
@property NSNumber* examount;
@property NSString* exdate;
@property NSString* eximage;
@property NSString* sheetId;
@property NSString* userName;
@property NSNumber* isRepeating;
@property NSNumber* isSaved;

-(id)init:(NSString*)timeInMillisecond exname:(NSString*)exname excategory:(NSString*)excategory examount:(NSNumber*)examount exdate:(NSString*)exdate eximage:(NSString*)eximage userName:(NSString*) userName sheetId:(NSString*)sheetId isRepeating:(NSNumber*)isRepeating isSaved:(NSNumber*)isSaved;

@end
