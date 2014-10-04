//
//  RWTLevel.m
//  ObjectCrunch
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNLevel.h"

@interface WUNLevel ()

@property (strong, nonatomic) NSSet *possibleSwaps;

@end

@implementation WUNLevel {
  WUNObject *_Objects[NumColumns][NumRows];
  WUNTile *_tiles[NumColumns][NumRows];
  NSInteger ObjectsList[NumColumns][NumRows];
}

- (instancetype)initWithFile:(NSString *)filename {
    self = [super init];
    if (self != nil) {
        NSDictionary *dictionary = [self loadJSON:filename];
        
        // Loop through the rows
        [dictionary[@"tiles"] enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger row, BOOL *stop) {
            
            // Loop through the columns in the current row
            [array enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger column, BOOL *stop) {
                
                // Note: In Sprite Kit (0,0) is at the bottom of the screen,
                // so we need to read this file upside down.
                NSInteger tileRow = NumRows - row - 1;
                WUNTile *tile = [[WUNTile alloc] init];
                _tiles[column][tileRow] = tile;
                
                ObjectsList[column][tileRow] = value.integerValue;
                NSLog(@"%d:%d->%d",column,row, value.integerValue);
            }];
        }];
    }
    return self;
}

- (NSDictionary *)loadJSON:(NSString *)filename {

  NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
  if (path == nil) {
    NSLog(@"Could not find level file: %@", filename);
    return nil;
  }

  NSError *error;
  NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
  if (data == nil) {
    NSLog(@"Could not load level file: %@, error: %@", filename, error);
    return nil;
  }

  NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
    NSLog(@"Level file '%@' is not valid JSON: %@", filename, error);
    return nil;
  }

  return dictionary;
}

- (WUNObject *)objectAtColumn:(NSInteger)column row:(NSInteger)row {
  NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
  NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);

  return _Objects[column][row];
}

- (WUNTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row {
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

- (BOOL)hasChainAtColumn:(NSInteger)column row:(NSInteger)row {
  NSUInteger ObjectType = _Objects[column][row].ObjectType;

  NSUInteger horzLength = 1;
  for (NSInteger i = column - 1; i >= 0 && _Objects[i][row].ObjectType == ObjectType; i--, horzLength++) ;
  for (NSInteger i = column + 1; i < NumColumns && _Objects[i][row].ObjectType == ObjectType; i++, horzLength++) ;
  if (horzLength >= 3) return YES;

  NSUInteger vertLength = 1;
  for (NSInteger i = row - 1; i >= 0 && _Objects[column][i].ObjectType == ObjectType; i--, vertLength++) ;
  for (NSInteger i = row + 1; i < NumRows && _Objects[column][i].ObjectType == ObjectType; i++, vertLength++) ;
  return (vertLength >= 3);
}

- (NSSet *)createInitialObjects
{
  NSMutableSet *set = [NSMutableSet set];
  NSLog(@"Started creating objects");
  for (NSInteger row = 0; row < NumRows; row++) {
    for (NSInteger column = 0; column < NumColumns; column++) {
      if (_tiles[column][row] != nil) {
          NSUInteger ObjectType = ObjectsList[column][row];
          if(ObjectType == 1){
              WUNObject *Object = [self createObjectAtColumn:column row:row withType:ObjectType];
              [set addObject:Object];
          }
      }
    }
  }
  return set;
}

- (WUNObject *)createObjectAtColumn:(NSInteger)column row:(NSInteger)row withType:(NSUInteger)ObjectType
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
  _Objects[column][row] = Object;
  return Object;
}

- (void)performSwap:(WUNSwap *)swap
{    
  NSInteger columnB = swap.point.x;
  NSInteger rowB = swap.point.y;
    
  _Objects[columnB][rowB] = swap.ObjectA;
  swap.ObjectA.column = columnB;
  swap.ObjectA.row = rowB;
}

- (BOOL)isPossibleSwap:(WUNSwap *)swap {
  return [self.possibleSwaps containsObject:swap];
}

@end
