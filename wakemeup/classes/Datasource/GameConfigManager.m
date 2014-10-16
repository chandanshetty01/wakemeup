//
//  WUNGameConfigManager.m
//  WakeUpNow
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "GameConfigManager.h"
#import "Utility.h"

@interface GameConfigManager ()

@property(nonatomic,strong) NSDictionary *configuration;

@end

@implementation GameConfigManager

+ (id) sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(NSDictionary*)dictionaryForLevel:(NSInteger)levelID andStage:(NSInteger)stageID
{
    NSString *level = [NSString stringWithFormat:@"Level_%lu_%lu",(unsigned long)levelID,(unsigned long)stageID];
    NSDictionary *dictionary = [Utility loadJSON:level];
    return dictionary;
}

-(id)init
{
    self =[super init];
    if(self)
    {

    }
    return self;
}

@end
