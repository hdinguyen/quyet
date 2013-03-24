//
//  iCon.m
//  Smarthome
//
//  Created by Nguyen Huynh on 3/23/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import "iCon.h"

@implementation iCon

-(id) initIconWith:(NSString*)name image:(UIImageView*)img ID:(NSInteger)iConID center:(CGPoint) centerPoint
{
    self = [super init];
    _name = name;
    _img = img;

    _centerPoint = centerPoint;
    return self;
}

@end
