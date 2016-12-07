//
//  CFSettings.m
//  TEDxHub iOS App
//
//  Created by Vivek Thakur on 23/01/15.
//  Copyright (c) 2015 Axero Solutions LLC. All rights reserved.
//

#import "Utils.h"
#import "CFSettingsUtils.h"
#import "CFSettings.h"
#import "CFNotification.h"
#import "SSKeychain.h"
#import "UIKit/UIKit.h"
#import "LoginViewController.h"
#import "CFUIWebViewController.h"
#import "URLConstants.h"
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation Utils


+(CFSettings*) getCFSettings {
    
    CFSettings *cfSettings = [[CFSettings alloc] init];
    NSUserDefaults *userDefaults = [Utils getUserDefaults];
    
    cfSettings.CFCommunityUrl = [userDefaults stringForKey:@"CommunityUrl"];
    cfSettings.CFUsernameEmail = [userDefaults stringForKey:@"UsernameEmail"];
    cfSettings.CFUserPassword = [userDefaults stringForKey:@"UserPassword"];
    cfSettings.CFCommunityName = [userDefaults stringForKey:@"CommunityName"];
    cfSettings.CFApiKey = [userDefaults stringForKey:@"CFAPIKEY"];
    cfSettings.CFLastMessageID = [userDefaults stringForKey:@"LastMessageID"];
    cfSettings.CFLastNotificationID = [userDefaults stringForKey:@"LastNotificationID"];
    cfSettings.IsDeviceTokenSentToServer = [userDefaults boolForKey:@"IsDeviceTokenSentToServer"];
    return cfSettings;
}

+(void) setCFSettings: (CFSettings*) cfSettings{
    
    [SSKeychain setPassword:cfSettings.CFApiKey  forService:@"Communifire" account:@"CFAPIKEY"];
    [[NSUserDefaults standardUserDefaults] setValue:cfSettings.CFUsernameEmail forKey:@"UsernameEmail"];
    [[NSUserDefaults standardUserDefaults] setValue:cfSettings.CFUserPassword forKey:@"UserPassword"];
    [[NSUserDefaults standardUserDefaults] setValue:cfSettings.CFCommunityUrl forKey:@"CommunityUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:cfSettings.CFLastNotificationID forKey:@"LastNotificationID"];
    [[NSUserDefaults standardUserDefaults] setValue:cfSettings.CFLastMessageID forKey:@"LastMessageID"];
    [[NSUserDefaults standardUserDefaults] setValue:cfSettings.CFApiKey forKey:@"CFAPIKEY"];
    [[NSUserDefaults standardUserDefaults] setBool:cfSettings.IsDeviceTokenSentToServer forKey:@"IsDeviceTokenSentToServer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSURL*) getRestAPIKeyURL: (CFSettings*) cfSettings {
    
    NSString *restUrlString = [NSString stringWithFormat:@"%@/services/userservice.svc/users/user/restapikey?username=%@&password=%@&format=json", cfSettings.CFCommunityUrl, cfSettings.CFUsernameEmail,cfSettings.CFUserPassword];
    
    NSURL *restUrl = [NSURL URLWithString:restUrlString];
    return restUrl;
}

+(NSURL*) getAddDeviceTokenURL{
    
    NSString *restUrlString = [NSString stringWithFormat:@"%@/services/userservice.svc/users/tokens?isActive=true&deviceToken=%@&deviceType=1&token=%@",[Utils getCommuntityURL],[CFSettingsUtils getDeviceToken],[Utils getApiKey]];
    
    NSURL *restUrl = [NSURL URLWithString:restUrlString];
    return restUrl;
}


+(NSURL*) getNotificationsURL {
    
    NSString *restUrlString = [NSString stringWithFormat:@"%@/services/NotificationsService.svc/notifications?lastNotificationID=%@&startPage=1&numberOfRecords=10&token=%@&format=json", [Utils getCommuntityURL], [Utils getLastNotificationID],  [Utils getApiKey]];
    
    NSURL *restUrl = [NSURL URLWithString:restUrlString];
    
    return restUrl;
}

+(NSURL*) getApplicationDetailsURL {
    
    NSString *restUrlString = [NSString stringWithFormat:@"%@/services/CommonService.svc/application/details?token=%@&format=json", [Utils getCommuntityURL], [Utils getApiKey]];
    NSURL *restUrl = [NSURL URLWithString:restUrlString];
    
    
    return restUrl;
}

+(NSURL*) getNSURL: (NSString*) url  {
    NSString *userCFUrl=[NSString stringWithFormat:@"%@%@",[Utils getCommuntityURL],url];
    
    NSURL * nsURL =  [NSURL URLWithString:userCFUrl];
    return nsURL;
}

+(NSURL*) getSecuredLoginURL {
    NSString *userCFUrl = [Utils getCommuntityURL];
    NSString *apiKey= [Utils getApiKey];
    
    userCFUrl =[NSString stringWithFormat:@"%@/securedlogin?Rest-Api-Key=%@",userCFUrl,apiKey];
    
    NSURL * nsURL =  [NSURL URLWithString:[Utils makeUrlFromDomain:userCFUrl]];
    return nsURL;
}

+(BOOL) isUrlValid: (NSString *) url {
//    NSString *urlRegEx =
//    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
//    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
//    return [urlTest evaluateWithObject:url];
     return true;
}

+(NSString *) makeUrlFromDomain:(NSString *)domain
{
    NSString *url;
    url=domain;
    if (![domain hasPrefix:@"http"])
    {
        url= [NSString stringWithFormat:@"http://%@", domain];
    }
    
    if ([domain hasSuffix:@"/"])
    {
        url = [domain substringToIndex:[domain length] - 1];
    }
    return url;
}

+(LoginStatus) getLoginStatus:(NSString *)communityName : (NSString *) uname : (NSString *) password
{
    LoginStatus ls=Success;
    
    if(![Utils isNetworkAvailable])
    {
        ls= InternetConnectionMissing;
    }
    // Validations
    
    
    
    if(ls == Success && [communityName isEqualToString:@""])
    {
        ls= InvalidUrl;
    }
    
    NSString  * url=[Utils makeUrlFromDomain:communityName];
    if(ls == Success && ![Utils isUrlValid:url])
    {
        ls= InvalidUrl;
    }
    
    if(ls == Success && [uname isEqualToString:@""])
    {
        ls= UsernameMissing;
    }
    
    if(ls == Success && [password isEqualToString:@""])
    {
        ls= PasswordMissing;
    }
    return ls;
}

+(NSString *)getLoginStatusMessage: (LoginStatus) loginStatus
{
    NSString * message;
    switch (loginStatus){
        case InternetConnectionMissing:
            message =@"Please check your internet connection.";
            break;
        case InvalidUrl:
            message =@"Please enter a valid community url.";
            break;
        case UsernameMissing:
            message =@"Please enter your username or email.";
            break;
        case PasswordMissing:
            message =@"Please enter your password.";
            break;
        case InvalidCrentials:
            message =@"Please enter valid credentials.";
            break;
        case Error:
            message =@"An error occurred while processing your request, try again later.";
            break;
        case TimedOutError:
            message =@"Server is not responding, try again later.";
            break;
        case Success:
            message =@"Success.";
            break;
    }
    
    return message;
}
+(void)logoutWithoutRedirect{
    // Reset user defaults
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        // Preserve UsernameEmail and CommunityUrl fields for next login
        if ([key isEqualToString:@"UsernameEmail"] || [key isEqualToString:@"CommunityUrl"]|| [key isEqualToString:@"DeviceToken"]){
            //NSLog(@"Key which are preserverd: %@",  key);
        }
        else{
            [defs removeObjectForKey:key];
        }
    }
    [defs synchronize];
}

+(void)loadLoginViewController: (id)instance {
    
    LoginViewController *vc1 = [Utils getLoginViewController];
    [instance presentViewController:vc1 animated:YES completion:nil];
}

+(void)loadWebViewController: (id)instance {
    
    CFUIWebViewController *vc1 = [Utils getWebViewController];
    [instance presentViewController:vc1 animated:NO completion:nil];
}

+(UIStoryboard *)getStoryBoard{
    
    UIStoryboard *sboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return sboard;
    
}

+(CFUIWebViewController *)getWebViewController{
    
    CFUIWebViewController *vc1 = [[Utils getStoryBoard] instantiateViewControllerWithIdentifier:@"CFUIWebViewController"];
    return vc1;
    
}


+(LoginViewController *)getLoginViewController{
    
    LoginViewController *vc1 = [[Utils getStoryBoard] instantiateInitialViewController];
    return vc1;
    
}

+(void)logout: (id)instance {
    
//    [CFSettingsUtils setDeviceTokenSentToServer:NO];
    
    [self deleteAllCookies];
    
    [self logoutWithoutRedirect];
    
    //[Utils loadLoginViewController:instance];
    

    
}

+(NSUserDefaults *)getUserDefaults{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return userDefaults;
}

+(NSString *)getLastNotificationID {
    //return @"0";
    NSUserDefaults *userDefaults = [Utils getUserDefaults];
    NSString *lastNotificationID = [userDefaults stringForKey:@"LastNotificationID"];
    if([lastNotificationID length] == 0)
    {
        lastNotificationID=@"0";
    }
    return lastNotificationID;
}


+(void)setLastNotificationID: (NSString *) lastNotificationID{
    
    NSLog(@"LastNotificationID is: %@",  lastNotificationID);
    [[NSUserDefaults standardUserDefaults] setValue: lastNotificationID forKey:@"LastNotificationID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setLastNotificationIDByNotification: (CFNotification *) notification{
    
    if(notification!=nil)
    {
        NSString * lastNotificationID=notification.NotificationID;
        [Utils setLastNotificationID:lastNotificationID];
    }
}


+(NSString *)getUsername {
    
    NSUserDefaults *userDefaults = [Utils getUserDefaults];
    NSString *userCFUrl = [userDefaults stringForKey:@"UsernameEmail"];
    return userCFUrl;
}

+(NSString *)getCommuntityURL {
    
    NSUserDefaults *userDefaults = [Utils getUserDefaults];
    NSString *userCFUrl = [userDefaults stringForKey:@"CommunityUrl"];
    return userCFUrl;
}

+(NSString *)getCommunityName {
    
    NSUserDefaults *userDefaults = [Utils getUserDefaults];
    NSString *userCFUrl = [userDefaults stringForKey:@"CommunityName"];
    return userCFUrl;
}

+(NSString *)getApiKey {
    
    return [SSKeychain passwordForService:@"Communifire" account:@"CFAPIKEY"];
}

+(NSURLRequest *)getNSURLRequest:(NSURL *) url
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    return urlRequest;
}

+ (void)addDeviceToken {
    
    NSURL *restUrl = [Utils getAddDeviceTokenURL];
    
    @try {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:restUrl];
        
        [request setHTTPMethod:@"PUT"];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data, NSError *connectionError)
         {
             if (data.length > 0 && connectionError == nil)
             {
               
             }
         }];
    }
    @catch (NSException *exception) {
        //<#Handle an exception thrown in the @try block#>
        NSLog(@"Exception: %@",exception);
    }
    @finally {
        //
    }
}

+ (void)setCommunityName :(CFSettings *) cfSettings {
    
    NSURL *restUrl = [Utils getApplicationDetailsURL];
    
    @try {
        NSURLRequest *request = [NSURLRequest requestWithURL:restUrl];
       
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data, NSError *connectionError)
         {
             if (data.length > 0 && connectionError == nil)
             {
                 NSDictionary *returnValue = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:0
                                                                               error:NULL];
                 
                 cfSettings.CFCommunityName = [returnValue objectForKey:@"ResponseData"];
                 
                 NSLog(@"Community name is: %@",  cfSettings.CFCommunityName);
                 
                 [[NSUserDefaults standardUserDefaults] setValue:cfSettings.CFCommunityName  forKey:@"CommunityName"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
         }];
    }
    @catch (NSException *exception) {
        //<#Handle an exception thrown in the @try block#>
        NSLog(@"Exception: %@",exception);
    }
    @finally {
        //
    }
}


// METHOD TO GET NOTIFICATIONS
+ (void)getNotifications {
    
//    NSDate *date=[NSDate dateWithTimeIntervalSinceNow: 10];
//    UILocalNotification* n1 = [[UILocalNotification alloc] init];
//    n1.fireDate =date;
//    n1.alertBody = @"one";
//    
//    UILocalNotification* n2 = [[UILocalNotification alloc] init];
//    n2.fireDate = date;
//    n2.alertBody = @"two";
//    
//    UILocalNotification* n3 = [[UILocalNotification alloc] init];
//    n3.fireDate = date;
//    n3.alertBody = @"three";
//    
//    [[UIApplication sharedApplication] scheduleLocalNotification: n1];
//    [[UIApplication sharedApplication] scheduleLocalNotification: n2];
//    [[UIApplication sharedApplication] scheduleLocalNotification: n3];
    if ([CFSettingsUtils isUserLoggedIn])
    {
        NSURL *restUrl = [Utils getNotificationsURL];
        
        @try {
            NSURLRequest *request = [NSMutableURLRequest requestWithURL:restUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
             NSLog(@"Url requested for notification is: %@",  restUrl);
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responseCode, NSData *responseData, NSError *connectionError)
             {
                 if (responseData!= nil)
                 {
                          //NSLog(@"responseData: %@",  responseData);
                     NSDictionary *returnValue = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                 options:0
                                                                                   error:NULL];
                     
                     
                     NSDictionary  *array= [returnValue objectForKey:@"ResponseData"];
                     
                     if (array!= nil)
                     {
                        NSDate *date=[NSDate dateWithTimeIntervalSinceNow: 15];
                         
                         NSMutableArray *notificationArray=[[NSMutableArray alloc] init];
                         
                         for (id object in array) {
                             CFNotification *cfNotification = [[CFNotification alloc] init];
                             
                             cfNotification.ActionText=[object objectForKey:@"ActionText"];
                             cfNotification.DateCreated=[object objectForKey:@"DateCreated"];
                             cfNotification.AvatarImageURL=[object objectForKey:@"AvatarImageURL"];
                             cfNotification.FromUser=[[object objectForKey:@"FromUser"] objectForKey:@"UserInfoDisplayName"];;
                             cfNotification.Subject=[object objectForKey:@"Subject"];
                             cfNotification.UserAvatarImage=[object objectForKey:@"UserAvatarImage"];
                             cfNotification.NotificationID=[object objectForKey:@"ID"];
                             
                             [notificationArray addObject: cfNotification];
                             
                             UILocalNotification* n1 = [[UILocalNotification alloc] init];
                             n1.alertBody= [NSString stringWithFormat:@"%@ %@", cfNotification.FromUser, cfNotification.ActionText];
                             n1.fireDate =date;
                             n1.applicationIconBadgeNumber = 1;
                             n1.soundName = UILocalNotificationDefaultSoundName ;
                             
                             [[UIApplication sharedApplication] scheduleLocalNotification: n1];
                             
                         }
                         
                         // At this point we have an array of notifications in notificationArray object
                         // Show notifications based on the items of this array
                         
                        
                         
                         
                         if([notificationArray count]>0)
                         {
                             [Utils setLastNotificationIDByNotification:[notificationArray objectAtIndex: 0]];
                         }
                     }
                 }
             }];
        }
        @catch (NSException *exception) {
            //<#Handle an exception thrown in the @try block#>
            NSLog(@"Exception: %@",exception);
        }
        @finally {
            //
        }
    }
}

+(BOOL)isLogoutRequest:(NSURLRequest*)request
{
    //CAPTURE USER LINK-CLICK.
    NSURL *url = [request URL];
    NSString *str =   [url absoluteString];
    
    return[str hasSuffix:@"logout"];
}

+(BOOL)isLogoutUrl:(NSString*)str
{
    return[str hasSuffix:@"logout"];
}
+(BOOL)isNetworkAvailable
{
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com" );
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    
    bool canReachOnExistingConnection =     success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    
    if( canReachOnExistingConnection )
        NSLog(@"Network available");
    else
        NSLog(@"Network not available");
    
    return canReachOnExistingConnection;
}


// METHOD TO GET NOTIFICATIONS
/*- (void)getNotifications:(CFSettings *) cfSettings {
 
 // Get the saved API Key first
 NSString *apiKey= [SSKeychain passwordForService:@"Communifire" account:@"CFAPIKEY"];
 
 
 NSString *restUrlString = [NSString stringWithFormat:@"http://%@/services/NotificationsService.svc/notifications?lastNotificationID=%@&startPage=1&numberOfRecords=10&token=%@&format=json", cfSettings.CFCommunityUrl, cfSettings.CFLastNotificationID, apiKey];
 NSURL *restUrl = [NSURL URLWithString:restUrlString];
 
 @try {
 NSURLRequest *request = [NSURLRequest requestWithURL:restUrl];
 [NSURLConnection sendAsynchronousRequest:request
 queue:[NSOperationQueue mainQueue]
 completionHandler:^(NSURLResponse *response,
 NSData *data, NSError *connectionError)
 {
 if (data.length > 0 && connectionError == nil)
 {
 NSDictionary *returnValue = [NSJSONSerialization JSONObjectWithData:data
 options:0
 error:NULL];
 
 cfSettings.Las = [returnValue objectForKey:@"ResponseData"];
 
 
 
 NSString *restUrlString = [NSString stringWithFormat:@"http://%@/", self.viewController.CommunityUrl];
 
 NSURL *restUrl = [NSURL URLWithString:restUrlString];
 
 
 
 NSLog(@"Community name is: %@",  cfSettings.CFCommunityName);
 
 [[NSUserDefaults standardUserDefaults] setValue:cfSettings.CFLastNotificationID  forKey:@"CFLastNotificationID"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 }
 }];
 }
 @catch (NSException *exception) {
 //<#Handle an exception thrown in the @try block#>
 }
 @finally {
 //
 }
 }
 
 
 // METHOD TO GET MESSAGES
 - (void)getMessages:(CFSettings *) cfSettings {
 
 // Get the saved API Key first
 NSString *apiKey= [SSKeychain passwordForService:@"Communifire" account:@"CFAPIKEY"];
 
 NSString *restUrlString = [NSString stringWithFormat:@"http://%@/services/NotificationsService.svc/messages/unread?lastMessageID=%@&startPage=1&numberOfRecords=20&token=%@&format=json", cfSettings.CFCommunityUrl, cfSettings.CFLastMessageID, apiKey];
 NSURL *restUrl = [NSURL URLWithString:restUrlString];
 
 @try {
 NSURLRequest *request = [NSURLRequest requestWithURL:restUrl];
 [NSURLConnection sendAsynchronousRequest:request
 queue:[NSOperationQueue mainQueue]
 completionHandler:^(NSURLResponse *response,
 NSData *data, NSError *connectionError)
 {
 if (data.length > 0 && connectionError == nil)
 {
 NSDictionary *returnValue = [NSJSONSerialization JSONObjectWithData:data
 options:0
 error:NULL];
 
 cfSettings.Las = [returnValue objectForKey:@"ResponseData"];
 
 
 
 NSString *restUrlString = [NSString stringWithFormat:@"http://%@/", self.viewController.CommunityUrl];
 
 NSURL *restUrl = [NSURL URLWithString:restUrlString];
 
 
 
 NSLog(@"Community name is: %@",  cfSettings.CFCommunityName);
 
 [[NSUserDefaults standardUserDefaults] setValue:cfSettings.CFLastMessageID  forKey:@"CFLastMessageID"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 }
 }];
 }
 @catch (NSException *exception) {
 //<#Handle an exception thrown in the @try block#>
 }
 @finally {
 //
 }
 }*/

+ (void) showActivityIndicator :  (UIActivityIndicatorView*) activityIndicator  {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //[activityIndicator startAnimating];
}

+ (void) hideActivityIndicator : (UIActivityIndicatorView*) activityIndicator  {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[activityIndicator stopAnimating];
}

+(BOOL)isStatusBarHidden {
    
    return [UIApplication sharedApplication].isStatusBarHidden;
}
+(CGFloat) getStatusBarHeight{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

+ (void) setWebViewDimensions :  (WKWebView*) webView   : (UIView *) parentView: (UIToolbar *) toolbar {
    if (![Utils isStatusBarHidden]) {
        webView.frame = CGRectMake(0, [Utils getStatusBarHeight], parentView.frame.size.width, parentView.frame.size.height-toolbar.frame.size.height-20);
    }
    else{
        webView.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height-toolbar.frame.size.height);
    }
}

+(void)deleteAllCookies {
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSURLRequest *)getLoginURLRequestForWebView
{
    // Redirect to Myaccount for default url
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[Utils getNSURL: MYACCOUNT_URL]];
    return urlRequest;
}

+(BOOL) isUserLoggedInOnServer {
    __block BOOL isUserLoggedInOnServer = false;
    @try {
        
        NSURL *restUrl = [Utils getNSURL: GET_ME_API_URL];
        NSURLRequest *request = [NSMutableURLRequest requestWithURL:restUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        NSError *connectionError = nil;
        NSHTTPURLResponse *responseCode = nil;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&connectionError];
        
        
        NSInteger statusCodeResponse = responseCode.statusCode;
        
        NSString *strError = [NSString stringWithFormat:@"%@", [connectionError description]];
        if ([strError rangeOfString:@"Code=-1012"].location != NSNotFound) {
            statusCodeResponse = 401;
        }
        if (connectionError.code == kCFURLErrorUserCancelledAuthentication) {
            statusCodeResponse = 401;
        }
        
        if (responseData != nil)
        {
            NSDictionary *returnValue = [NSJSONSerialization JSONObjectWithData:responseData
                                                                        options:0
                                                                          error:NULL];
            if (returnValue != nil)
            {
                isUserLoggedInOnServer = true;
            }
            else{
            }
        }
        else
        {
            NSLog(@"Exception: %@",@"Response Data empty");
        }
        return isUserLoggedInOnServer;
        
    }
    @catch (NSException *exception)
    {
        //<#Handle an exception thrown in the @try block#>
        NSLog(@"Exception: %@", exception);
        
    }
    @finally
    {
        
    }
    
}


+(void)loadHTTPCookies
{
    NSMutableArray* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    
    for (int i=0; i < cookieDictionary.count; i++)
    {
        NSMutableDictionary* cookieDictionary1 = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary1];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

+(void)saveHTTPCookies
{
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookieArray addObject:cookie.name];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
        [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
        [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
        [cookieProperties setObject:[NSNumber numberWithUnsignedInteger:cookie.version] forKey:NSHTTPCookieVersion];
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
        
        [[NSUserDefaults standardUserDefaults] setValue:cookieProperties forKey:cookie.name];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:cookieArray forKey:@"cookieArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
