//
//  iCoreGUIController.m
//  Smarthome
//
//  Created by Nguyen Huynh on 3/11/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import "iCoreGUIController.h"
#import "iData.h"

@implementation iCoreGUIController

+(id)shareInstance
{
    static iCoreGUIController* iCore = nil;
    if (nil != iCore) {
        return iCore;
    }

    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        iCore = [[iCoreGUIController alloc] init];
    });
    return iCore;
}

-(void)setWindowApplication:(UIWindow *)window
{
    _mainWindow = window;
}

-(void)start
{
    iData* dt = [[iData alloc]initDataAccess];
    [dt test];
    _mainView = [[MainViewController alloc]init];
    [_mainWindow addSubview:_mainView.view];
}

@end
