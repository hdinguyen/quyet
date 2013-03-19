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

-(id)initDataAccess;
-(BOOL)createEditableCopyOfDatabaseIfNeeded;
-(void)test;

@end
