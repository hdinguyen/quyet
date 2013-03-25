//
//  floor.h
//  Smarthome
//
//  Created by Nguyen Huynh on 3/24/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Floor : NSObject

@property (nonatomic,retain) NSString* name;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, retain) NSString* background;
@property (nonatomic, retain) UIView* view;

-(id)initFloorWithFrame:(CGRect)frame ImageBackground:(NSString*)img Name:(NSString*)name Gesture:(NSArray*) gestureArr;

@end
