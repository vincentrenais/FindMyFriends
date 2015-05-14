//
//  User.h
//  FindMyFriends
//
//  Created by Vincent Renais on 2015-05-12.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *userPassword;
@property (strong,nonatomic) NSNumber *latitude;
@property (strong,nonatomic) NSNumber *longitude;
@end
