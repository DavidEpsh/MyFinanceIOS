//
//  ModelSql.h
//  Expense Maneger
//
//  Created by Admin on 12/25/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Model.h"

@interface ModelSql : NSObject<ModelProtocol>{

   sqlite3* database;
}

@end
