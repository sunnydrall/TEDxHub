//
//  CFSettings.h
//  TEDxHub iOS App
//
//  Created by Vivek Thakur on 23/01/15.
//  Copyright (c) 2015 Axero Solutions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFSettings : NSObject
{
    
}

@property (nonatomic, strong) NSString *CFCommunityUrl;
@property (nonatomic, strong) NSString *CFUsernameEmail;
@property (nonatomic, strong) NSString *CFUserPassword;
@property (nonatomic, strong) NSString *CFCommunityName;
@property (nonatomic, strong) NSString *CFApiKey;
@property (nonatomic, strong) NSString *CFLastNotificationID;
@property (nonatomic, strong) NSString *CFLastMessageID;
@property (nonatomic, strong) NSString *DeviceToken;
@property (nonatomic, assign) BOOL IsDeviceTokenSentToServer;

@end
