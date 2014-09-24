//
//  WUNPuck.m
//  WakeUpNow
//
//  Created by S P, Chandan Shetty (external - Project) on 2/5/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNPuck.h"
#import "Colours.h"

@interface WUNPuck ()

@end

@implementation WUNPuck

-(void)initSwipeGestures
{
    self.backgroundColor = [UIColor clearColor];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self addGestureRecognizer:swipeRecognizer];
    
    _status = ePuckAlive;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSwipeGestures];
    }
    return self;
}

-(void)reset
{
    _status = ePuckAlive;
}

-(void)drawRect:(CGRect)rect
{
    CGRect borderRect = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    borderRect = CGRectInset(borderRect, 1, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();

    /*
    CGContextSetRGBFillColor(context, 0, 0, 1.0, 1.0);
    CGContextFillEllipseInRect (context, borderRect);
    CGContextFillPath(context);
    */
    
    CGContextSetRGBFillColor(context, 255, 255, 240, 255);
    CGContextFillRect(context, borderRect);
}

-(void)handleSwipeGesture:(UISwipeGestureRecognizer*)gesture
{
    if(_delegate && [_delegate respondsToSelector:@selector(handlePuckSwipe:andDirection:)] && _status == ePuckAlive)
    {
        [_delegate handlePuckSwipe:self andDirection:gesture.direction];
    }
}

- (void)dealloc
{
}

@end
