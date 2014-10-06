//
//  WUNObject.h
//  ObjectCrunch
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static const NSUInteger NumObjectTypes = 6;

typedef enum : NSUInteger {
    eObjectAlive,
    eObjectDead,
    eObjectGone,
} EObjectStatus;

typedef enum : NSUInteger {
    eObjectNone,
    eObjectSmily,
    eObjectObstacle,
    eObjectHole
} EObjectType;

@interface WUNObject : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) EObjectType ObjectType;
@property (strong, nonatomic) SKSpriteNode *sprite;
@property (assign, nonatomic) EObjectStatus status;

- (NSString *)spriteName;
- (NSString *)highlightedSpriteName;

@end
