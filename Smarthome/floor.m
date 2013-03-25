//
//  floor.m
//  Smarthome
//
//  Created by Nguyen Huynh on 3/24/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import "floor.h"

@implementation Floor

-(id)initFloorWithFrame:(CGRect)frame ImageBackground:(NSString*)img Name:(NSString*)name Gesture:(NSArray*) gestureArr
{
    self = [super init];
    _view = [[UIView alloc]initWithFrame:frame];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    label.text = name;
    //[label setBackgroundColor:[UIColor blackColor]];
    [_view addSubview:label];
    if (img) {
        _view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:img]];
    }
    else
    {
        [_view setBackgroundColor:[UIColor greenColor]];
    }
    _name = name;
    for (UIGestureRecognizer* gesture in gestureArr)
    {
        [_view addGestureRecognizer:gesture];
    }
    return self;
}
@end
