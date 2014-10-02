//
//  RWTLevel.h
//  CookieCrunch
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNObject.h"
#import "WUNTile.h"
#import "WUNSwap.h"

static const NSInteger NumColumns = 8;
static const NSInteger NumRows = 4;

@interface WUNLevel : NSObject

- (instancetype)initWithFile:(NSString *)filename;

- (NSSet *)shuffle;

- (WUNObject *)cookieAtColumn:(NSInteger)column row:(NSInteger)row;
- (WUNTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;

- (void)performSwap:(WUNSwap *)swap;
- (BOOL)isPossibleSwap:(WUNSwap *)swap;

@end
