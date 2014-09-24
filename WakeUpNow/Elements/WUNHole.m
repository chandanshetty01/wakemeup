//
//  WUNHole.m
//  WakeUpNow
//
//  Created by S P, Chandan Shetty (external - Project) on 2/6/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNHole.h"
#import "Colours.h"

@implementation WUNHole

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor ivoryColor];
        self.backgroundColor = [UIColor antiqueWhiteColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    //[[self class] colorWithR:102 G:169 B:251 A:1.0]
    
    //blueberryColor - [[self class] colorWithR:89 G:113 B:173 A:1.0]
    CGRect borderRect = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    CGRect inBorderRect = CGRectInset(borderRect, 1, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context,inBorderRect);
    CGContextSetRGBFillColor(context, 89/255.0, 113/255.0, 173/255.0, 255.0f/255.0);
    CGContextFillRect(context, inBorderRect);
}


@end
