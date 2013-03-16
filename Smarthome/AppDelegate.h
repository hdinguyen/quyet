//
//  AppDelegate.h
//  Smarthome
//
//  Created by Nguyen Huynh on 3/11/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCoreGUIController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    iCoreGUIController* core;
}

@property (strong, nonatomic) UIWindow *window;

@end
