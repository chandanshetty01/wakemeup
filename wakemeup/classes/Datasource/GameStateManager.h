//
//  GameStageManager.h
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameStateManager : NSObject

+(id)sharedManager;

-(NSInteger)currentLevelNumber;
-(NSInteger)currentStageNumber;
-(BOOL)isStageLocked:(NSInteger)stage;
-(void)setCurrentLevel:(NSInteger)currentLevel;
-(void)setData:(NSDictionary*)data level:(NSInteger)level;
-(BOOL)isLevelUnlocked:(NSInteger)level;
-(BOOL)isLevelCompleted:(NSInteger)level;
-(BOOL)isMusicEnabled;
-(void)setMusicEnabled:(BOOL)value;
-(BOOL)isSoundEnabled;
-(void)setSoundEnabled:(BOOL)value;
-(void)saveGameData;
-(void)loadGameData;
-(NSMutableDictionary*)getLevelData:(NSInteger)levelID;
-(NSMutableArray*)getTilesForLevel:(NSInteger)levelID;
-(void)saveTilesForLevel:(NSDictionary*)levelData andLevelID:(NSInteger)levelID;
-(NSMutableArray*)getAllLevelsInStage;

@end
