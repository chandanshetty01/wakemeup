//
//  RWTLevel.h
//  ObjectCrunch
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNObject.h"
#import "WUNTile.h"
#import "WUNSwap.h"
#import "WUNSmily.h"
#import "WUNObstacle.h"
#import "WUNHole.h"

static const NSInteger NumColumns = 8;
static const NSInteger NumRows = 4;

@interface WUNLevel : NSObject

- (instancetype)initWithFile:(NSString *)filename;

- (NSSet *)shuffle;

- (NSMutableArray *)objectAtColumn:(NSInteger)column row:(NSInteger)row;
- (WUNTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;

- (void)performSwap:(WUNSwap *)swap;
- (BOOL)isPossibleSwap:(WUNSwap *)swap;

@end
