//
//  RootViewController.m
//  Numbers
//
//  Created by Florin Rosca on 1/29/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#import "FRRootViewController.h"
#import "FRAppConstants.h"
#import "FRModelController.h"
#import "FRPageController.h"

@interface FRRootViewController ()
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (readonly, strong, nonatomic) FRModelController *modelController;
@end


@implementation FRRootViewController

@synthesize modelController = _modelController;


#pragma mark - UIViewController methods

// Do any additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;

    FRPageController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    [self.pageViewController setViewControllers:@[startingViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController.dataSource = self.modelController;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    // Load default audio files if missing
    [self copyAudioFromResources];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Add observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOnEnterForeground) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Dispose of any resources that can be recreated.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Return the model controller object, creating it if necessary. In more complex implementations, the model controller may be passed to the view controller.
- (FRModelController *)modelController {
    if (!_modelController) {
        _modelController = [[FRModelController alloc] init];
    }
    return _modelController;
}


#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return UIPageViewControllerSpineLocationMin;
}


#pragma mark - Other methods

// Refresh when the app enters foreground
- (void) refreshOnEnterForeground {
    [self copyAudioFromResources];
    [self copyAudioFromAppGroup];
}

// Copy resources to Documents
// From http://stackoverflow.com/questions/6545180/ios-copy-a-file-in-documents-folder
- (void) copyAudioFromResources {
    NSLog(@"copyAudioFromResources - begin");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dirDocuments = [paths objectAtIndex:0];
    NSString *ext = FRAppConstants.audioFileExt;
    
    for(NSString *name in FRAppConstants.audioFileNames) {
        NSString *path = [dirDocuments stringByAppendingPathComponent:[name stringByAppendingString:ext]];
        NSLog(@"copyAudioFromResources - copying %@...", [name stringByAppendingString:ext]);
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

// Copies audio from the app group's tmp directory to the app's Documents directory
// Make sure this is not called in a 
- (void) copyAudioFromAppGroup {
    NSLog(@"copyAudioFromAppGroup - begin");
    NSExtensionContext *context = self.extensionContext;
    NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier: FRAppGroup];
    NSString *groupPath = groupURL.path;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *fileError = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    
    NSLog(@"copyAudioFromAppGroup - groupURL=%@", groupPath);
    NSLog(@"copyAudioFromAppGroup - dirDocuments=%@", docPath);

    NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
    NSError *coordinatorError = nil;

    for(NSString* name in [fileManager contentsOfDirectoryAtPath:groupURL.path error:&fileError]) {
        
        NSLog(@"copyAudioFromAppGroup - pathExtension:%@", [name pathExtension]);
        
        NSLog(@"copyAudioFromAppGroup - contentsOfDirectory: %@", name);
        NSURL *inputURL = [NSURL URLWithString:[groupURL.path stringByAppendingPathComponent:name]];
        NSURL *outputURL = [NSURL URLWithString:[docPath stringByAppendingPathComponent:[inputURL.path lastPathComponent]]];
        
        NSLog(@"copyAudioFromAppGroup - inputURL=%@", inputURL);
        NSLog(@"copyAudioFromAppGroup - outputURL=%@", outputURL);

        
        BOOL isDir = NO;
        /*
        if([fileManager fileExistsAtPath:inputURL.path isDirectory:&isDir] && !isDir) {
            NSLog(@"copyAudioFromAppGroup - inputURL=%@", inputURL);
            NSLog(@"copyAudioFromAppGroup - outputURL=%@", outputURL);
         
            // [fileCoordinator coordinateWritingItemAtURL:inputURL options:NSFileCoordinatorWritingForReplacing error:&coordinatorError byAccessor:^(NSURL *newURL) {
            // }];
         

        }
        */
    }
    NSLog(@"copyAudioFromAppGroup - end");
}

@end
