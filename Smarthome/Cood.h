//
//  Cood.h
//  Smarthome
//
//  Created by Nguyen Huynh on 3/24/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cood : NSObject

@property (nonatomic, retain) NSString* iconName;
@property (nonatomic, retain) NSString* port;
@property (nonatomic, retain) NSString* value;
@property (nonatomic, assign) CGPoint centerPoint;

-(id)initCoodWithIcon:(NSString*)name centerPoint:(CGPoint)center Port:(NSString*)port Value:(NSString*) value;

@end
