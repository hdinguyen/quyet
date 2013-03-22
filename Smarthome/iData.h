//
//  iData.h
//  Smarthome
//
//  Created by Nguyen Huynh on 3/16/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSSQLite.h"

@interface iData : NSObject
{
    NSString *writableDBPath;
	NSString *sql;
    NSSQLite *sqlite;
}
+(id)shareInstance;
-(id)initDataAccess;
-(BOOL)createEditableCopyOfDatabaseIfNeeded;
-(void)test;
-(BOOL)insertToFloorWithName:(NSString*)floorName;
-(void)removeFloorWithName:(NSString*)floorName;
-(NSArray*)getFloorList;
-(NSArray*)getItemList;
-(void) addNewIcon:(NSString*)iconName toFloor:(NSString*)floorName atPosition:(CGPoint)centerPoint;
@end
