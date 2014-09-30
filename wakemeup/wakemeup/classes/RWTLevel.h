//
//  RWTLevel.h
//  CookieCrunch
//
//  Created by Matthijs on 26-02-14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "RWTCookie.h"
#import "RWTTile.h"
#import "RWTSwap.h"

static const NSInteger NumColumns = 8;
static const NSInteger NumRows = 4;

@interface RWTLevel : NSObject

- (instancetype)initWithFile:(NSString *)filename;

- (NSSet *)shuffle;

- (RWTCookie *)cookieAtColumn:(NSInteger)column row:(NSInteger)row;
- (RWTTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;

- (void)performSwap:(RWTSwap *)swap;
- (BOOL)isPossibleSwap:(RWTSwap *)swap;

@end
