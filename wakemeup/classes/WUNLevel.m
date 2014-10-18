//
//  RWTLevel.m
//  ObjectCrunch
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNLevel.h"
#import "Utility.h"

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

- (WUNTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row
{
  NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
  NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);

  return _tiles[column][row];
}

- (NSSet *)shuffle
{
  NSSet *set;
  set = [self createInitialObjects];
  return set;
}

- (NSSet *)createInitialObjects
{
    NSMutableSet *set = [NSMutableSet set];
    
    [self.levelModel.tiles enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        NSMutableArray *Object = [self createObject:obj];
        [set addObject:Object];
    }];
    
    return set;
}

- (NSMutableArray*)createObject:(NSDictionary*)data
{
    NSInteger objectType = [[data objectForKey:@"objectType"] intValue];
    
    WUNObject *Object = nil;
    switch (objectType) {
        case eObjectSmily:{
            Object = [[WUNSmily alloc] initWithDictionary:data];
        }
            break;
        case eObjectObstacle:{
            Object = [[WUNObstacle alloc] initWithDictionary:data];
        }
            break;
        case eObjectHole:{
            Object = [[WUNHole alloc] initWithDictionary:data];
        }
            break;
            
        default:
            break;
    }
    
    [self.objects addObject:Object];
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:Object, nil];
    return array;
}

-(void)removeObjectFromList:(WUNObject*)object
{
    if([self.objects containsObject:object]){
        [self.objects removeObject:object];
    }
}

- (void)performSwap:(WUNSwap *)swap
{
    WUNObject *object = swap.ObjectA;
    if(object.status != eObjectGone){
        object.row = swap.point.x;
        object.column = swap.point.y;
    }
    else{
        [self removeObjectFromList:swap.ObjectA];
    }
}

- (void)dealloc
{
    NSLog(@"");
}

@end
