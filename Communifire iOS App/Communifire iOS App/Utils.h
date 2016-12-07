//
//  CFSettings.h
//  TEDxHub iOS App
//
//  Created by Vivek Thakur on 23/01/15.
//  Copyright (c) 2015 Axero Solutions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFSettings.h"
#import "CFNotification.h"
#import "UIKit/UIKit.h"
#import "LoginViewController.h"
#import "CFUIWebViewController.h"
#import "URLConstants.h"

@interface Utils : NSObject
{
    
}
+(NSURLRequest *)getNSURLRequest:(NSURL *) url;
+(NSURL*) getNSURL: (NSString*) url;
+ (void)addDeviceToken;
+(CFSettings*) getCFSettings;
+(void) setCFSettings: (CFSettings*) cfSettings;
+(NSURL*) getRestAPIKeyURL: (CFSettings*) cfSettings;
+(NSURL*) getNotificationsURL;
+(NSURL*) getApplicationDetailsURL;
+(NSURL*) getAddDeviceTokenURL;
+(NSURL*) getSecuredLoginURL;
+(BOOL) isUrlValid: (NSString *) url;
+(void)logout: (id)instance;
+(void)logoutWithoutRedirect;
+(NSString *)makeUrlFromDomain:(NSString *)domain;
+ (void)getNotifications;
+ (void) showActivityIndicator :  (UIActivityIndicatorView*) activityIndicator;
+ (void) hideActivityIndicator : (UIActivityIndicatorView*) activityIndicator;
+(BOOL)isLogoutRequest:(NSURLRequest*)request;
+(NSURLRequest *)getLoginURLRequestForWebView;
+(NSString *)getUsername;
+(NSString *)getCommuntityURL;
+(NSString *)getCommunityName;
+(NSString *)getApiKey;
+(NSUserDefaults *)getUserDefaults;
+(UIStoryboard *)getStoryBoard;
+(CFUIWebViewController *)getWebViewController;
+(LoginViewController *)getLoginViewController;
+(void)loadLoginViewController: (id)instance ;
+(void)loadWebViewController: (id)instance;
+(NSString *)getLoginStatusMessage: (LoginStatus) loginStatus;
+(LoginStatus) getLoginStatus:(NSString *)communityName : (NSString *) uname : (NSString *)password;
+(BOOL)isNetworkAvailable;
+ (void)setCommunityName :(CFSettings *) cfSettings;
+(NSString *)getLastNotificationID;
+(void)setLastNotificationID: (NSString *) lastNotificationID;
+(void)setLastNotificationIDByNotification: (CFNotification *) notification;
+(BOOL)isLogoutUrl: (NSString *) str;
+(BOOL)isStatusBarHidden;
+(CGFloat)getStatusBarHeight;
+(void)setWebViewDimensions: (WKWebView *)webView: (UIView *) parentView: (UIToolbar *) toolbar;
+(void)deleteAllCookies;
+(BOOL) isUserLoggedInOnServer;
+(void)loadHTTPCookies;
+(void)saveHTTPCookies;

@end
