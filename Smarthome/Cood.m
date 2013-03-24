//
//  Cood.m
//  Smarthome
//
//  Created by Nguyen Huynh on 3/24/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import "Cood.h"

@implementation Cood

-(id)initCoodWithIcon:(NSString*)name centerPoint:(CGPoint)center Port:(NSString*)port Value:(NSString*) value
{
    self = [super init];
    _iconName = name;
    _centerPoint = center;
    _port = port;
    _value = value;
    return self;
}

@end
