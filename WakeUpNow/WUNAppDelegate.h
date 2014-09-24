//
//  WUNAppDelegate.h
//  WakeUpNow
//
//  Created by S P, Chandan Shetty (external - Project) on 2/5/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUNGameConfigManager.h"

@interface WUNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic,readonly) WUNGameConfigManager *configuration;

@end
