//
//  RWTLevel.m
//  CookieCrunch
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNLevel.h"

@interface WUNLevel ()

@property (strong, nonatomic) NSSet *possibleSwaps;

@end

@implementation WUNLevel {
  WUNObject *_cookies[NumColumns][NumRows];
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
                tile.cookieType = value.integerValue;
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

- (WUNObject *)cookieAtColumn:(NSInteger)column row:(NSInteger)row {
  NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
  NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);

  return _cookies[column][row];
}

- (WUNTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row {
  NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
  NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);

  return _tiles[column][row];
}

- (NSSet *)shuffle
{
  NSSet *set;
  set = [self createInitialCookies];
  return set;
}

- (BOOL)hasChainAtColumn:(NSInteger)column row:(NSInteger)row {
  NSUInteger cookieType = _cookies[column][row].cookieType;

  NSUInteger horzLength = 1;
  for (NSInteger i = column - 1; i >= 0 && _cookies[i][row].cookieType == cookieType; i--, horzLength++) ;
  for (NSInteger i = column + 1; i < NumColumns && _cookies[i][row].cookieType == cookieType; i++, horzLength++) ;
  if (horzLength >= 3) return YES;

  NSUInteger vertLength = 1;
  for (NSInteger i = row - 1; i >= 0 && _cookies[column][i].cookieType == cookieType; i--, vertLength++) ;
  for (NSInteger i = row + 1; i < NumRows && _cookies[column][i].cookieType == cookieType; i++, vertLength++) ;
  return (vertLength >= 3);
}

- (void)detectPossibleSwaps {

  NSMutableSet *set = [NSMutableSet set];

  for (NSInteger row = 0; row < NumRows; row++) {
    for (NSInteger column = 0; column < NumColumns; column++) {

      WUNObject *cookie = _cookies[column][row];
      if (cookie != nil) {

        // Is it possible to swap this cookie with the one on the right?
        if (column < NumColumns - 1) {
          // Have a cookie in this spot? If there is no tile, there is no cookie.
          WUNObject *other = _cookies[column + 1][row];
          if (other != nil) {
            // Swap them
            _cookies[column][row] = other;
            _cookies[column + 1][row] = cookie;
            
            // Is either cookie now part of a chain?
            if ([self hasChainAtColumn:column + 1 row:row] ||
                [self hasChainAtColumn:column row:row]) {

              WUNSwap *swap = [[WUNSwap alloc] init];
              swap.cookieA = cookie;
              swap.cookieB = other;
              [set addObject:swap];
            }

            // Swap them back
            _cookies[column][row] = cookie;
            _cookies[column + 1][row] = other;
          }
        }

        if (row < NumRows - 1) {

          WUNObject *other = _cookies[column][row + 1];
          if (other != nil) {
            _cookies[column][row] = other;
            _cookies[column][row + 1] = cookie;

            if ([self hasChainAtColumn:column row:row + 1] ||
                [self hasChainAtColumn:column row:row]) {

              WUNSwap *swap = [[WUNSwap alloc] init];
              swap.cookieA = cookie;
              swap.cookieB = other;
              [set addObject:swap];
            }

            _cookies[column][row] = cookie;
            _cookies[column][row + 1] = other;
          }
        }
      }
    }
  }

  self.possibleSwaps = set;
}

- (NSSet *)createInitialCookies {

  NSMutableSet *set = [NSMutableSet set];

  for (NSInteger row = 0; row < NumRows; row++) {
    for (NSInteger column = 0; column < NumColumns; column++) {

      if (_tiles[column][row] != nil) {
          NSUInteger cookieType = _tiles[column][row].cookieType;
          WUNObject *cookie = [self createCookieAtColumn:column row:row withType:cookieType];
          [set addObject:cookie];
      }
    }
  }
  return set;
}

- (WUNObject *)createCookieAtColumn:(NSInteger)column row:(NSInteger)row withType:(NSUInteger)cookieType {
  WUNObject *cookie = [[WUNObject alloc] init];
  cookie.cookieType = cookieType;
  cookie.column = column;
  cookie.row = row;
  _cookies[column][row] = cookie;
  return cookie;
}

- (void)performSwap:(WUNSwap *)swap {
  NSInteger columnA = swap.cookieA.column;
  NSInteger rowA = swap.cookieA.row;
  NSInteger columnB = swap.cookieB.column;
  NSInteger rowB = swap.cookieB.row;

  _cookies[columnA][rowA] = swap.cookieB;
  swap.cookieB.column = columnA;
  swap.cookieB.row = rowA;

  _cookies[columnB][rowB] = swap.cookieA;
  swap.cookieA.column = columnB;
  swap.cookieA.row = rowB;
}

- (BOOL)isPossibleSwap:(WUNSwap *)swap {
  return [self.possibleSwaps containsObject:swap];
}

@end
