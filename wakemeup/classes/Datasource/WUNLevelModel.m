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
        self.noOfMoves = [[data objectForKey:@"noOfMoves"] integerValue];
        self.bestNoOfMoves = [[data objectForKey:@"bestNoOfMoves"] integerValue];
        self.noOfTries = [[data objectForKey:@"noOfTries"] integerValue];
        if(!self.noOfTries){
            self.noOfTries = 1;
        }
    }
    return self;
}

-(NSDictionary*)levelData
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithBool:self.isCompleted] forKey:@"iscompleted"];
    [dictionary setObject:[NSNumber numberWithBool:self.isUnlocked] forKey:@"isUnlocked"];
    [dictionary setObject:[NSNumber numberWithInt:(int)self.levelID] forKey:@"ID"];
    [dictionary setObject:[NSNumber numberWithInt:(int)self.noOfMoves] forKey:@"noOfMoves"];
    [dictionary setObject:[NSNumber numberWithInt:(int)self.bestNoOfMoves] forKey:@"bestNoOfMoves"];
    if(self.noOfTries == 0){
        self.noOfTries = 1;
    }
    [dictionary setObject:[NSNumber numberWithInt:(int)self.noOfTries] forKey:@"noOfTries"];
    
    return dictionary;
}

@end
