//
//  GameStageManager.m
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import "GameStageManager.h"
#import "Utility.h"

#define kRootDictionary @"savedData"
#define kCurrentLevel @"currentLevel"
#define kCurrentStage @"currentStage"

@interface GameStageManager ()

@property(nonatomic,strong) NSMutableDictionary *gameData;
@property(nonatomic,assign) NSInteger currentLevel;
@property(nonatomic,assign) NSInteger currentStage;

@end

@implementation GameStageManager

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
        self.currentStage = -1;
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
    self.currentLevel = currentLevel;
}

-(void)setData:(NSMutableDictionary*)data level:(NSInteger)level
{
    
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

-(NSDictionary*)gameData:(NSInteger)level
{
    NSDictionary *dictionary = nil;
    return dictionary;
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

-(void)saveGameData
{
    assert(self.currentStage > 0);
    
    if(self.gameData){
        NSString *fileName = [NSString stringWithFormat:@"%@_%d",kRootDictionary,self.currentStage];
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
    assert(self.currentStage > 0);
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%d",kRootDictionary,self.currentStage];
    NSDictionary *dictionary = [Utility loadJSON:fileName];
    if(dictionary){
        self.gameData = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    }
    else{
        assert(@"Game data doesn't exist");
    }
}

@end
