//
//  LoginVC.m
//  FindMyFriends
//
//  Created by Vincent Renais on 2015-05-12.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//


// Parse frameworks
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

#import "LoginVC.h"
#import "SignUpVC.h"
#import "User.h"


@interface LoginVC () <UITextFieldDelegate>


@end

@implementation LoginVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
       self.loginButton.delegate = self;
    
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)    loginButton:	(FBSDKLoginButton *)loginButton
  didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result
                  error:	(NSError *)error
{
    [PFFacebookUtils logInInBackgroundWithAccessToken:result.token
                                                block:^(PFUser *user, NSError *error)
    {
        if (!user)
        {
            NSLog(@"Uh oh. There was an error logging in.");
        } else
        {
            NSLog(@"User logged in through Facebook!");
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/me?fields=email,name,picture" parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
            {
                 if (!error)
                 {
                     User *currentUser = [[User alloc]init];
                     CLLocation *location = [self.locationManager location];
                     currentUser.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
                     currentUser.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
                     user[@"email"] = result[@"email"];
                     user[@"name"] = result[@"name"];
                     user[@"picture"] = result[@"picture"];
                     user[@"latitude"] = currentUser.latitude;
                     user[@"longitude"] = currentUser.longitude;
                     [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                     
                     {
                         if (succeeded)
                         {
                             // The object has been saved.
                             NSLog(@"Saved to Parse.");
                             [self performSegueWithIdentifier:@"loginSegue" sender:nil];
                         } else
                         {
                             // There was a problem, check error.description
                             NSLog(@"%@", error.description);
                         }
                     }];
                 }
            }];
        }
    }];
}




- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}

- (IBAction)loginButtonPressed:(UIButton *)sender
{
    [self processFieldEntries];
}


- (IBAction)signUpButtonPressed:(UIButton *)sender
{
    SignUpVC *viewController = [[SignUpVC alloc] init];
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}


- (void)processFieldEntries
{
    // Get the username text, store it in the app delegate for now
    NSString *username = self.usernameTF.text;
    NSString *password = self.passwordTF.text;
    NSString *noUsernameText = @"username";
    NSString *noPasswordText = @"password";
    NSString *errorText = @"No ";
    NSString *errorTextJoin = @" or ";
    NSString *errorTextEnding = @" entered";
    BOOL textError = NO;
    
    // Messaging nil will return 0, so these checks implicitly check for nil text.
    if (username.length == 0 || password.length == 0)
    {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
        if (password.length == 0)
        {
            [self.passwordTF becomeFirstResponder];
        }
        if (username.length == 0)
        {
            [self.usernameTF becomeFirstResponder];
        }
    }
    
    if ([username length] == 0)
    {
        textError = YES;
        errorText = [errorText stringByAppendingString:noUsernameText];
    }
    
    if ([password length] == 0)
    {
        textError = YES;
        if ([username length] == 0)
        {
            errorText = [errorText stringByAppendingString:errorTextJoin];
        }
        errorText = [errorText stringByAppendingString:noPasswordText];
    }
    
    if (textError)
    {
        errorText = [errorText stringByAppendingString:errorTextEnding];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
    {
        if (user)
        {
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        } else
        {
            // Didn't get a user.
            NSLog(@"%s didn't get a user!", __PRETTY_FUNCTION__);
            
            NSString *alertTitle = nil;
            
            if (error)
            {
                // Something else went wrong
                alertTitle = [error userInfo][@"error"];
            } else
            {
                // the username or password is probably wrong.
                alertTitle = @"Couldn’t log in:\nThe username or password were wrong.";
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            
            // Bring the keyboard back up, because they'll probably need to change something.
            [self.usernameTF becomeFirstResponder];
        }
    }];
}


@end
