//
//  WUNGridView.h
//  WakeUpNow
//
//  Created by S P, Chandan Shetty (external - Project) on 2/5/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUNGridView : UIView
{
    
}
@property(nonatomic,strong) NSMutableArray *gridPoints;

//designated initializer
-(id) initGridWithSize:(CGSize)gridSize andEachCellSize:(CGSize)cellSize;
-(NSMutableArray*)adjacentPointsForPoint:(CGPoint)inPoint andDirection:(UISwipeGestureRecognizerDirection)direction;

@end
