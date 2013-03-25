//
//  iData.m
//  Smarthome
//
//  Created by Nguyen Huynh on 3/16/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import "iData.h"
#import <sqlite3.h>
#import "iCon.h"
#import "Cood.h"
#import "floor.h"

@implementation iData


+(id)shareInstance
{
    static iData* shareObj = nil;
    if (nil != shareObj) {
        return shareObj;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        shareObj = [[iData alloc] initDataAccess];
    });
    return shareObj;
}

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
    NSInteger lastId = [[lastDicItem valueForKey:@"ID"] intValue];

    
    sql = [NSString stringWithFormat:@"insert into FLOOR values (%d , '%@')",lastId+1, floorName];
    [sqlite executeQuery:sql];
    
    NSLog(@"Add floor success %d", lastId);
    return YES;
}

-(void)removeFloorWithName:(NSString *)floorName
{
    sql = [NSString stringWithFormat:@"delete from FLOOR where FLOOR_NAME = '%@'",floorName];
    [sqlite executeQuery:sql];
}

-(NSInteger)getFloorID:(NSString*)name
{
    sql = [NSString stringWithFormat:@"select * from FLOOR where FLOOR_NAME = '%@'",name];
    NSArray* sqlResult = [sqlite executeQuery:sql];
    NSInteger lastId = -1;
    if (sqlResult > 0)
    {
        NSDictionary *lastDicItem = [sqlResult objectAtIndex:0];
        lastId = [[lastDicItem valueForKey:@"ID"] intValue];
    }
    return lastId;
}

-(NSInteger)getIconID:(NSString*)name
{
    sql = [NSString stringWithFormat:@"select * from ITEM where ITEM_NAME = '%@'",name];
    NSArray* sqlResult = [sqlite executeQuery:sql];
    NSInteger lastId = -1;
    if (sqlResult > 0)
    {
        NSDictionary *lastDicItem = [sqlResult objectAtIndex:0];
        lastId = [[lastDicItem valueForKey:@"ID"] intValue];
    }
    return lastId;
}

-(void)addNewIcon:(NSString *)iconName toFloor:(NSString *)floorName atPosition:(CGPoint)centerPoint
{
    sql = @"select * from COOD";
    NSArray* sqlResult = [sqlite executeQuery:sql];
    NSInteger lastId = 0;
    if (sqlResult > 0)
    {
        NSDictionary *lastDicItem = [sqlResult objectAtIndex:[sqlResult count] - 1];
        lastId = [[lastDicItem valueForKey:@"ID"] intValue];
    }
    /*
    NSInteger floorId = [self getFloorID:floorName];
    NSInteger iconId = [self getIconID:iconName];
    
    if (floorId < 0 || iconId < 0)
    {
        NSLog(@"Wrong data");
        return;
    }
     */
    sql = [NSString stringWithFormat:@"insert into COOD(ID, FLOOR_NAME, ITEM_NAME, X_CENTER, Y_CENTER, PORT, VALUE) values (%d,'%@','%@',%f,%f, '', 0.0)",lastId, floorName, iconName, centerPoint.x, centerPoint.y];
    [sqlite executeQuery:sql];
    NSLog(@"Add icon to floor success");
}

-(NSArray*)getIconListOfFloor:(NSString*)floorName
{
    sql = [NSString stringWithFormat:@"Select * from COOD where ID_FLOOR = '%@'", floorName];
    NSArray* sqlResult = [sqlite executeQuery:sql];
    
    NSMutableArray* returnArr = [[NSMutableArray alloc]init];
    
    NSString* iconName;
    NSString* port;
    NSString* value;
    float xCenter = 0.0;
    float yCenter = 0.0;
    for (NSDictionary *dic in sqlResult)
    {
        iconName = [dic objectForKey:@"ITEM_NAME"] ;
        xCenter = [[dic objectForKey:@"X_CENTER"] floatValue];
        yCenter = [[dic objectForKey:@"Y_CENTER"] floatValue];
        port = [dic objectForKey:@"PORT"];
        value = [dic objectForKey:@"VALUE"];
        [returnArr addObject:[[Cood alloc]initCoodWithIcon:iconName centerPoint:CGPointMake(xCenter, yCenter) Port:port Value:value]];
    }
    return returnArr;
}
@end
