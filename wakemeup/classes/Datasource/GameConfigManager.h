//
//  WUNGameConfigManager.h
//  WakeUpNow
//
//  Created by S P, Chandan Shetty (external - Project) on 2/7/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GameConfigManager : NSObject
{
    
}

+(id)sharedManager;
-(NSDictionary*)dictionaryForLevel:(NSInteger)levelID andStage:(NSInteger)stageID;

@end

