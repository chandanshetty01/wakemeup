//
//  AppDelegate.m
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate () <iRateDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    [Flurry setAppVersion:versionString];
    [Flurry startSession:FLURRY_ID];
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uniqueIdentifier = ( NSString*)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));// for ARC
    CFRelease(uuid);
    [Flurry setUserID:uniqueIdentifier];
    
    [[PushAppsManager sharedInstance] startPushAppsWithAppToken:@"58895e19-2f7f-4250-8b88-21bdb8a5a258" withLaunchOptions:launchOptions];
    [Crashlytics startWithAPIKey:@"ef1df6810a8ae85dc6971ad31a2311a71214d012"];
    
    [iRate sharedInstance].delegate = self;
    [iRate sharedInstance].appStoreID = APPSTORE_ID;
    [self setUpAppsFlyer:uniqueIdentifier];

    // Override point for customization after application launch.
    return YES;
}

-(void)setUpAppsFlyer:(NSString*)userID
{
    [AppsFlyerTracker sharedTracker].appleAppID = [NSString stringWithFormat:@"%d",APPSTORE_ID];
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = @"qGjii8LerKTNTiLyprmCo";
    [AppsFlyerTracker sharedTracker].customerUserID = userID;
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [[PushAppsManager sharedInstance] didRegisterUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    [[PushAppsManager sharedInstance] handleActionWithIdentifier:identifier forRemoteNotification:userInfo
                                               completionHandler:completionHandler];
}
#endif
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Notify PushApps of a successful registration.
    [[PushAppsManager sharedInstance] updatePushToken:deviceToken];
}

// Gets called when a remote notification is received while app is in the foreground.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[PushAppsManager sharedInstance] handlePushMessageOnForeground:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // keeps you up to date with any errors during push setup.
    [[PushAppsManager sharedInstance] updatePushError:error];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[PushAppsManager sharedInstance] clearApplicationBadge];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // track launch - It's VERY important that this code will be located in the applicationDidBecomeActive of your app delegate!
    [[AppsFlyerTracker sharedTracker] trackAppLaunch]; //***** THIS LINE IS MANDATORY *****
    
   [FBSettings setDefaultAppID:FACEBOOK_ID];
   [FBAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -iRate delegate -

- (void)iRateCouldNotConnectToAppStore:(NSError *)error
{
    [Flurry logEvent:@"Rate-ConnectionError"];
}

- (void)iRateDidPromptForRating
{
    [Flurry logEvent:@"Rate-Prompted"];
}

- (void)iRateUserDidAttemptToRateApp
{
    [Flurry logEvent:@"Rate-AttemptToRate"];
}

- (void)iRateUserDidDeclineToRateApp
{
    [Flurry logEvent:@"Rate-Declined"];
}

- (void)iRateUserDidRequestReminderToRateApp
{
    [Flurry logEvent:@"Rate-RemindMeLater"];
}

- (void)iRateDidOpenAppStore
{
    [Flurry logEvent:@"Rate-OpenAppStore"];
}


@end
