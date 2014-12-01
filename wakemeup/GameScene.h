//
//  GameScene.h
//  wakemeup
//

//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "WUNLevel.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (strong, nonatomic) WUNLevel *level;
@property (copy, nonatomic)void (^gameCompletion)(EGAMESTATUS status);
@property (nonatomic,assign)BOOL isDevelopmentMode;

- (void)addTiles;
- (void)addSpritesForObjects:(NSMutableArray *)Objects;
- (void)addSpriteForObject:(WUNObject*)object;
- (void)addSpriteForObstacle:(WUNObstacle*)object;
- (NSMutableDictionary*)getTilesDictionary;

@end
