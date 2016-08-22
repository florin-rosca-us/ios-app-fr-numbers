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
}

// Add observers and/or file presenters here
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

// Remove observers and/or file presenters here
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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

@end
