//
//  GameScene.h
//  wakemeup
//

//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "RWTLevel.h"

@interface GameScene : SKScene

@property (strong, nonatomic) RWTLevel *level;
@property (copy, nonatomic) void (^swipeHandler)(RWTSwap *swap);

- (void)addTiles;
- (void)addSpritesForCookies:(NSSet *)cookies;

@end
