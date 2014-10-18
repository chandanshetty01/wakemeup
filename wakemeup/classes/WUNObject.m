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

-(id)initWithDictionary:(NSDictionary*)data
{
    self = [super init];
    if (self) {
        self.row =[[data objectForKey:@"row"] intValue];
        self.column =[[data objectForKey:@"column"] intValue];
        self.ObjectType =[[data objectForKey:@"objectType"] intValue];
        self.status =[[data objectForKey:@"status"] intValue];
    }
    return self;
}

-(NSDictionary*)saveData
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInt:self.row] forKey:@"row"];
    [dictionary setObject:[NSNumber numberWithInt:self.column] forKey:@"column"];
    [dictionary setObject:[NSNumber numberWithInt:self.ObjectType] forKey:@"objectType"];
    [dictionary setObject:[NSNumber numberWithInt:self.status] forKey:@"status"];
    return dictionary;
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

- (void)dealloc
{
    [_sprite removeFromParent];
}

@end
