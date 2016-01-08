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
#import "ModelParse.h"

@implementation Model

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
     //   modelImpl = [[ModelSql alloc] init];
        modelImpl = [[ModelParse alloc] init];
    }
    return self;
}


-(void)addExpense:(Expense*)exp{
    [modelImpl addExpense:exp];
}

-(void)deleteExpense:(Expense*)exp;{
    [modelImpl deleteExpense:exp];
}

-(Expense*)getExpense:(NSString*)exname{
    return [modelImpl getExpense:exname];
}

-(NSArray*)getExpenses{
    return [modelImpl getExpenses];
}


//Block Asynch implementation
-(void)getExpensesAsynch:(void(^)(NSArray*))blockListener{
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    
    dispatch_async(myQueue, ^{
        //long operation
        NSArray* data = [modelImpl getExpenses];
        
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            blockListener(data);
        });
    } );
}


-(void)getExpenseImage:(Expense*)exp block:(void(^)(UIImage*))block{
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    
    dispatch_async(myQueue, ^{
        UIImage* image = [modelImpl getImage:exp.eximage];
        
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(image);
        });
    } );
}

-(void)saveExpenseImage:(Expense*)exp image:(UIImage*)image block:(void(^)(NSError*))block{
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    
    dispatch_async(myQueue, ^{
        [modelImpl saveImage:image withName:exp.eximage];
        
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(nil);
        });
    } );
}


@end
