//
//  iCoreGUIController.h
//  Smarthome
//
//  Created by Nguyen Huynh on 3/11/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"

@interface iCoreGUIController : NSObject
{
    UIWindow* _mainWindow;
    MainViewController* _mainView;
}

+(id)shareInstance;
-(void)start;
-(void)setWindowApplication:(UIWindow*) window;

@end
