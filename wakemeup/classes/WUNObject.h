//
//  WUNObject.h
//  ObjectCrunch
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNBase.h"

static const NSUInteger NumObjectTypes = 6;

static const CGFloat TileWidth = 40.0f;
static const CGFloat TileHeight = 40.0f;

typedef enum : NSUInteger {
    eObjectAlive,
    eObjectDead,
    eObjectGone,
} EObjectStatus;

typedef enum : NSUInteger {
    eObjectNone,
    eObjectSmily,
    eObjectWall,
    eObjectHole
} EObjectType;

@interface WUNObject : WUNBase

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) EObjectType ObjectType;
@property (assign, nonatomic) EObjectStatus status;

@end
