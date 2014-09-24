//
//  WUNGameConfigManager.h
//  WakeUpNow
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import <Foundation/Foundation.h>

const NSString *kGrid_size;
const NSString *kCell_size;
const NSString *kLevels;
const NSString *kElements;
const NSString *kNoOfLevels;

@interface WUNGameConfigManager : NSObject

@property(nonatomic,assign) CGSize gridSize;
@property(nonatomic,assign) CGSize cellSize;
@property(nonatomic,assign,readonly) NSInteger noOfLevels;

-(NSMutableArray*)elementsForLevel:(NSInteger)inLevelNo;
-(NSString*)tutorialForLevel:(NSInteger)inLevelNo;

@end

