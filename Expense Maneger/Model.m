//
//  Model.m
//  Expense Maneger
//
//  Created by Admin on 12/24/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import "Model.h"
#import <sqlite3.h>
#import "ModelSql.h"
#import "ExpenseSql.h"
#import "ModelParse.h"
#import "LastUpdateSql.h"

@implementation Model{
    ModelParse* parseModelImpl;
    ModelSql* sqlModelImpl;
}

static Model* instance = nil;

+(Model*)instance{
    @synchronized(self) {
        if (instance == nil) {
            instance = [[Model alloc] init];
        }
    }
    return instance;
}

-(id)init{ 
    self = [super init];
    if (self) {
        sqlModelImpl = [[ModelSql alloc] init];
        parseModelImpl = [[ModelParse alloc] init];
    //    _user = [parseModelImpl getCurrentUser];

    }
    return self;
}

-(NSArray*)getAllSheetNames{
    return [sqlModelImpl getAllSheetNames];
}

-(void)login:(NSString*)user pwd:(NSString*)pwd block:(void(^)(BOOL))block{
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    
    dispatch_async(myQueue, ^{
        //long operation
        BOOL res = [parseModelImpl login:user pwd:pwd];
        if (res) {
            self.user = user;
        }
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(res);
        });
    } );

}
-(void)signup:(NSString*)user pwd:(NSString*)pwd block:(void(^)(BOOL))block{
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    
    dispatch_async(myQueue, ^{
        //long operation
        BOOL res = [parseModelImpl signup:user pwd:pwd];
        
        if (res) {
            self.user = user;
        }
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(res);
        });
    } );

}


-(void)updateExpense:(Expense*)exp{
    [sqlModelImpl updateExpense:exp];
    [parseModelImpl updateExpense:exp];
}

-(void)addExp:(Expense*)exp withParse:(BOOL)withParse{
    
    [sqlModelImpl newExpense:exp withParse:NO];
    if (withParse) {
        [parseModelImpl addExp:exp withParse:NO];
    }
}

-(void)deleteExpense:(Expense*)exp;{
    [sqlModelImpl deleteExpense:exp];
    [parseModelImpl deleteExpense:exp];

}
-(NSString*)getCurrentUser{
    return [parseModelImpl getCurrentUser];
}

-(void)addSheet:(NSString*)sheetName sheetId:(NSString*)sheetId withParse:(BOOL)withParse{
    [sqlModelImpl addSheet:sheetName sheetId:sheetId];
    
    if (withParse) {
        [parseModelImpl addSheet:sheetName sheetId:sheetId];
    }
}

-(void)addUserSheet:(NSString *)userName sheetId:(NSString *)sheetId withParse:(BOOL)withParse{
    [sqlModelImpl addUserSheetToSQL:userName sheetId:sheetId];
    
    if(withParse){
        [parseModelImpl addUserSheetsToParse:userName sheetId:sheetId];
    }
}

-(void)getAllRelevantExpensesAsync:(void(^)(NSError*))block{
    dispatch_queue_t myQueue = dispatch_queue_create("myQueueName", NULL);
    
    dispatch_async(myQueue, ^{
        [parseModelImpl getAllRelevantExpensesAsync];
        
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(nil);
        });
    } );
}

-(NSArray*)getExpensesForSheet:(NSString*)sheetId{
    return [sqlModelImpl getExpensesForSheet:sheetId];
}

-(void)getExpenseImage:(Expense*)exp block:(void(^)(UIImage*))block{
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    
    dispatch_async(myQueue, ^{
        //first try to get the image from local file
        UIImage* image = [self readingImageFromFile:exp.eximage];
        
        //if failed to get image from file try to get it from parse
        if(image == nil){
            image = [parseModelImpl getImage:exp.eximage];
            //one the image is loaded save it localy
            if(image != nil){
                [self savingImageToFile:image fileName:exp.eximage];
            }
    }
        
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(image);
        });
    } );
}

-(void)saveExpenseImage:(Expense*)exp image:(UIImage*)image block:(void(^)(NSError*))block{
    dispatch_queue_t myQueue = dispatch_queue_create("myQueueName", NULL);
    
    dispatch_async(myQueue, ^{
        //save the image to parse
        [parseModelImpl saveImage:image withName:exp.eximage];
        //save the image localy
        [self savingImageToFile:image fileName:exp.eximage];
        
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(nil);
        });
    } );
}

// Working with local files

-(void)savingImageToFile:(UIImage*)image fileName:(NSString*)fileName{
    NSData *pngData = UIImagePNGRepresentation(image);
    [self saveToFile:pngData fileName:fileName];
}

-(UIImage*)readingImageFromFile:(NSString*)fileName{
    NSData* pngData = [self readFromFile:fileName];
    if (pngData == nil) return nil;
    return [UIImage imageWithData:pngData];
}


-(NSString*)getLocalFilePath:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    return filePath;
}

-(void)saveToFile:(NSData*)data fileName:(NSString*)fileName{
    NSString* filePath = [self getLocalFilePath:fileName];
    [data writeToFile:filePath atomically:YES]; //Write the file
}

-(NSData*)readFromFile:(NSString*)fileName{
    NSString* filePath = [self getLocalFilePath:fileName];
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    return pngData;
}

@end
