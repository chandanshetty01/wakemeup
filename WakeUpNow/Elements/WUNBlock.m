//
//  WUNBlock.m
//  WakeUpNow
//
//  Created by S P, Chandan Shetty (external - Project) on 2/6/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNBlock.h"
#import "Colours.h"

@implementation WUNBlock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor chocolateColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{

}

@end
