//
//  LoginVC.h
//  FindMyFriends
//
//  Created by Vincent Renais on 2015-05-12.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

//Facebook frameworks
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "User.h"

@interface LoginVC : UIViewController <UITextFieldDelegate,FBSDKLoginButtonDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
