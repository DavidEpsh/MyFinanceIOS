//
//  LastUpdateSql.h
//  Expense Maneger
//
//  Created by Admin on 1/9/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface LastUpdateSql : NSObject

+(BOOL)createTable:(sqlite3*)database;
+(NSString*)getLastUpdateDate:(sqlite3*)database forTable:(NSString*)table;
+(void)setLastUpdateDate:(sqlite3*)database date:(NSString*)date forTable:(NSString*)table;

@end
