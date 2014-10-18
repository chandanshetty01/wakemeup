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
#import "WUNLevelModel.h"

static const NSInteger NumColumns = 12;
static const NSInteger NumRows = 6;

@interface WUNLevel : NSObject
{
    
}
@property(nonatomic,strong) WUNLevelModel *levelModel;

- (instancetype)initWithModel:(WUNLevelModel*)levelModel;
- (NSSet *)shuffle;
- (NSMutableArray *)objectAtColumn:(NSInteger)column row:(NSInteger)row;
- (WUNTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;
- (NSMutableArray*)createObject:(NSDictionary*)data;
- (void)performSwap:(WUNSwap *)swap;
- (BOOL)isPossibleSwap:(WUNSwap *)swap;

@end
