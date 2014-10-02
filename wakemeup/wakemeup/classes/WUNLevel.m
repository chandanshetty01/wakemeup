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
                tile.ObjectType = value.integerValue;
                _tiles[column][tileRow] = tile;
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

- (void)detectPossibleSwaps {

  NSMutableSet *set = [NSMutableSet set];

  for (NSInteger row = 0; row < NumRows; row++) {
    for (NSInteger column = 0; column < NumColumns; column++) {

      WUNObject *Object = _Objects[column][row];
      if (Object != nil) {

        // Is it possible to swap this Object with the one on the right?
        if (column < NumColumns - 1) {
          // Have a Object in this spot? If there is no tile, there is no Object.
          WUNObject *other = _Objects[column + 1][row];
          if (other != nil) {
            // Swap them
            _Objects[column][row] = other;
            _Objects[column + 1][row] = Object;
            
            // Is either Object now part of a chain?
            if ([self hasChainAtColumn:column + 1 row:row] ||
                [self hasChainAtColumn:column row:row]) {

              WUNSwap *swap = [[WUNSwap alloc] init];
              swap.ObjectA = Object;
              swap.ObjectB = other;
              [set addObject:swap];
            }

            // Swap them back
            _Objects[column][row] = Object;
            _Objects[column + 1][row] = other;
          }
        }

        if (row < NumRows - 1) {

          WUNObject *other = _Objects[column][row + 1];
          if (other != nil) {
            _Objects[column][row] = other;
            _Objects[column][row + 1] = Object;

            if ([self hasChainAtColumn:column row:row + 1] ||
                [self hasChainAtColumn:column row:row]) {

              WUNSwap *swap = [[WUNSwap alloc] init];
              swap.ObjectA = Object;
              swap.ObjectB = other;
              [set addObject:swap];
            }

            _Objects[column][row] = Object;
            _Objects[column][row + 1] = other;
          }
        }
      }
    }
  }

  self.possibleSwaps = set;
}

- (NSSet *)createInitialObjects {

  NSMutableSet *set = [NSMutableSet set];

  for (NSInteger row = 0; row < NumRows; row++) {
    for (NSInteger column = 0; column < NumColumns; column++) {

      if (_tiles[column][row] != nil) {
          NSUInteger ObjectType = _tiles[column][row].ObjectType;
          WUNObject *Object = [self createObjectAtColumn:column row:row withType:ObjectType];
          [set addObject:Object];
      }
    }
  }
  return set;
}

- (WUNObject *)createObjectAtColumn:(NSInteger)column row:(NSInteger)row withType:(NSUInteger)ObjectType {
  WUNObject *Object = [[WUNObject alloc] init];
  Object.ObjectType = ObjectType;
  Object.column = column;
  Object.row = row;
  _Objects[column][row] = Object;
  return Object;
}

- (void)performSwap:(WUNSwap *)swap {
  NSInteger columnA = swap.ObjectA.column;
  NSInteger rowA = swap.ObjectA.row;
  NSInteger columnB = swap.ObjectB.column;
  NSInteger rowB = swap.ObjectB.row;

  _Objects[columnA][rowA] = swap.ObjectB;
  swap.ObjectB.column = columnA;
  swap.ObjectB.row = rowA;

  _Objects[columnB][rowB] = swap.ObjectA;
  swap.ObjectA.column = columnB;
  swap.ObjectA.row = rowB;
}

- (BOOL)isPossibleSwap:(WUNSwap *)swap {
  return [self.possibleSwaps containsObject:swap];
}

@end
