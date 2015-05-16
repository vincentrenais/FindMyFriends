//
//  MapVC.h
//  FindMyFriends
//
//  Created by Vincent Renais on 2015-05-13.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "User.h"


@interface MapVC : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationManager;

@end