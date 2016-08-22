//
//  AppDelegate.m
//  Numbers
//
//  Created by Florin Rosca on 1/29/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#import "FRAppDelegate.h"

// The application group
NSString *const FRAppGroup = @"group.florin-rosca-us.FRNumbers";


@interface FRAppDelegate ()
@end

@implementation FRAppDelegate


#pragma mark - UIApplicationDelegate methods

// Tells the delegate that the launch process has begun but that state restoration has not yet occurred.
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

// Tells the delegate that the launch process is almost done and the app is almost ready to run.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"application:didFinishLaunchingWithOptions: - begin");

    // Override point for customization after application launch.
    if(!launchOptions) {
        NSLog(@"application:didFinishLaunchingWithOptions: - no launch options");
    }
    else {
        NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
        if(url) {
            NSLog(@"application:didFinishLaunchingWithOptions: - open %@", url);
        }
        else {
            NSLog(@"application:didFinishLaunchingWithOptions: - nothing to open");
        }
    }
    NSLog(@"application:didFinishLaunchingWithOptions: - end");
    return YES;
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    NSLog(@"openURL %@", url);
    return YES;
}


#pragma mark - Other methods


@end
