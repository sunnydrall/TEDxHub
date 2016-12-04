//
//  ViewController.h
//  TEDxHub iOS App
//
//  Created by Vivek Thakur on 18/01/15.
//  Copyright (c) 2015 Axero Solutions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFSettings.h"


typedef enum LoginStatusTypes
{
    InvalidCrentials,
    InvalidUrl,
    Success,
    Error,
    InternetConnectionMissing,
    UsernameMissing,
    PasswordMissing,
    TimedOutError
} LoginStatus;

 //typedef enum LS LoginStatus;

@interface LoginViewController : UIViewController <UITextFieldDelegate>


- (IBAction)loginButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *cfLoginViewControl;
@property (weak, nonatomic) IBOutlet UIImageView *mainCFLogo;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UITextField *communityUrlText;
@property (weak, nonatomic) IBOutlet UITextField *usernameEmailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIView *loginViewParent;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic) NSURL *urlToOpen;


// Background work

@property (nonatomic)  NSTimer *restCallTimer;


@end

