//
//  CFUIWebViewController.m
//  TEDxHub iOS App
//
//  Created by Vivek Thakur on 27/01/15.
//  Copyright (c) 2015 Axero Solutions LLC. All rights reserved.
//

#import "CFUIWebViewController.h"
#import "SSKeychain.h"
#import "LoginViewController.h"
#import "Utils.h"
#import "CFSettingsUtils.h"
#import "UIView+Toast.h"
#import <WebKit/WebKit.h>

@interface CFUIWebViewController ()  <WKNavigationDelegate, WKUIDelegate>



@end

UIActivityIndicatorView *activityIndicator;
WKWebView *webView;


@implementation CFUIWebViewController

- (void)viewWillAppear:(BOOL)animated {
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //Put the indicator on the center of the webview
    [activityIndicator setCenter:self.view.center];
    [self.view addSubview:activityIndicator];
    [self.view addSubview:self.navigateToolBar];
    [activityIndicator startAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePushNotification:)
                                                 name:@"PushNotification"
                                               object:nil];
    
    
    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    webView.navigationDelegate = self;
    [webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    
    
    if(![Utils isNetworkAvailable])
    {
        [self.view makeToast:[Utils getLoginStatusMessage:InternetConnectionMissing] duration:5.0
                    position:@"bottom"];
        return;
    }
    
    [self loadCFCommunityWebsite];
}

// Load CF Web view
-(void) loadCFCommunityWebsite
{
    // Show webView control
    [webView setHidden:FALSE];
    
  
    if(self.urlToOpen!=nil) {
        // When the app is opened via notification.
        // We need to show the page for which the notification is
        [webView loadRequest: [Utils getNSURLRequest:self.urlToOpen]];
    }
    else{
        // Load default page
        [webView loadRequest:[Utils getLoginURLRequestForWebView]];
    }
    [self.view addSubview:webView];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
    
    [Utils showActivityIndicator: activityIndicator];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"didFinishNavigation");
    
    [Utils hideActivityIndicator: activityIndicator];
    [activityIndicator stopAnimating];
    [self updateButtons];
    
    // Check if the device token is sent to server for logged in user
    [CFSettingsUtils checkDeviceTokenStatus];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"observeValueForKeyPath");
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"LOADING - URL: %@", webView.URL.absoluteString );
        
        if([Utils isLogoutUrl:webView.URL.absoluteString])
        {
            [Utils showActivityIndicator: activityIndicator];
            [Utils logout:self];
        }
        
        [Utils showActivityIndicator: activityIndicator];
    }
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //this is a 'new window action' (aka target="_blank") > open this URL externally. If we´re doing nothing here, WKWebView will also just do nothing. Maybe this will change in a later stage of the iOS 8 Beta
    if (!navigationAction.targetFrame) {
        NSURL *url = navigationAction.request.URL;
        UIApplication *app = [UIApplication sharedApplication];
        if ([app canOpenURL:url]) {
            [app openURL:url];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [Utils hideActivityIndicator: activityIndicator];
    [activityIndicator stopAnimating];
    [self updateButtons];
}
- (void) receivePushNotification:(NSNotification *) notif {
    
//    if (![CFSettingsUtils isUserLoggedIn])
//    {
//        //[Utils loadLoginViewController:self];
//        return;
//    }
    
    NSDictionary *userInfo=notif.userInfo;
    
    NSString *url=[userInfo valueForKey:@"url"];
    NSString *str = [NSString stringWithFormat: @"%@%@", [Utils getCommuntityURL],url];
    NSURL *siteURL = [NSURL URLWithString:str];
    
    
    // Show webView control
    [webView setHidden:false];
    [activityIndicator setHidesWhenStopped:YES];
    [Utils showActivityIndicator: activityIndicator];
    [webView loadRequest:[Utils getNSURLRequest:siteURL]];
    //[self.cfUIWebView reload];
}


- (void)viewDidLayoutSubviews {
    [Utils setWebViewDimensions:webView : self.view: self.navigateToolBar];
    [activityIndicator setCenter:self.view.center];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateButtons
{
    self.forwardButton.enabled = webView.canGoForward;
    self.backButton.enabled = webView.canGoBack;
    self.stopButton.enabled = webView.loading;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (IBAction)goBack:(id)sender {
    [webView goBack];
}
- (IBAction)stopLoading:(id)sender {
    [webView stopLoading];
}
- (IBAction)reload:(id)sender {
    [webView reload];
}

- (IBAction)goForward:(id)sender {
    [webView goForward];
}


@end
