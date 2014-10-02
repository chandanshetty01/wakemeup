//
//  WUNSwap.m
//  CookieCrunch
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

  // Two swaps are equal if they contain the same cookie, but it doesn't
  // matter whether they're called A in one and B in the other.
  WUNSwap *other = (WUNSwap *)object;
  return (other.cookieA == self.cookieA && other.cookieB == self.cookieB) ||
         (other.cookieB == self.cookieA && other.cookieA == self.cookieB);
}

- (NSUInteger)hash {
  return [self.cookieA hash] ^ [self.cookieB hash];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ swap %@ with %@", [super description], self.cookieA, self.cookieB];
}

@end
