//
//  VRMapAnnotation.h
//  FindMyFriends
//
//  Created by Vincent Renais on 2015-05-19.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface VRMapAnnotation : MKPointAnnotation

@property (nonatomic, copy) NSString *url;

@end
