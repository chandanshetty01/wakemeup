//
//  WUNObject.m
//  ObjectCrunch
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNObject.h"

@implementation WUNObject

- (NSString *)spriteName {
  static NSString * const spriteNames[] = {
    @"",
    @"Croissant",
    @"Cupcake",
    @"Danish",
    @"Donut",
    @"Macaroon",
    @"SugarObject",
  };

  return spriteNames[self.ObjectType];
}

- (NSString *)highlightedSpriteName {
  static NSString * const highlightedSpriteNames[] = {
    @"",
    @"Croissant-Highlighted",
    @"Cupcake-Highlighted",
    @"Danish-Highlighted",
    @"Donut-Highlighted",
    @"Macaroon-Highlighted",
    @"SugarObject-Highlighted",
  };

  return highlightedSpriteNames[self.ObjectType];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"type:%ld square:(%ld,%ld)", (long)self.ObjectType, (long)self.column, (long)self.row];
}

@end
