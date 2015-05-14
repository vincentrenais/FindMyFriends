//
//  LoginVC.m
//  FindMyFriends
//
//  Created by Vincent Renais on 2015-05-12.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "LoginVC.h"
#import "SignUpVC.h"
#import "FBSDKLoginButton.h"


@interface LoginVC () <UITextFieldDelegate>


@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([FBSDKAccessToken currentAccessToken]) {
        
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    }
    
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    self.loginButton.delegate = self;
    
    [self _loadData];
    
}

- (void)_loginWithFacebook {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"public_profile", @"email", @"user_friends" ];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
        }
    }];
}


- (void)_loadData {
    // ...
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *location = userData[@"location"][@"name"];
            NSString *gender = userData[@"gender"];
            NSString *birthday = userData[@"birthday"];
            NSString *relationship = userData[@"relationship_status"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            // Now add the data to the UI elements
            // ...
        }
    }];
}

- (void)          loginButton:	(FBSDKLoginButton *)loginButton
        didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result
                        error:	(NSError *)error
{
    NSLog(@"User Logged In");
    
    if ((error) != nil)
    {
        NSLog(@"Error received"); // Process error
    }
    else {
        // If you ask for multiple permissions at once, you
        // should check if specific permissions missing
        NSLog(@"%@",self.loginButton.readPermissions);
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    }
    
    
}



- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
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


- (void)processFieldEntries {
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
    if (username.length == 0 || password.length == 0) {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
        if (password.length == 0) {
            [self.passwordTF becomeFirstResponder];
        }
        if (username.length == 0) {
            [self.usernameTF becomeFirstResponder];
        }
    }
    
    if ([username length] == 0) {
        textError = YES;
        errorText = [errorText stringByAppendingString:noUsernameText];
    }
    
    if ([password length] == 0) {
        textError = YES;
        if ([username length] == 0) {
            errorText = [errorText stringByAppendingString:errorTextJoin];
        }
        errorText = [errorText stringByAppendingString:noPasswordText];
    }
    
    if (textError) {
        errorText = [errorText stringByAppendingString:errorTextEnding];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    // Everything looks good; try to log in.
    
    // Set up activity view
//    self.activityViewVisible = YES;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        // Tear down the activity view in all cases.
//        self.activityViewVisible = NO;
        
        if (user) {
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        } else {
            // Didn't get a user.
            NSLog(@"%s didn't get a user!", __PRETTY_FUNCTION__);
            
            NSString *alertTitle = nil;
            
            if (error) {
                // Something else went wrong
                alertTitle = [error userInfo][@"error"];
            } else {
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
