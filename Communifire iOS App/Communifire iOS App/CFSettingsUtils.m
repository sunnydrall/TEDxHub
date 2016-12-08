//
//  CFSettingsUtils.m
//  Communifire
//
//  Created by Raghav Khunger on 07/12/16.
//  Copyright © 2016 Axero Solutions LLC. All rights reserved.
//

#import "Utils.h"
#import "CFSettingsUtils.h"
#import "CFSettings.h"
#import "CFNotification.h"
#import "SSKeychain.h"
#import "UIKit/UIKit.h"
#import "LoginViewController.h"
#import "CFUIWebViewController.h"
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation CFSettingsUtils

+(BOOL) isUserLoggedIn {
    //    CFSettings *cfSettings= [Utils getCFSettings];
    //    return !([cfSettings.CFApiKey length] == 0);
    
    // For now just used isDeviceTokenSentToServer status as the indicator for user logged in status
    
    return [self isDeviceTokenSentToServer];
}

+ (void) setCommunityNameByDomain : (NSString *) domain  {
    
    CFSettings *cfSettings = [Utils getCFSettings];
    cfSettings.CFCommunityUrl = [Utils makeUrlFromDomain:domain];
    [Utils setCFSettings:cfSettings];
    
}

+ (void) setDeviceTokenSentToServer : (BOOL) isDeviceTokeSent  {
    
    CFSettings *cfSettings = [Utils getCFSettings];
    cfSettings.IsDeviceTokenSentToServer = isDeviceTokeSent;
    [Utils setCFSettings:cfSettings];
    
}

+ (BOOL) isDeviceTokenSentToServer {
    CFSettings *cfSettings = [Utils getCFSettings];
    return cfSettings.IsDeviceTokenSentToServer;
    
}

+ (BOOL) isDeviceTokenEnabled {
    NSString *deviceToken = [self getDeviceToken];
    return deviceToken!=nil;
    
}

+(void)setDeviceToken: (NSString *) deviceToken{
    
    [[NSUserDefaults standardUserDefaults] setValue: deviceToken forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *) getDeviceToken {
    //return @"0";
    NSUserDefaults *userDefaults = [Utils getUserDefaults];
    NSString *deviceToken = [userDefaults stringForKey:@"DeviceToken"];
    return deviceToken;
}

+ (void) sendDeviceTokenToServer  {
    
    NSString *deviceToken = [self getDeviceToken];
    
    
    
    BOOL isDeviceTokenSentToServer = NO;
    @try {
        
        NSURL *restUrl = [Utils getNSURL: ADD_DEVICE_TOKEN_API_URL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:restUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
        // Specify that it will be a POST request
        
        NSString *postString = [NSString stringWithFormat:@"=%@", deviceToken];

        NSData *requestData = [postString dataUsingEncoding:NSUTF8StringEncoding];

        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        
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
            NSString* status = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSASCIIStringEncoding];
            

            if (status != nil)
            {
                NSInteger id = [status integerValue];
                
                if (id > 0)
                {
                   isDeviceTokenSentToServer = YES;
                }
            }
            else{
            }
        }
        else
        {
            NSLog(@"Exception: %@",@"Response Data empty");
        }
    
        
    }
    @catch (NSException *exception)
    {
        //<#Handle an exception thrown in the @try block#>
        NSLog(@"Exception: %@", exception);
        
    }
    @finally
    {
        
    }
    
    
    
    // After a successful post to server for device token set to user defaults.
    [self setDeviceTokenSentToServer: isDeviceTokenSentToServer];
    
}

+ (void) checkDeviceTokenStatus  {
    
    // Before loading anything do check if the device token is sent to server for logged in user
    if(![CFSettingsUtils isDeviceTokenSentToServer])
    {
        if([CFSettingsUtils isDeviceTokenEnabled])
        {
            //dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    // Add code here to do background processing

                    [Utils saveHTTPCookies];
                    [Utils loadHTTPCookies];
                    if([Utils isUserLoggedInOnServer])
                    {
                        [CFSettingsUtils sendDeviceTokenToServer];
                    }
                });


        //    });

        }
    }
    
}


@end
