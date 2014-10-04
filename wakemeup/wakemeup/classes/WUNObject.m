//
//  WUNObject.m
//  ObjectCrunch
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNObject.h"

@implementation WUNObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)spriteName {
  static NSString * const spriteNames[] = {
    @"",
    @"sleep_smily",
    @"obstacle",
    @"circle"
  };

  return spriteNames[self.ObjectType];
}

- (NSString *)highlightedSpriteName {
  static NSString * const highlightedSpriteNames[] = {
      @"",
      @"sleep_smily",
      @"obstacle",
      @"circle"
  };

  return highlightedSpriteNames[self.ObjectType];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"type:%ld square:(%ld,%ld)", (long)self.ObjectType, (long)self.column, (long)self.row];
}

@end
