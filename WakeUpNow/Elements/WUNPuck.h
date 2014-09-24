//
//  WUNPuck.h
//  WakeUpNow
//
//  Created by S P, Chandan Shetty (external - Project) on 2/5/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import <UIKit/UIKit.h>

@class WUNPuck;

@protocol WUNPuckDelegate <NSObject>
-(void)handlePuckSwipe:(WUNPuck*)puck andDirection:(UISwipeGestureRecognizerDirection)direction;
@end

typedef enum WUNPuckStatus {
    ePuckDied,
    ePuckAlive,
    ePuckGone
    }WUNPuckStatus;

@interface WUNPuck : UIView
{
    
}
@property(nonatomic,weak) id<WUNPuckDelegate> delegate;
@property(nonatomic,assign) WUNPuckStatus status;

-(void)reset;

@end


