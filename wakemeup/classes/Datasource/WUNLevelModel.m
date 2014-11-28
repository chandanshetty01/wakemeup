//
//  WUNLevelModel.m
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import "WUNLevelModel.h"

@implementation WUNLevelModel

-(id)initWithDictionary:(NSDictionary*)data
{
    self = [super init];
    if (self) {
        self.isCompleted = [[data objectForKey:@"iscompleted"] boolValue];
        self.isUnlocked = [[data objectForKey:@"isUnlocked"] boolValue];
        self.levelID = [[data objectForKey:@"ID"] integerValue];
    }
    return self;
}

-(NSDictionary*)levelData
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithBool:self.isCompleted] forKey:@"iscompleted"];
    [dictionary setObject:[NSNumber numberWithBool:self.isUnlocked] forKey:@"isUnlocked"];
    [dictionary setObject:[NSNumber numberWithInt:(int)self.levelID] forKey:@"ID"];
    return dictionary;
}

@end
