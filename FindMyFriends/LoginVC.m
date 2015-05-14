//
//  LoginVC.m
//  FindMyFriends
//
//  Created by Vincent Renais on 2015-05-12.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import <Parse/Parse.h>

#import "LoginVC.h"
#import "SignUpVC.h"

@interface LoginVC () <UITextFieldDelegate>



@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (IBAction)loginButtonPressed:(UIButton *)sender
{
    [self processFieldEntries];
}


- (IBAction)signUpButtonPressed:(UIButton *)sender
{
    LoginVC *loginVC = [[LoginVC alloc]init];
    [self.navigationController presentViewController:loginVC animated:YES completion:nil];
}


- (void)presentSignupVC {
    SignUpVC *viewController = [[SignUpVC alloc] init];
    viewController.delegate = self;
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

- (void)signupVCDidSignup:(SignUpVC *)controller {
    [self performSegueWithIdentifier:@"loginSegue" sender:nil];
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
//            [self.delegate LoginVCDidLogin:self];
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
