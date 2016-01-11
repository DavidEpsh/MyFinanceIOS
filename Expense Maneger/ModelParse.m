//
//  ModelParse.m
//  Expense Maneger
//
//  Created by Admin on 1/6/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import "ModelParse.h"
#import <Parse/Parse.h>

static NSString* currUser;

@implementation ModelParse

-(id)init{
    self = [super init];
    if (self) {
        [Parse setApplicationId:@"chS1wnWUGYyBcPa3jOnJBRwS7xoPySO1YHRMi39u"
                      clientKey:@"xNyC1VQxlVEWtGPTK7vhg0y5oYXnnPCaZGEaCEti"];
    }
    return self;
}

-(BOOL)login:(NSString*)user pwd:(NSString*)pwd{
    NSError* error;
    PFUser* puser = [PFUser logInWithUsername:user password:pwd error:&error];
    if (error == nil && puser != nil) {
        return YES;
    }
    return NO;
}

-(BOOL)signup:(NSString*)user pwd:(NSString*)pwd{
    NSError* error;
    PFUser* puser = [PFUser user];
    puser.username = user;
    puser.password = pwd;
    return [puser signUp:&error];
}


-(void)addExpense:(Expense*)exp{
    PFObject *obj = [PFObject objectWithClassName:@"Expense"];
    obj[@"timeInMillisecond"] = exp.timeInMillisecond;
    obj[@"exname"] = exp.exname;
    obj[@"excategory"] = exp.excategory;
    obj[@"examount"] = exp.examount;
    obj[@"exdate"] = exp.exdate;
    obj[@"eximage"] = exp.eximage;
    obj[@"userName"] = exp.userName;
    obj[@"sheetIt"] = exp.sheetId;
    [obj save];
}

-(void)deleteExpense:(Expense*)exp{
   PFQuery* query = [PFQuery queryWithClassName:@"Expense"];
    [query whereKey:@"timeInMillisecond" equalTo:exp.timeInMillisecond];
    NSArray* res = [query findObjects];
    if (res.count == 1) {
        PFObject* obj = [res objectAtIndex:0];
        [obj delete];
        [obj save];
    }
}

-(Expense*)getExpense:(NSDate*)exdate{
    Expense* expense = nil;
    PFQuery* query = [PFQuery queryWithClassName:@"Expense"];
    [query whereKey:@"exdate" equalTo:exdate];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSCalendarUnitYearForWeekOfYear |NSCalendarUnitYear |NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth |NSCalendarUnitWeekday fromDate:exdate];
    [comps setWeekday:1]; // 2: monday
    NSDate *firstDayOfTheWeek = [calendar dateFromComponents:comps];
    [comps setWeekday:7]; // 7: saturday
    NSDate *lastDayOfTheWeek = [calendar dateFromComponents:comps];
    
    NSArray* res = [query findObjects];
    if (res.count == 1) {
        PFObject* obj = [res objectAtIndex:0];
    expense = [[Expense alloc] init:obj[@"timeInMillisecond"] exname:obj[@"exname"] excategory:obj[@"excategory"] examount:obj[@"examount"] exdate:obj[@"exdate"] eximage:obj[@"eximage"] userName:obj[@"userName"] sheetId:obj[@"sheetId"] isRepeating:obj[@"userName"] isSaved:obj[@"isSaved"]];//Zarih Leyazer object shel Expense she me-toh ha-PFObject kibalti be-hazar
 /*
    NSArray* res = [query findObjects];
    if (res.count == 1) {
        PFObject* obj = [res objectAtIndex:0];
  //Zarih Leyazer object shel Expense she me-toh ha-PFObject kibalti be-hazara
        expense = [[Expense alloc] init:obj[@"timeInMillisecond"] exname:obj[@"exname"] excategory:obj[@"excategory"] examount:obj[@"examount"] exdate:obj[@"exdate"] eximage:obj[@"eximage"]];
  
     //find expense according to Name
         NSArray* objs = [query findObjects];
         for (PFObject* obj in objs) {
         NSString* exname = obj[@"exname"];
         NSLog(@"Expense name: %@", exname);
         }
 */
    }
    return expense;
}

-(NSArray*)getExpenses{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    PFQuery* query = [PFQuery queryWithClassName:@"Expense"];
    NSArray* res = [query findObjects];
    for (PFObject* obj in res) {
        Expense* expense = [[Expense alloc] init:obj[@"timeInMillisecond"] exname:obj[@"exname"] excategory:obj[@"excategory"] examount:obj[@"examount"] exdate:obj[@"exdate"] eximage:obj[@"eximage"] userName:obj[@"userName"] sheetId:obj[@"sheetId"] isRepeating:obj[@"userName"] isSaved:obj[@"isSaved"]];
        [array addObject:expense];
    }
    return array;

}
-(NSArray*)getExpensesFromDate:(NSString*)date{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    PFQuery* query = [PFQuery queryWithClassName:@"Expenses"];
    [query whereKey:@"updatedAt" greaterThanOrEqualTo:date];
    
    NSArray* res = [query findObjects];
    for (PFObject* obj in res) {
        Expense* expense = [[Expense alloc] init:obj[@"timeInMillisecond"] exname:obj[@"exname"] excategory:obj[@"excategory"] examount:obj[@"examount"] exdate:obj[@"exdate"] eximage:obj[@"eximage"] userName:obj[@"userName"] sheetId:obj[@"sheetId"] isRepeating:obj[@"userName"] isSaved:obj[@"isSaved"]];
        [array addObject:expense];
    }
    return array;
}


-(void)updateExpense:(NSString*)exname{
   PFQuery* query = [PFQuery queryWithClassName:@"Expenses"];
    NSArray* objs = [query findObjects];
    for (PFObject* obj in objs){
        NSString* exname = obj[@"exname"];
        if ([exname isEqualToString:@"Humburger"]){
            obj[@"exname"] = @"new exname";
            [obj save];
        }
        NSLog(@"Expense name: %@", exname);
 
    }
}

-(void)saveImage:(UIImage*)image withName:(NSString*)eximage{
    NSData* imageData = UIImageJPEGRepresentation(image,0);
    
    PFFile* file = [PFFile fileWithName:eximage data:imageData];
    PFObject* fileobj = [PFObject objectWithClassName:@"Images"];
    fileobj[@"eximage"] = eximage;
    fileobj[@"file"] = file;
    [fileobj save];
}

-(UIImage*)getImage:(NSString*)eximage{
    PFQuery* query = [PFQuery queryWithClassName:@"Images"];
    [query whereKey:@"eximage" equalTo:eximage];
    NSArray* res = [query findObjects];
    UIImage* image = nil;
    if (res.count == 1) {
        PFObject* imObj = [res objectAtIndex:0];
        PFFile* file = imObj[@"file"];
        NSData* data = [file getData];
        image = [UIImage imageWithData:data];
    }
    return image;
}


@end
