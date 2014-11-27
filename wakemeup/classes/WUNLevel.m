//
//  RWTLevel.m
//  ObjectCrunch
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNLevel.h"
#import "Utility.h"
#import "WUNObject.h"

@interface WUNLevel ()

@property (strong, nonatomic) NSSet *possibleSwaps;
@property (strong, nonatomic) NSDictionary *levelData;
@property (strong,nonatomic) NSMutableArray *objects;

@end

@implementation WUNLevel {
  WUNTile *_tiles[NumColumns][NumRows];
}

- (instancetype)initWithModel:(WUNLevelModel*)levelModel
{
    self = [super init];
    if (self != nil) {
        
        self.objects = [NSMutableArray array];
        self.levelModel = levelModel;
        
        for(int column = 0; column < NumColumns ; column++){
            for (int row = 0; row < NumRows; row++) {
                    NSInteger tileRow = NumRows - row - 1;
                    WUNTile *tile = [[WUNTile alloc] init];
                    _tiles[column][tileRow] = tile;
            }
        }
    }
    return self;
}

- (NSMutableArray *)objectAtColumn:(NSInteger)column row:(NSInteger)row
{
  NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
  NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);

  NSMutableArray *array = [NSMutableArray array];
    [self.objects enumerateObjectsUsingBlock:^(WUNObject *obj, NSUInteger idx, BOOL *stop) {
        if(obj.row == row && obj.column == column){
            [array addObject:obj];
        }
    }];
    
  return array;
}

- (void)bringToFront:(WUNObject*)object
{
    if([self.objects containsObject:object]){
        [self.objects removeObject:object];
        [self.objects addObject:object];
    }
}

- (WUNTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row
{
  NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
  NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);

  return _tiles[column][row];
}

- (NSMutableArray *)shuffle
{
  NSMutableArray *set = nil;
  set = [self createInitialObjects];
  return set;
}

- (NSMutableArray *)createInitialObjects
{
    [self.levelModel.tiles enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
       [self createObject:obj];
    }];
    
    NSMutableArray *set = [NSMutableArray arrayWithArray:self.objects];
    return set;
}

- (WUNObject*)createObject:(NSDictionary*)data
{
    NSInteger objectType = [[data objectForKey:@"objectType"] intValue];
    
    WUNObject *object = nil;
    switch (objectType) {
        case eObjectSmily:{
            object = [[WUNSmily alloc] initWithDictionary:data];
        }
            break;
        case eObjectObstacle:{
            object = [[WUNWall alloc] initWithDictionary:data];
        }
            break;
        case eObjectHole:{
            object = [[WUNHole alloc] initWithDictionary:data];
        }
            break;
            
        default:
            break;
    }
    
    if(object){
        [self.objects addObject:object];
    }
    return object;
}

-(void)removeObjectFromList:(WUNObject*)object
{
    if([self.objects containsObject:object]){
        [self.objects removeObject:object];
    }
}

-(EGAMESTATUS)isGameOver
{
    __block EGAMESTATUS status = eGameWon;
    
    [self.objects enumerateObjectsUsingBlock:^(WUNObject *obj, NSUInteger idx, BOOL *stop) {
        if(obj.status == eObjectGone){
            status = eGameOver;
            *stop = YES;
        }
        else if(obj.status == eObjectAlive && obj.ObjectType == eObjectSmily){
            status = eGameRunning;
        }
        
        if(status == eGameOver){
            if(self.levelModel.levelID == 1){
                status = eGameWon;
            }
        }
    }];
    return status;
}

- (void)dealloc
{
    NSLog(@"");
}

@end
