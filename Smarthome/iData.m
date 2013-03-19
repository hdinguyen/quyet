//
//  iData.m
//  Smarthome
//
//  Created by Nguyen Huynh on 3/16/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import "iData.h"
#import <sqlite3.h>

@implementation iData
-(id)initDataAccess {
    self = [super init];
    if (![self createEditableCopyOfDatabaseIfNeeded])
		return nil;
	sqlite = [[NSSQLite alloc] init];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"SmartHome.db"];
	if (![sqlite open:writableDBPath]) {
        NSLog(@"Loi database");
		return nil;
    }
	return self;
}

- (BOOL)createEditableCopyOfDatabaseIfNeeded  {
    /* First, test for existence.*/
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"SmartHome.db"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
		return TRUE;
	
    /* The writable database does not exist, so copy the default to the appropriate location.*/
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SmartHome.db"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		return FALSE;
    }
	else
		return TRUE;
}

-(void)test {
    
    sql = [NSString stringWithFormat:@"select * from ITEM"];
	NSArray* results = [sqlite executeQuery:sql];
    for (NSDictionary *dic in results) {
        NSLog(@"%@", [dic valueForKey:@"ITEM_NAME"]);
        
    }
}

@end
