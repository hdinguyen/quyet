//
//  floor.m
//  Smarthome
//
//  Created by Nguyen Huynh on 3/24/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import "floor.h"

@implementation Floor

-(id)initFloorWithFrame:(CGRect)frame background:(NSString*)img Name:(NSString*)name Gesture:(NSArray*) gestureArr
{
    self = [super init];
    _view = [[UIView alloc]initWithFrame:frame];
    if (img) {
        _view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:img]];
    }
    else
    {
        [_view setBackgroundColor:[UIColor whiteColor]];
    }
    _name = name;
    for (UIGestureRecognizer* gesture in gestureArr)
    {
        [_view addGestureRecognizer:gesture];
    }
    return self;
}
@end
