//
//  CFUIWebViewController.h
//  TEDxHub iOS App
//
//  Created by Vivek Thakur on 27/01/15.
//  Copyright (c) 2015 Axero Solutions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface CFUIWebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *parentView;
@property(nonatomic) NSURL *urlToOpen;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIToolbar *navigateToolBar;


@end
