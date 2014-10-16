//
//  GameStageManager.h
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameStageManager : NSObject

+(id)sharedManager;

-(NSInteger)currentLevelNumber;
-(NSInteger)currentStageNumber;
-(BOOL)isStageLocked:(NSInteger)stage;
-(void)setCurrentLevel:(NSInteger)currentLevel;
-(void)setData:(NSMutableDictionary*)data level:(NSInteger)level;
-(BOOL)isLevelUnlocked:(NSInteger)level;
-(BOOL)isLevelCompleted:(NSInteger)level;
-(NSDictionary*)gameData:(NSInteger)level;
-(BOOL)isMusicEnabled;
-(void)setMusicEnabled:(BOOL)value;
-(BOOL)isSoundEnabled;
-(void)setSoundEnabled:(BOOL)value;
-(void)saveGameData;
-(void)loadGameData;

@end
