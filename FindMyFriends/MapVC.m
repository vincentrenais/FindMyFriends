//
//  MapVC.m
//  FindMyFriends
//
//  Created by Vincent Renais on 2015-05-13.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import "MapVC.h"
#import "MapAnnotation.h"
#import "LoginVC.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MapVC ()

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
                NSNumber *latitude = user [@"latitude"];
                NSNumber *longitude = user [@"longitude"];
                CLLocationCoordinate2D userCoordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
                MapAnnotation *myAnnotation = [[MapAnnotation alloc]init];
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

            pinView.canShowCallout = YES;

        }
        pinView.annotation = annotation;
        
        if ([annotation isKindOfClass:[MapAnnotation class]])
        {
                MapAnnotation *myAnnotation = (MapAnnotation *)annotation;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:myAnnotation.url]];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        UIImage *image = [UIImage imageWithData:data];
                        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
                        imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2.0f;
                        imageView.layer.masksToBounds = true;
                        [pinView addSubview:imageView];
                    });
                });
        }

        return pinView;
    }
    return nil;
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    // A dispatch_once token is used so the location is only updated once.
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.02f, 0.02f)) animated:YES];
    });
}


- (IBAction)logoutButton:(UIBarButtonItem *)sender {
    
//    dispatch_sync(dispatch_get_main_queue(), ^{
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
//        });
}

    
@end
