//
//  AppDelegate.m
//  Numbers
//
//  Created by Florin Rosca on 1/29/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#import "FRAppDelegate.h"

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

    [self copyAudioFromResources];
    [self moveAudioFromAppGroup];
    
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
    [self moveAudioFromAppGroup];
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


#pragma mark - FRAppDelegate methods

// Copy resources to Documents
// From http://stackoverflow.com/questions/6545180/ios-copy-a-file-in-documents-folder
- (void) copyAudioFromResources {
    NSLog(@"copyAudioFromResources - begin");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dirDocuments = [paths objectAtIndex:0];
    NSString *ext = FRAppConstants.audioFileExtension;
    
    for(NSString *name in FRAppConstants.audioFileNames) {
        NSString *path = [dirDocuments stringByAppendingPathComponent:[name stringByAppendingPathExtension:ext]];
        NSLog(@"copyAudioFromResources - copying %@...", [name stringByAppendingPathExtension:ext]);
        if ([fileManager fileExistsAtPath:path]) {
            NSLog(@"copyAudioFromResources - already exists");
        }
        else {
            NSString *res = [[NSBundle mainBundle] pathForResource:name ofType:ext];
            [fileManager copyItemAtPath:res toPath:path error:&error];
            if(!error) {
                NSLog(@"copyAudioFromResources - done");
            }
            else {
                NSLog(@"copyAudioFromResources - an error occurred while copying %@: %@", name, [error localizedDescription]);
            }
        }
    }
    NSLog(@"copyAudioFromResources - end");
}

// Moves audio from the app group's tmp directory to the app's Documents directory
// Make sure this is not called in a NSFilePresenter notification since this changes the content of the URL being presented
- (void) moveAudioFromAppGroup {
    NSLog(@"moveAudioFromAppGroup - begin");
    NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier: FRAppGroup];
    NSString *groupPath = groupURL.path;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    
    NSLog(@"moveAudioFromAppGroup - groupURL=%@", groupPath);
    NSLog(@"moveAudioFromAppGroup - dirDocuments=%@", docPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *fileError = nil;
    NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
    NSError *coordinatorError = nil;
    
    for(NSString* name in [fileManager contentsOfDirectoryAtPath:groupURL.path error:&fileError]) {
        if(fileError) {
            NSLog(@"moveAudioFromAppGroup - contentOfDirectoryAtPath: - an error occurred: %@", fileError);
            break;
        }
        NSLog(@"moveAudioFromAppGroup - contentsOfDirectory: %@", name);
        // We are looking for *.m4a files only
        if(![name.pathExtension isEqualToString:FRAppConstants.audioFileExtension]) {
            continue;
        }
        
        NSURL *inputURL = [NSURL fileURLWithPath:[groupURL.path stringByAppendingPathComponent:name]];
        NSURL *outputURL = [NSURL fileURLWithPath:[docPath stringByAppendingPathComponent:[inputURL.path lastPathComponent]]];
        
        BOOL isDir = NO;
        if([fileManager fileExistsAtPath:inputURL.path isDirectory:&isDir] && !isDir) {
            NSLog(@"moveAudioFromAppGroup - inputURL=%@", inputURL);
            NSLog(@"moveAudioFromAppGroup - outputURL=%@", outputURL);
            [fileCoordinator coordinateWritingItemAtURL:inputURL options:NSFileCoordinatorWritingForMoving error:&coordinatorError byAccessor:^(NSURL *newURL) {
                NSError *fileError = nil;
                if([fileManager fileExistsAtPath:outputURL.path]) {
                    [fileManager removeItemAtPath:outputURL.path error:&fileError];
                }
                if(!fileError) {
                    [fileManager moveItemAtURL:inputURL toURL:outputURL error:&fileError];
                }
                if(fileError) {
                    NSLog(@"moveAudioFromAppGroup - moveItemAtURL: - an error occurred: %@", fileError.description);
                }
            }];
            if(coordinatorError) {
                NSLog(@"moveAudioFromAppGroup - coordinateWritingItemAtURL: - an error occurred: %@", coordinatorError.description);
            }
        }
    }
    NSLog(@"moveAudioFromAppGroup - end");
}

@end
