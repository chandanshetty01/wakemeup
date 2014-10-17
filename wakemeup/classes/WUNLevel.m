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

@end

@implementation WUNLevel {
  NSMutableArray *_Objects[NumColumns][NumRows];
  WUNTile *_tiles[NumColumns][NumRows];
  NSInteger ObjectsList[NumColumns][NumRows];
}

- (instancetype)initWithModel:(WUNLevelModel*)levelModel
{
    self = [super init];
    if (self != nil) {
        
        self.levelModel = levelModel;
        
        // Loop through the rows
        [self.levelModel.tiles[@"tiles"] enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger row, BOOL *stop) {
            // Loop through the columns in the current row
            [array enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger column, BOOL *stop) {
                // Note: In Sprite Kit (0,0) is at the bottom of the screen,
                // so we need to read this file upside down.
                NSInteger tileRow = NumRows - row - 1;
                WUNTile *tile = [[WUNTile alloc] init];
                _tiles[column][tileRow] = tile;
                ObjectsList[column][tileRow] = value.integerValue;
            }];
        }];
    }
    return self;
}

- (NSMutableArray *)objectAtColumn:(NSInteger)column row:(NSInteger)row;
{
  NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
  NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);

  return _Objects[column][row];
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
  NSLog(@"Started creating objects");
  for (NSInteger row = 0; row < NumRows; row++) {
    for (NSInteger column = 0; column < NumColumns; column++) {
      if (_tiles[column][row] != nil) {
          NSUInteger ObjectType = ObjectsList[column][row];
          if(ObjectType >= 1){
              NSMutableArray *Object = [self createObjectAtColumn:column row:row withType:ObjectType];
              [set addObject:Object];
          }
      }
    }
  }
  return set;
}

- (NSMutableArray *)createObjectAtColumn:(NSInteger)column row:(NSInteger)row withType:(NSUInteger)ObjectType
{
    WUNObject *Object = nil;
    switch (ObjectType) {
        case eObjectSmily:{
            Object = [[WUNSmily alloc] init];
        }
            break;
        case eObjectObstacle:{
            Object = [[WUNObstacle alloc] init];
        }
            break;
        case eObjectHole:{
            Object = [[WUNHole alloc] init];
        }
            break;
            
        default:
            break;
    }
    
    Object.ObjectType = ObjectType;
    Object.column = column;
    Object.row = row;
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:Object, nil];
    _Objects[column][row] = array;
    return array;
}

-(void)removeObjectFromList:(WUNObject*)object
{
    NSMutableArray *objects = _Objects[object.column][object.row];
    if([objects containsObject:object]){
        [objects removeObject:object];
    }
}

- (void)performSwap:(WUNSwap *)swap
{
    WUNObject *object = swap.ObjectA;
    if(object.status != eObjectGone){
        NSInteger columnB = swap.point.x;
        NSInteger rowB = swap.point.y;
        
        NSMutableArray *objects = _Objects[columnB][rowB];
        if(![objects containsObject:swap.ObjectA] && objects.count > 0){
            [objects addObject:swap.ObjectA];
        }
        else{
            _Objects[columnB][rowB] = [[NSMutableArray alloc] initWithObjects:swap.ObjectA, nil];
        }
        
        [self removeObjectFromList:swap.ObjectA];
        
        swap.ObjectA.column = columnB;
        swap.ObjectA.row = rowB;
    }
    else{
        [self removeObjectFromList:swap.ObjectA];
    }
}

- (BOOL)isPossibleSwap:(WUNSwap *)swap
{
  return [self.possibleSwaps containsObject:swap];
}

- (void)dealloc
{
    NSLog(@"");
}

@end
