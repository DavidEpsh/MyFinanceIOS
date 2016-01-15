
#import "ModelParse.h"
#import <Parse/Parse.h>
#import "ModelSql.h"
#import "ExpenseSql.h"

static NSString* currUser;

static NSString* EXPENSE_TABLE = @"Expense";
static NSString* SHEETS_TABLE = @"Sheets";
static NSString* USERS_SHEETS_TABLE = @"UsersSheets";

static NSString* SHEET_NAME = @"sheetName";
static NSString* TIMEINMILLISECOND = @"timeInMillisecond";
static NSString* EXPENSE_NAME = @"exname";
static NSString* EXPENSE_CATEGORY = @"excategory";
static NSString* EXPENSE_ID = @"expenseId";
static NSString* EXPENSE_AMOUNT = @"examount";
static NSString* EXPENSE_DATE = @"exdate";
static NSString* EXPENSE_IMAGE = @"eximage";
static NSString* USER_NAME = @"userName";
static NSString* SHEET_ID = @"sheetId";
static NSString* IS_REPEATING = @"isRepeating";
static NSString* IS_SAVED = @"isSaved";

@implementation ModelParse

-(id)init{
    self = [super init];
    if (self) {
        [Parse setApplicationId:@"chS1wnWUGYyBcPa3jOnJBRwS7xoPySO1YHRMi39u"
                      clientKey:@"xNyC1VQxlVEWtGPTK7vhg0y5oYXnnPCaZGEaCEti"];
    }
    return self;
}

-(NSString*)getCurrentUser{
    PFUser* user = [PFUser currentUser];
    if (user != nil) {
        return user.username;
    }else{
        return nil;
    }
}

-(BOOL)login:(NSString*)user pwd:(NSString*)pwd{
    NSError* error;
    PFUser* puser = [PFUser logInWithUsername:user password:pwd error:&error];    if (error == nil && puser != nil) {
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


-(void)addExp:(Expense*)exp withParse:(BOOL)withParse{
    PFObject *obj = [PFObject objectWithClassName:@"Expense"];
    obj[@"timeInMillisecond"] = exp.timeInMillisecond;
    obj[@"exname"] = exp.exname;
    obj[@"excategory"] = exp.excategory;
    obj[@"examount"] = exp.examount;
    obj[@"exdate"] = exp.exdate;
    obj[@"eximage"] = exp.eximage;
    obj[@"userName"] = exp.userName;
    obj[@"sheetId"] = exp.sheetId;
    obj[@"isRepeating"] = exp.isRepeating;
    obj[@"isSaved"] = exp.isSaved;
    [obj saveInBackground];
}

-(void)deleteExpense:(Expense*)exp{
   PFQuery* query = [PFQuery queryWithClassName:@"Expense"];
    [query whereKey:TIMEINMILLISECOND equalTo:exp.timeInMillisecond];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (PFObject* object in objects){
            object[IS_SAVED] = @(0);
        }
    }];

}

-(Expense*)getExpense:(NSDate*)exdate{
    Expense* expense = nil;
    PFQuery* query = [PFQuery queryWithClassName:@"Expense"];
    [query whereKey:@"exdate" equalTo:exdate];

    NSArray* res = [query findObjects];
    if (res.count == 1) {
        PFObject* obj = [res objectAtIndex:0];
    expense = [[Expense alloc] init:obj[@"timeInMillisecond"] exname:obj[@"exname"] excategory:obj[@"excategory"] examount:obj[@"examount"] exdate:obj[@"exdate"] eximage:obj[@"eximage"] userName:obj[@"userName"] sheetId:obj[@"sheetId"] isRepeating:obj[@"userName"] isSaved:obj[@"isSaved"]];
    }
    return expense;
}

-(void)getAllRelevantExpensesAsync{
//    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
//    dispatch_async(myQueue, ^{
        //long operation
        NSMutableArray* arrayUserNames = [[NSMutableArray alloc] init];
        NSMutableArray* arraySheetId = [[NSMutableArray alloc] init];
    
        currUser = [Model instance].user;

        PFQuery* queryFindUsersSheets = [PFQuery queryWithClassName:USERS_SHEETS_TABLE];
        [queryFindUsersSheets whereKey:USER_NAME equalTo:currUser];
        [queryFindUsersSheets findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            //Now we got all USERS_SHEETS -> Get all expense + get all sheets
            if (error == nil) {
                if (objects  == nil || [objects count] == 0) {
                    [ModelParse addUserSheetsToParse:currUser sheetId:currUser];
                    [arrayUserNames addObject:currUser];
                    [arraySheetId addObject:currUser];
                    [[Model instance] addUserSheet:currUser sheetId:currUser withParse:YES];
                }else{
                    for (PFObject* object in objects){
                        [arrayUserNames addObject:object[USER_NAME]];
                        [arraySheetId addObject:object[SHEET_ID]];
                        [[Model instance] addUserSheet:object[USER_NAME] sheetId:object[SHEET_ID] withParse:NO];
                    }
            }
            
            PFQuery* queryExpenses = [PFQuery queryWithClassName:EXPENSE_TABLE];
            [queryExpenses whereKey:USER_NAME containedIn:arrayUserNames];
            [queryExpenses whereKey:SHEET_ID containedIn:arraySheetId];
            [queryExpenses findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                //Now we got all Expenses -> inserting to SQL
                if (error == nil) {
                    for (PFObject* obj in objects){
                        Expense* expense = [[Expense alloc] init:obj[@"timeInMillisecond"] exname:obj[@"exname"] excategory:obj[@"excategory"] examount:obj[@"examount"] exdate:obj[@"exdate"] eximage:obj[@"eximage"] userName:obj[@"userName"] sheetId:obj[@"sheetId"] isRepeating:obj[@"userName"] isSaved:obj[@"isSaved"]];
                    
                        [[Model instance] addExp:expense withParse:NO];
                        
                    }
                    
                    PFQuery* queryFindSheets = [PFQuery queryWithClassName:SHEETS_TABLE];
                    [queryFindSheets whereKey:SHEET_ID containedIn:arraySheetId];
                    [queryFindSheets findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                        if(error == nil){
                            if (objects == nil || [objects count] == 0) {
                                [[Model instance]addSheet:@"My Account" sheetId:currUser withParse:YES];
                                [ModelParse addSheet:@"My Account" sheetId:currUser];
                            }
                            for(PFObject* obj in objects){
                                [[Model instance] addSheet:obj[SHEET_NAME] sheetId:obj[SHEET_ID] withParse:NO];
                            }
                            
                        }
                    }];
                    
                }
            }];
            
//            dispatch_queue_t mainQ = dispatch_get_main_queue();
//            dispatch_async(mainQ, ^{
//                block();
//            });
        }
        }];
    }

+(void)addSheet:(NSString*)sheetName sheetId:(NSString*)sheetId{
    PFObject *obj = [PFObject objectWithClassName:SHEETS_TABLE];
    obj[SHEET_ID] = sheetId;
    obj[SHEET_NAME] = sheetName;
    [obj saveInBackground];
}

+(void)addUserSheetsToParse:(NSString*)userNmae sheetId:(NSString*)sheetId{
    PFObject *obj = [PFObject objectWithClassName:USERS_SHEETS_TABLE];
    obj[SHEET_ID] = sheetId;
    obj[USER_NAME] = userNmae;
    [obj saveInBackground];
}

-(NSArray*)getAllRelevantExpenses{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    PFQuery* query = [PFQuery queryWithClassName:@"Expense"];
    
    NSArray* res = [query findObjects];
    for (PFObject* obj in res) {
        Expense* expense = [[Expense alloc] init:obj[@"timeInMillisecond"] exname:obj[@"exname"] excategory:obj[@"excategory"] examount:obj[@"examount"] exdate:obj[@"exdate"] eximage:obj[@"eximage"] userName:obj[@"userName"] sheetId:obj[@"sheetId"] isRepeating:obj[@"userName"] isSaved:obj[@"isSaved"]];
        [array addObject:expense];
    }
    return array;
    
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
        Expense* expense = [[Expense alloc] init:obj[TIMEINMILLISECOND] exname:obj[@"exname"] excategory:obj[@"excategory"] examount:obj[@"examount"] exdate:obj[@"exdate"] eximage:obj[@"eximage"] userName:obj[@"userName"] sheetId:obj[@"sheetId"] isRepeating:obj[@"userName"] isSaved:obj[@"isSaved"]];
        [array addObject:expense];
    }
    return array;
}


-(void)updateExpense:(Expense *)exp{
   PFQuery* query = [PFQuery queryWithClassName:EXPENSE_TABLE];
    [query whereKey:EXPENSE_ID equalTo:exp.timeInMillisecond];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (PFObject* obj in objects){
            obj[@"timeInMillisecond"] = exp.timeInMillisecond;
            obj[@"exname"] = exp.exname;
            obj[@"excategory"] = exp.excategory;
            obj[@"examount"] = exp.examount;
            obj[@"exdate"] = exp.exdate;
            obj[@"eximage"] = exp.eximage;
            obj[@"userName"] = exp.userName;
            obj[@"sheetId"] = exp.sheetId;
            obj[@"isRepeating"] = exp.isRepeating;
            obj[@"isSaved"] = exp.isSaved;
            [obj saveInBackground];
        }
    }];

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
