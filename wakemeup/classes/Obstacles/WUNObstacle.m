//
//  WUNObstacle.m
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import "WUNObstacle.h"

@implementation WUNObstacle

-(id)initWithDictionary:(NSDictionary*)data
{
    self = [super initWithDictionary:data];
    if (self) {
        self.obstacleType =[[data objectForKey:@"obstacleType"] intValue];
        self.duration =[[data objectForKey:@"duration"] floatValue];
        self.distance =[[data objectForKey:@"distance"] floatValue];
        self.position =CGPointFromString([data objectForKey:@"position"]);
        self.size =CGSizeFromString([data objectForKey:@"size"]);
    }
    return self;
}

-(NSDictionary*)saveData
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInt:(int)self.obstacleType] forKey:@"obstacleType"];
    [dictionary setObject:[NSNumber numberWithFloat:self.duration] forKey:@"duration"];
    [dictionary setObject:[NSNumber numberWithFloat:self.distance] forKey:@"distance"];
    [dictionary setObject:NSStringFromCGPoint(self.position) forKey:@"position"];
    [dictionary setObject:NSStringFromCGSize(self.size) forKey:@"size"];
    return dictionary;
}

+(NSDictionary*)testObjectData
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInt:(int)0] forKey:@"obstacleType"];
    [dictionary setObject:[NSNumber numberWithFloat:1] forKey:@"duration"];
    [dictionary setObject:[NSNumber numberWithFloat:100] forKey:@"distance"];
    [dictionary setObject:NSStringFromCGPoint(CGPointMake(100, 100)) forKey:@"position"];
    [dictionary setObject:NSStringFromCGSize(CGSizeMake(100, 17)) forKey:@"size"];
    return dictionary;
}

@end
