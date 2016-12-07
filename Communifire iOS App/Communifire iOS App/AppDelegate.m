//
//  AppDelegate.m
//  TEDxHub iOS App
//
//  Created by Vivek Thakur on 18/01/15.
//  Copyright (c) 2015 Axero Solutions LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SSKeychain.h"
#import "Utils.h"
#import "CFSettingsUtils.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//Fetching Small Amounts of Content Opportunistically
/* Apps that need to check for new content periodically can ask the system to wake them up so that they can initiate a fetch operation for that content. To support this mode, enable the Background fetch option from the Background modes section of the Capabilities tab in your Xcode project. (You can also enable this support by including the UIBackgroundModes key with the fetch value in your app’s Info.plist file.) Enabling this mode is not a guarantee that the system will give your app any time to perform background fetches. The system must balance your app’s need to fetch content with the needs of other apps and the system itself. After assessing that information, the system gives time to apps when there are good opportunities to do so.
 
 When a good opportunity arises, the system wakes or launches your app into the background and calls the app delegate’s application:performFetchWithCompletionHandler: method. Use that method to check for new content and initiate a download operation if content is available. As soon as you finish downloading the new content, you must execute the provided completion handler block, passing a result that indicates whether content was available. Executing this block tells the system that it can move your app back to the suspended state and evaluate its power usage. Apps that download small amounts of content quickly, and accurately reflect when they had content available to download, are more likely to receive execution time in the future than apps that take a long time to download their content or that claim content was available but then do not download anything.
 
 When downloading any content, it is recommended that you use the NSURLSession class to initiate and manage your downloads. For information about how to use this class to manage upload and download tasks, see URL Loading System Programming Guide. */

//- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"content---%@", token);
//}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString * deviceTokenString = [[[deviceToken description]
                                     stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                    stringByReplacingOccurrencesOfString:@">" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [CFSettingsUtils setDeviceToken: deviceTokenString];
    NSLog(@"str: %@",deviceTokenString);
  
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"str: %@",str);
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
    
    if (app.applicationState != UIApplicationStateActive )
    {
        NSLog(@"app not running");
        NSDictionary *userInfo=notif.userInfo;
        
        [[NSNotificationCenter defaultCenter] postNotificationName: @"PushNotification" object:nil userInfo:userInfo];
    }
    else if(app.applicationState == UIApplicationStateActive )
    {
        NSLog(@"app running");
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if ( application.applicationState == UIApplicationStateActive )
    {
        // app was already in the foreground
    }
    else
    {
        NSLog(@"Received push notification");
        [[NSNotificationCenter defaultCenter] postNotificationName: @"PushNotification" object:nil userInfo:userInfo];
        
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"didFinishLaunchingWithOptions");
    
    // Set default domain name
    [CFSettingsUtils setCommunityNameByDomain: DEFAULT_DOMAIN];
    
    //Initialize background fetch.
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];

    // Below code will fire the app is opened via clicking notification from closed application state.
    if (launchOptions) { //launchOptions is not nil
        // Process remote notifications
        NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if (remoteNotification) {
            // Set the url for the remote controller so that the specific page can be opened on click of notificationj
            LoginViewController* mainController = (LoginViewController*)  self.window.rootViewController;
            NSString *url=[remoteNotification objectForKey:@"url"];
            if (url) {
                //url is not nil
                NSURL * nsURL =  [Utils getNSURL:url];
                mainController.urlToOpen=nsURL;
            }
        }
    }
    
    

    
    
    // Load Cookies
    [Utils loadHTTPCookies];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [Utils saveHTTPCookies];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Utils loadHTTPCookies];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [Utils saveHTTPCookies];
}

// GET LATEST NOTIFICATIONS AND MESSAGES
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //[Utils getNotifications];
    
    //Tell the system that you are done.
    completionHandler(UIBackgroundFetchResultNewData);
}



@end
