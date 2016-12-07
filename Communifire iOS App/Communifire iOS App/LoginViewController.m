//
//  ViewController.m
//  TEDxHub iOS App
//
//  Created by Vivek Thakur on 18/01/15.
//  Copyright (c) 2015 Axero Solutions LLC. All rights reserved.
//

#import "LoginViewController.h"
#import "SSKeychain.h"
#import "SSKeychainQuery.h"
#import "UIView+Toast.h"
#import "CFSettings.h"
#import "CFUIWebViewController.h"
#import "Utils.h"

@interface LoginViewController ()

@end

@implementation LoginViewController



- (void)viewDidAppear:(BOOL)animated {

    [self.loginViewParent setHidden:TRUE];
    [Utils loadWebViewController:self];
    
//    if (![Utils isUserLoggedIn])
//    {
//        [self.loginViewParent setHidden:FALSE];
//        // Show login screen view control
//        self.passwordText.secureTextEntry= YES;
//        // Fetch previously saved items
//        [self.communityUrlText setHidden:TRUE];
//        self.communityUrlText.text= @"http://tedxhub.ted.com";
//        self.usernameEmailText.text= [Utils getUsername];
//    }
//    else
//    {
//        if(self.urlToOpen!=nil)
//        {
//            [self.loginViewParent setHidden:TRUE];
//            CFUIWebViewController *vc1 = [Utils getWebViewController];
//            vc1.urlToOpen=self.urlToOpen;
//            [self presentViewController:vc1 animated:NO completion:nil];
//        }
//        {
//            [self.loginViewParent setHidden:TRUE];
//            [Utils loadWebViewController:self];
//        }
//    }
    
    
}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self.loginViewParent setHidden:TRUE];
//    
//    self.communityUrlText.delegate = self;
//    self.usernameEmailText.delegate = self;
//    self.passwordText.delegate = self;
//    
//    [self.activityIndicator setHidesWhenStopped:YES];
//    
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
//    if (theTextField == self.passwordText) {
//        [theTextField resignFirstResponder];
//    }
//    else if (theTextField == self.usernameEmailText) {
//        [self.passwordText becomeFirstResponder];
//    }
//    else if (theTextField == self.communityUrlText) {
//        [self.usernameEmailText becomeFirstResponder];
//    }
//    return YES;
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    //hides keyboard when another part of layout was touched
//    [self.view endEditing:YES];
//    [super touchesBegan:touches withEvent:event];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//- (IBAction)test:(id)sender {
//}
//
//// MAIN LOGIN BUTTON PRESS
- (IBAction)loginButtonPressed:(id)sender {
//    [Utils showActivityIndicator: self.activityIndicator];
//    LoginStatus ls=[Utils getLoginStatus:self.communityUrlText.text :self.usernameEmailText.text :self.passwordText.text];
//    if(ls!=Success){
//        [Utils hideActivityIndicator: self.activityIndicator];
//        [self.view makeToast:[Utils getLoginStatusMessage:ls]];
//        return;
//    }
//    
//    CFSettings *cfSettings = [[CFSettings alloc] init];
//    cfSettings.CFCommunityUrl = [Utils makeUrlFromDomain:self.communityUrlText.text];
//    cfSettings.CFUsernameEmail = self.usernameEmailText.text;
//    cfSettings.CFUserPassword = self.passwordText.text;
//    
//    NSURL *restUrl = [Utils getRestAPIKeyURL: cfSettings];
//    
//    @try {
//        
//        NSURLRequest *request = [NSMutableURLRequest requestWithURL:restUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
//        //NSHTTPURLResponse *response = nil;
//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responseCode, NSData *responseData, NSError *connectionError) {
//            
//            // Do stuff..
//            int statusCodeResponse ;
//            //NSHTTPURLResponse *aResponse = (NSHTTPURLResponse *)response;
//            //int statusCodeResponse = aResponse.statusCode;
//            
//            NSString *strError = [NSString stringWithFormat:@"%@", [connectionError description]];
//            if ([strError rangeOfString:@"Code=-1012"].location != NSNotFound) {
//                statusCodeResponse = 401;
//            }
//            if (connectionError.code == kCFURLErrorUserCancelledAuthentication) {
//                statusCodeResponse = 401;
//                [Utils hideActivityIndicator: self.activityIndicator];
//                [self.loginViewParent setHidden:FALSE];
//                [self.view makeToast:[Utils getLoginStatusMessage:InvalidCrentials]];
//                
//                return;
//                
//            }
//            
//            if (responseData != nil)
//            {
//                NSDictionary *returnValue = [NSJSONSerialization JSONObjectWithData:responseData
//                                                                            options:0
//                                                                              error:NULL];
//                NSString *apiKey= [returnValue objectForKey:@"ResponseData"];
//                if (apiKey != nil)
//                {
//                    cfSettings.CFApiKey = apiKey;
//                    
//                    // Save API-KEY in keychain
//                    [Utils setCFSettings:cfSettings];
//                    [Utils addDeviceToken];
//                    [Utils setCommunityName:cfSettings];
//                    [Utils loadWebViewController:self];
//                    // Load the new web view segue
//                    //[self shouldPerformSegueWithIdentifier:@"LoginToWebView" sender:self];
//                    // }
//                }
//                else{
//                    [Utils hideActivityIndicator: self.activityIndicator];
//                    [self.view makeToast:[Utils getLoginStatusMessage:Error]];
//                    return;
//                }
//            }
//            else
//            {
//                [Utils hideActivityIndicator: self.activityIndicator];
//                [self.view makeToast:[Utils getLoginStatusMessage:Error]];
//                return;
//            }
//            
//        }];
//        
//        
//        
//    }
//    @catch (NSException *exception)
//    {
//        [Utils hideActivityIndicator: self.activityIndicator];
//        //<#Handle an exception thrown in the @try block#>
//        NSLog(@"Exception: %@",exception);
//        [self.view makeToast:[Utils getLoginStatusMessage:Error]];
//        
//    }
//    @finally
//    {
//        
//    }
//}
//
//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
//{
//    if([identifier isEqualToString:@"LoginToWebView"])
//    {
//        return YES;
//    }
//    else{
//        return NO;
//    }
}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    
//}
//
//
//-(void)timerFired:(NSTimer *) theTimer
//{
//}



@end

