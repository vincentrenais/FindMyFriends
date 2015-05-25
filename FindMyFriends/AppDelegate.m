//
//  AppDelegate.m
//  FindMyFriends
//
//  Created by Vincent Renais on 2015-05-12.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import "AppDelegate.h"


// Facebook
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

// Parse
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "Parse/Parse.h"

#import "MapVC.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [FBSDKLoginButton class];
    
    // Initialize Parse.
    [Parse setApplicationId:@"FpS2z6gamN67rwIjMaBsrfjuYOgHvtYhlL2HfuhB"
                  clientKey:@"glXMjT4QNEr4W360NQt38cA8uxKiIOaFggqOrKQK"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    

    if ([PFUser currentUser])
    {
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        MapVC *mapVC = (MapVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Map"];
        
        UINavigationController *mapNC = [[UINavigationController alloc]initWithRootViewController:mapVC];
        
        //set the root controller to it
        self.window.rootViewController = mapNC;
    }


    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
