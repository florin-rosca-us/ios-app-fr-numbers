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
    return YES;
}

// Sent when the application is about to move from active to inactive state.
// This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
- (void)applicationWillResignActive:(UIApplication *)application {
}

// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
- (void)applicationDidEnterBackground:(UIApplication *)application {
}

// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
// Check preferences, restore default audio files if requested
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground: - begin");
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL reset = [defaults boolForKey:FRPrefAudioReset];
    NSLog(@"applicationDidBecomeActive: reset=%@", reset?@"YES":@"NO");
    [self copyAudioFromResourcesReplacing:reset];
    if(!reset) {
        [self moveAudioFromAppGroup];
    }
    [defaults setBool:NO forKey:FRPrefAudioReset];
    NSLog(@"applicationWillEnterForeground: - end");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive: - begin");
    // Note: FRPageController adds self as observer for ApplicationDidBecomeActive notifications in order to play audio.
    // Should restore audio files before that.
    NSLog(@"applicationDidBecomeActive: - end");
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
- (void) copyAudioFromResourcesReplacing:(BOOL)replace {
    NSLog(@"copyAudioFromResourcesReplace: - begin");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dirDocuments = [paths objectAtIndex:0];
    NSString *ext = FRAudioFileExtension;
    
    for(NSString *name in FRAudioFileNames) {
        NSString *path = [dirDocuments stringByAppendingPathComponent:[name stringByAppendingPathExtension:ext]];
        NSLog(@"copyAudioFromResourcesReplace: - %@", [name stringByAppendingPathExtension:ext]);
        if ([fileManager fileExistsAtPath:path]) {
            if(!replace) {
                NSLog(@"copyAudioFromResourcesReplace: - already exists");
                continue;
            }
            if(![fileManager removeItemAtPath:path error:&error]) {
                NSLog(@"copyAudioFromResourcesReplace: - removeItemAtPath - %@", error.localizedDescription);
            }
        }
        NSString *res = [[NSBundle mainBundle] pathForResource:name ofType:ext];
        if(![fileManager copyItemAtPath:res toPath:path error:&error]) {
            NSLog(@"copyAudioFromResourcesReplace: - copyItemAtPath - %@", error.localizedDescription);
        }
    }
    NSLog(@"copyAudioFromResourcesReplace: - end");
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
        if(![name.pathExtension isEqualToString:FRAudioFileExtension]) {
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
