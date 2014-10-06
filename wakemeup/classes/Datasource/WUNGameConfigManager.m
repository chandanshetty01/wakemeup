//
//  WUNGameConfigManager.m
//  WakeUpNow
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNGameConfigManager.h"


const NSString *kGrid_size =  @"grid_size";
const NSString *kCell_size =  @"cell_size";
const NSString *kLevels = @"levels";
const NSString *kElements = @"elements";
const NSString *kNoOfLevels = @"noOfLevels";
const NSString *kTutorial = @"tutorial";


@interface WUNGameConfigManager ()

@property(nonatomic,strong) NSDictionary *configuration;

@end

@implementation WUNGameConfigManager

+ (id) sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(id)init
{
    self =[super init];
    if(self)
    {
        NSString *strplistPath = [[NSBundle mainBundle] pathForResource:@"WUNGameConfig" ofType:@"plist"];
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:strplistPath];
        
        NSString *strerrorDesc = nil;
        NSPropertyListFormat plistFormat;
        // convert static property liost into dictionary object
        _configuration = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&plistFormat errorDescription:&strerrorDesc];
        if (!_configuration)
        {
            NSLog(@"Error reading plist: %@, format: %lu", strerrorDesc, plistFormat);
        }
        
        _gridSize = CGSizeFromString([_configuration objectForKey:kGrid_size]);
        _cellSize = CGSizeFromString([_configuration objectForKey:kCell_size]);
        _noOfLevels = [[_configuration objectForKey:kNoOfLevels] intValue];
    }
    return self;
}

-(NSDictionary*)levelData : (NSInteger)inLevelNo
{
    NSDictionary *levelData = nil;
    NSDictionary *levels = [_configuration objectForKey:kLevels];
    if(levels)
        levelData = [levels objectForKey:[NSString stringWithFormat:@"level%ld",(long)inLevelNo]];
    return levelData;
}

-(NSString*)tutorialForLevel:(NSInteger)inLevelNo
{
    NSString *tutorial = @"";
    NSDictionary *level = [self levelData:inLevelNo];
    if(level)
        tutorial =[level objectForKey:kTutorial];
    return tutorial;
}

-(NSMutableArray*)elementsForLevel:(NSInteger)inLevelNo
{
    NSMutableArray *elements = nil;
    NSDictionary *level = [self levelData:inLevelNo];
    if(level)
        elements = [level objectForKey:kElements];
    return elements;
}


@end
