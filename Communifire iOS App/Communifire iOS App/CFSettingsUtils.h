//
//  CFSettingsUtils.h
//  Communifire
//
//  Created by Raghav Khunger on 07/12/16.
//  Copyright © 2016 Axero Solutions LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CFSettings.h"
#import "CFNotification.h"
#import "UIKit/UIKit.h"
#import "LoginViewController.h"
#import "CFUIWebViewController.h"

@interface CFSettingsUtils : NSObject
{
    
}
+(BOOL) isUserLoggedIn;
+(void) setCommunityNameByDomain :(NSString *) domain;
+(void) setDeviceTokenSentToServer :(BOOL) deviceTokenStatus;
+(BOOL) isDeviceTokenSentToServer;
+(NSString *)getDeviceToken;
+(void)setDeviceToken: (NSString *) deviceToken;
+(BOOL) isDeviceTokenEnabled;
+(void) sendDeviceTokenToServer;
+(void) checkDeviceTokenStatus;

@end
