//
//  iCon.h
//  Smarthome
//
//  Created by Nguyen Huynh on 3/23/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iCon : NSObject

@property (nonatomic, retain) UIImageView* img;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) CGPoint centerPoint;

-(id) initIconWith:(NSString*)name image:(UIImageView*)img ID:(NSInteger)iConID center:(CGPoint) centerPoint;
@end
