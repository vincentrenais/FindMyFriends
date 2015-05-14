//
//  LoginVC.h
//  FindMyFriends
//
//  Created by Vincent Renais on 2015-05-12.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginVC : UIViewController <UITextFieldDelegate,FBSDKLoginButtonDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;


- (void)
loginButton:	(FBSDKLoginButton *)loginButton
didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result
error:	(NSError *)error;

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton;

@end
