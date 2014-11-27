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
#import "WUNWall.h"
#import "WUNHole.h"
#import "WUNLevelModel.h"

static const NSInteger NumColumns = 12;
static const NSInteger NumRows = 6;

typedef enum : NSUInteger {
    eGameOver,
    eGameWon,
    eGameRunning
} EGAMESTATUS;

@interface WUNLevel : NSObject
{
    
}
@property(nonatomic,strong) WUNLevelModel *levelModel;

- (instancetype)initWithModel:(WUNLevelModel*)levelModel;
- (NSMutableArray *)shuffle;
- (NSMutableArray *)objectAtColumn:(NSInteger)column row:(NSInteger)row;
- (WUNTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;
- (WUNObject*)createObject:(NSDictionary*)data;
- (EGAMESTATUS)isGameOver;
- (void)bringToFront:(WUNObject*)object;
@end
