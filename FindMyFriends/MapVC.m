//
//  MapVC.m
//  FindMyFriends
//
//  Created by Vincent Renais on 2015-05-13.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import "MapVC.h"
#import "VRMapAnnotation.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MapVC ()

@property (strong,nonatomic) NSData *userPhoto;

@end

@implementation MapVC

- (void)viewDidLoad
{
    [super viewDidLoad];
     //Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    
    // Gets the user's location
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Check if the user is using iOS 8, if so ask authorization to use his location.
    if(IS_OS_8_OR_LATER)
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            for (NSDictionary *user in objects){
                NSDictionary *picture = user[@"picture"];
                NSDictionary *data = picture[@"data"];
                NSString *url = data [@"url"];
//                NSURL *userPicture = [NSURL URLWithString:url];
//                self.userPhoto = [[NSData alloc] initWithContentsOfURL:userPicture];
                NSNumber *latitude = user [@"latitude"];
                NSNumber *longitude = user [@"longitude"];
                CLLocationCoordinate2D userCoordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
                VRMapAnnotation *myAnnotation = [[VRMapAnnotation alloc]init];
                myAnnotation.coordinate = userCoordinate;
                myAnnotation.title = user [@"name"];
                myAnnotation.url = url;
                [self.mapView addAnnotation:myAnnotation];
            }
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, don't show an annotation.
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // The following creates a pin view if an existing pin view was not available.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            //pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            
        }
        pinView.annotation = annotation;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([annotation isKindOfClass:[VRMapAnnotation class]])
            {
                VRMapAnnotation *myAnnotation = (VRMapAnnotation *)annotation;
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:myAnnotation.url]];
                UIImage *image = [UIImage imageWithData:data];
                pinView.image = image;
            }
        });
        return pinView;
    }
    return nil;
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    // A dispatch_once token is used so the location is only updated once.

        [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01f, 0.01f)) animated:YES];
}

@end
