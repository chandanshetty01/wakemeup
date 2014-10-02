//
//  WUNSwap.m
//  ObjectCrunch
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNSwap.h"
#import "WUNObject.h"

@implementation WUNSwap

- (BOOL)isEqual:(id)object {
  // You can only compare this object against other WUNSwap objects.
  if (![object isKindOfClass:[WUNSwap class]]) return NO;

  // Two swaps are equal if they contain the same Object, but it doesn't
  // matter whether they're called A in one and B in the other.
  WUNSwap *other = (WUNSwap *)object;
  return (other.ObjectA == self.ObjectA && other.ObjectB == self.ObjectB) ||
         (other.ObjectB == self.ObjectA && other.ObjectA == self.ObjectB);
}

- (NSUInteger)hash {
  return [self.ObjectA hash] ^ [self.ObjectB hash];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ swap %@ with %@", [super description], self.ObjectA, self.ObjectB];
}

@end
