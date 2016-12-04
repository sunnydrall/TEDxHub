//
//  CFNotification.h
//  TEDxHub iOS App
//
//  Created by Raghav Khunger on 17/02/15.
//  Copyright (c) 2015 Axero Solutions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFNotification : NSObject
{
    
}

@property (nonatomic, strong) NSString *ActionText;
@property (nonatomic, strong) NSString *DateCreated;
@property (nonatomic, strong) NSString *AvatarImageURL;
@property (nonatomic, strong) NSString *FromUser;
@property (nonatomic, strong) NSString *Subject;
@property (nonatomic, strong) NSString *UserAvatarImage;
@property (nonatomic, strong) NSString *NotificationID;

@end
