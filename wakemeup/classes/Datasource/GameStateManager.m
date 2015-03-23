//
//  GameStageManager.m
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import "GameStateManager.h"
#import "GameConfigManager.h"
#import "Utility.h"

#define kRootDictionary @"savedData"
#define kCurrentLevel @"currentLevel"
#define kCurrentStage @"currentStage"

@interface GameStateManager ()

@property(nonatomic,strong) NSMutableDictionary *gameData;
@property(nonatomic,assign) NSInteger currentStage;

@end

@implementation GameStateManager

+ (id) sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentLevel = 1;
        self.currentStage = 1;
        self.gameData = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSInteger)currentLevelNumber
{
    return [[self.gameData objectForKey:kCurrentLevel] intValue];
}

-(NSInteger)currentStageNumber
{
    return self.currentStage;
}

-(BOOL)isStageLocked:(NSInteger)stage
{
    BOOL status = true;
    return status;
}

-(void)setCurrentLevel:(NSInteger)currentLevel
{
    [self.gameData setObject:[NSNumber numberWithInt:(int)currentLevel] forKey:kCurrentLevel];
}

-(void)setData:(NSDictionary*)data level:(NSInteger)levelID
{
    NSArray *levels = [self getAllLevelsInStage];
    NSMutableArray *levelsArray = [levels mutableCopy];
    
    NSAssert((levelID>0 && levelID<=levels.count), @"Invalid levelID");
    [levelsArray replaceObjectAtIndex:levelID-1 withObject:data];
    [self.gameData setObject:levelsArray forKey:@"levels"];
}

-(BOOL)isLevelUnlocked:(NSInteger)level
{
    BOOL status = true;
    return status;
}

-(BOOL)isLevelCompleted:(NSInteger)level
{
    BOOL status = true;
    return status;
}

-(BOOL)isMusicEnabled
{
    NSNumber *isOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"isSoundEnabled"];
    if(isOn)
        return [isOn boolValue];
    else
        return YES;
}

-(void)setMusicEnabled:(BOOL)value
{
    NSNumber *isOn = [NSNumber numberWithBool:value];
    [[NSUserDefaults standardUserDefaults] setObject:isOn forKey:@"isSoundEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isSoundEnabled
{
    NSNumber *isOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"isMusicEnabled"];
    if(isOn)
        return [isOn boolValue];
    else
        return YES;
}

-(void)setSoundEnabled:(BOOL)value
{
    NSNumber *isOn = [NSNumber numberWithBool:value];
    [[NSUserDefaults standardUserDefaults] setObject:isOn forKey:@"isMusicEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableDictionary*)getLevelData:(NSInteger)levelID
{
    NSAssert(levelID > 0, @"Invalid LevelID, level should be greater than 0");
    NSMutableArray *levels = [[GameStateManager sharedManager] getAllLevelsInStage];
    return [levels objectAtIndex:levelID-1];
}

-(NSMutableArray*)getAllLevelsInStage
{
    NSAssert(self.currentStage > 0, @"stage must be greater than 0");
    NSMutableArray *levels = nil;
    levels = [self.gameData objectForKey:@"levels"];
    return levels;
}

-(NSInteger)getTotalMovementsTill:(NSInteger)levelNo
{
    __block NSInteger totalMoves = 0;
    NSArray *levels = [self getAllLevelsInStage];
    [levels enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        NSInteger levelID = [[obj objectForKey:@"ID"] integerValue];
        if(levelID < levelNo){
            NSInteger count = [[obj objectForKey:@"noOfMoves"] integerValue];
            totalMoves += count;
        }
    }];
    return totalMoves;
}

-(void)saveTilesForLevel:(NSDictionary*)levelData andLevelID:(NSInteger)levelID
{
    NSString *fileName = [NSString stringWithFormat:@"Saved_Level_%lu_%lu",(unsigned long)levelID,(unsigned long)self.currentStage];
    NSInteger bytesRead = [Utility saveJSON:levelData fileName:fileName];
    if(bytesRead <= 0){
        assert(@"Error saving file");
    }
}

-(NSMutableArray*)getTilesForLevel:(NSInteger)levelID
{
    NSMutableArray *tiles = nil;
    NSString *level = [NSString stringWithFormat:@"Saved_Level_%lu_%lu",(unsigned long)levelID,(unsigned long)self.currentStage];
    NSDictionary *dictionary = [Utility loadJSON:level];
    tiles = [dictionary objectForKey:@"tiles"];

    if(tiles == nil){
        dictionary = [[GameConfigManager sharedManager] dictionaryForLevel:levelID andStage:self.currentStage];
        tiles = [dictionary objectForKey:@"tiles"];
    }
    
    return tiles;
}

-(void)saveGameData
{
    NSAssert(self.currentStage > 0, @"stage must be greater than 0");
    
    if(self.gameData){
        NSString *fileName = [NSString stringWithFormat:@"%@_%ld",kRootDictionary,(long)self.currentStage];
        NSInteger byteswritten = [Utility saveJSON:self.gameData fileName:fileName];
        if(byteswritten <= 0){
            assert(@"Error in writing to file");
        }
    }
    else{
        assert(@"Game data doesn't exist");
    }
}

-(void)loadGameData
{
    NSAssert(self.currentStage > 0, @"stage must be greater than 0");
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%ld",kRootDictionary,(long)self.currentStage];
    NSDictionary *dictionary = [Utility loadJSON:fileName];
    if(dictionary){
        self.gameData = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    }
    else{
        //Load the default stage data
        NSString *fileName = [NSString stringWithFormat:@"stage_%ld",(long)self.currentStage];
        NSDictionary *dictionary = [Utility loadJSON:fileName];
        self.gameData = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    }
}

@end
