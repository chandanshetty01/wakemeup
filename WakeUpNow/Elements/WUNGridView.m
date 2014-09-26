//
//  WUNGridView.m
//  WakeUpNow
//
//  Created by S P, Chandan Shetty (external - Project) on 2/5/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNGridView.h"

@interface WUNGridView ()

@property(nonatomic,assign) CGSize gridSize;
@property(nonatomic,assign) CGSize cellSize;

@end

@implementation WUNGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initGridWithSize:(CGSize)gridSize andEachCellSize:(CGSize)cellSize
{
    self = [super init];
    if(self){
        
        self.backgroundColor = [UIColor clearColor];
        
        _gridSize= gridSize;
        _cellSize = cellSize;
        CGRect frame = CGRectMake(0, 0, gridSize.width*cellSize.width, gridSize.height*cellSize.height);
        self.frame = frame;
        
        _gridPoints = [[NSMutableArray alloc] init];
        
        CGPoint point  = CGPointZero;
        for(int i = 0 ; i < gridSize.width ; i++)
        {
            NSMutableArray *rowArray = [[NSMutableArray alloc] init];
            for(int j = 0 ; j < gridSize.height ; j++)
            {
                point = CGPointMake(point.x,point.y+ cellSize.height);
                rowArray[j] = NSStringFromCGPoint(point);
            }
            _gridPoints[i] = rowArray;
            point = CGPointMake(point.x + cellSize.width,frame.origin.x);
        }

    }
    return self;
}


-(NSMutableArray*)adjacentPointsForPoint:(CGPoint)inPoint andDirection:(UISwipeGestureRecognizerDirection)direction
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    const int offset = 150;
    
    NSMutableArray *adjacentPoints = [[NSMutableArray alloc] init];
    switch (direction) {
        case UISwipeGestureRecognizerDirectionRight:
        {
            for (int i = (inPoint.x/_cellSize.width)+1; i <= _gridSize.width; i++) {
                [adjacentPoints addObject:NSStringFromCGPoint(CGPointMake(i*_cellSize.width, inPoint.y))];
            }
            
            [adjacentPoints addObject:NSStringFromCGPoint(CGPointMake(screenRect.size.height+offset, inPoint.y))];
        }
            break;
        case UISwipeGestureRecognizerDirectionLeft:
        {
            for (int i = (inPoint.x/_cellSize.width)-1; i >= 0; i--) {
                [adjacentPoints addObject:NSStringFromCGPoint(CGPointMake(i*_cellSize.width, inPoint.y))];
            }
            [adjacentPoints addObject:NSStringFromCGPoint(CGPointMake(-offset, inPoint.y))];
        }
            break;
        case UISwipeGestureRecognizerDirectionUp:
        {
            for (int i = (inPoint.y/_cellSize.height)-1; i >= 0; i--) {
                [adjacentPoints addObject:NSStringFromCGPoint(CGPointMake(inPoint.x,i*_cellSize.height))];
            }
            [adjacentPoints addObject:NSStringFromCGPoint(CGPointMake(inPoint.x, -offset))];
        }
            break;
        case UISwipeGestureRecognizerDirectionDown:
        {
            for (int i = (inPoint.y/_cellSize.height)+1; i <= _gridSize.height; i++) {
                [adjacentPoints addObject:NSStringFromCGPoint(CGPointMake(inPoint.x, i*_cellSize.height))];
            }
            [adjacentPoints addObject:NSStringFromCGPoint(CGPointMake(inPoint.x, screenRect.size.width+offset))];
        }
            break;
            
        default:
            break;
    }
    
    return adjacentPoints;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [_gridPoints enumerateObjectsUsingBlock:^(NSMutableArray *obj, NSUInteger idx, BOOL *stop) {
        
        [obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSLog(@"%@",obj);
            CGPoint startPoint = CGPointFromString(obj);
            
            CGContextSetLineCap(context, kCGLineCapSquare);
            CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor); //change color here
            CGFloat lineWidth = 2.0; //change line width here
            CGContextSetLineWidth(context, lineWidth);
            CGContextMoveToPoint(context, startPoint.x + lineWidth/2, startPoint.y + lineWidth/2);
            CGContextAddLineToPoint(context, startPoint.x, startPoint.y);
            CGContextClosePath(context);
            CGContextStrokePath(context);
        }];
        
    }];
 
    CGContextRestoreGState(context);
}

@end
