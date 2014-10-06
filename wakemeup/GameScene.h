//
//  GameScene.h
//  wakemeup
//

//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "WUNLevel.h"

typedef enum : NSUInteger {
    eGameOver,
    eGameWon,
    eGameRunning
} EGAMESTATUS;

@interface GameScene : SKScene

@property (strong, nonatomic) WUNLevel *level;
@property (copy, nonatomic) void (^swipeHandler)(WUNSwap *swap);
@property (copy, nonatomic) void (^gameCompletion)(EGAMESTATUS status);

- (void)addTiles;
- (void)addSpritesForObjects:(NSSet *)Objects;

@end
