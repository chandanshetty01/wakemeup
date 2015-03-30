//
//  AppDelegate.h
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Crashlytics/Crashlytics.h>
#import "iRate.h"
#import "AppsFlyerTracker.h"
#import <FacebookSDK/FacebookSDK.h>
#import <PushApps/PushApps.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,iRateDelegate,PushAppsDelegate,AppsFlyerTrackerDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

