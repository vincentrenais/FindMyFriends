//
//  SignUpVC.h
//  FindMyFriends
//
//  Created by Vincent Renais on 2015-05-12.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpVC : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *usernameTF;
@property (nonatomic, strong) IBOutlet UITextField *passwordTF;
@property (nonatomic, strong) IBOutlet UITextField *passwordAgainTF;

@property (nonatomic,weak) id<Sign> delegate;

@end
