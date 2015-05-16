//
//  SignUpVC.m
//  FindMyFriends
//
//  Created by Vincent Renais on 2015-05-12.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

// Parse
#import <Parse/Parse.h>

#import "SignUpVC.h"


@interface SignUpVC () <UITextFieldDelegate>


@end


@implementation SignUpVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)signUpPressed:(UIButton *)sender
{
    [self processFieldEntries];
}


- (IBAction)closeVC:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)processFieldEntries
{
    NSString *username = self.usernameTF.text;
    NSString *password = self.passwordTF.text;
    NSString *passwordAgain = self.passwordAgainTF.text;
    NSString *errorText = @"Please ";
    NSString *usernameBlankText = @"enter a username";
    NSString *passwordBlankText = @"enter a password";
    NSString *joinText = @", and ";
    NSString *passwordMismatchText = @"enter the same password twice";
    BOOL textError = NO;
    
    // Messaging nil will return 0, so these checks implicitly check for nil text.
    if (username.length == 0 || password.length == 0 || passwordAgain.length == 0)
    {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
        if (passwordAgain.length == 0)
        {
            [self.passwordAgainTF becomeFirstResponder];
        }
        if (password.length == 0)
        {
            [self.passwordTF becomeFirstResponder];
        }
        if (username.length == 0)
        {
            [self.usernameTF becomeFirstResponder];
        }
        
        if (username.length == 0)
        {
            errorText = [errorText stringByAppendingString:usernameBlankText];
        }
        
        if (password.length == 0 || passwordAgain.length == 0)
        {
            if (username.length == 0)
            { // We need some joining text in the error:
                errorText = [errorText stringByAppendingString:joinText];
            }
            errorText = [errorText stringByAppendingString:passwordBlankText];
        }
    } else if ([password compare:passwordAgain] != NSOrderedSame)
    {
        // We have non-zero strings.
        // Check for equal password strings.
        textError = YES;
        errorText = [errorText stringByAppendingString:passwordMismatchText];
        [self.passwordTF becomeFirstResponder];
    }
    
    if (textError)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    

    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            // Bring the keyboard back up, because they'll probably need to change something.
            [self.usernameTF becomeFirstResponder];
            return;
        }
        
        // Success!
        [self performSegueWithIdentifier:@"signUpSegue" sender:nil];       
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
