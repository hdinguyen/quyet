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
        NSLog(@"Database connect error");
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

-(void)test
{
    [self insertToFloorWithName:@"Floor2"];
    NSArray* tmp = [self getFloorList];
    for (NSString* i in tmp)
        NSLog(@"%@",i);
    [self removeFloorWithName:@"Floor2"];
    tmp = [self getFloorList];
    for (NSString* i in tmp)
        NSLog(@"%@",i);
}

-(NSArray*)getFloorList
{
    sql = @"select * from FLOOR";
    NSArray* sqlResult = [sqlite executeQuery:sql];
    NSMutableArray* returnArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in sqlResult)
    {
        [returnArr addObject:[dic valueForKey:@"FLOOR_NAME"]];
    }
    return returnArr;
}

-(NSArray*)getItemList
{
    sql = @"select * from ITEM";
    NSArray* sqlResult = [sqlite executeQuery:sql];
    NSMutableArray* returnArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in sqlResult)
    {
        [returnArr addObject:[dic valueForKey:@"ITEM_NAME"]];
    }
    return returnArr;
}

-(BOOL)insertToFloorWithName:(NSString *)floorName
{
    sql = @"select * from FLOOR";
    NSArray* sqlResult = [sqlite executeQuery:sql];
    if ([sqlResult containsObject:floorName])
    {
        NSLog(@"Name has exist");
        return NO;
    }
    NSDictionary *lastDicItem = [sqlResult objectAtIndex:[sqlResult count] - 1];
    NSInteger lastId = (int)[lastDicItem valueForKey:@"FLOOR_ID"];
    
    sql = [NSString stringWithFormat:@"insert into FLOOR values (%d , '%@')",lastId+1, floorName];
    [sqlite executeQuery:sql];
    return YES;
}

-(void)removeFloorWithName:(NSString *)floorName
{
    sql = [NSString stringWithFormat:@"delete from FLOOR where FLOOR_NAME = '%@'",floorName];
    [sqlite executeQuery:sql];
}

-(void)addNewIcon:(NSString *)iconName toFloor:(NSString *)floorName atPosition:(CGPoint)centerPoint
{
    sql = [NSString stringWithFormat:@"insert into ",floorName];
}
@end
