//
//  WUNBase.m
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import "WUNBase.h"

@implementation WUNBase

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
        
    }
    return self;
}

-(NSDictionary*)saveData
{
    return nil;
}

-(NSString *)spriteName
{
    return nil;
}

- (NSString *)highlightedSpriteName
{
    return nil;
}

- (NSString *)description
{
    return @"";
}

- (void)dealloc
{
    [_sprite removeFromParent];
}

@end
