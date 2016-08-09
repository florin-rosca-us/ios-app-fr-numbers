//
//  ModelController.m
//  Numbers
//
//  Created by Florin Rosca on 1/29/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#import "FRModelController.h"
#import "FRPageViewController.h"
#import "FRPageModel.h"

/*
 A controller object that manages a simple model.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


@interface FRModelController ()

@property (readonly, strong, nonatomic) NSArray *text;
@property (readonly, strong, nonatomic) NSArray *foregroundColor;
@property (readonly, strong, nonatomic) NSArray *backgroundColor;
@property (readonly, strong, nonatomic) NSMutableDictionary *viewMap;

@end


@implementation FRModelController

- (instancetype)init {
    if(self = [super init]) {
        _viewMap = [[NSMutableDictionary alloc] init];
        // Create the data model.
        _text = [NSArray arrayWithObjects: @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
        _foregroundColor = [NSArray arrayWithObjects:  FRColorForeground01, FRColorForeground02, FRColorForeground03, FRColorForeground04, FRColorForeground05, FRColorForeground06, FRColorForeground07, FRColorForeground08, FRColorForeground09, FRColorForeground10, nil];
        _backgroundColor = [NSArray arrayWithObjects: FRColorBackground01, FRColorBackground02, FRColorBackground03, FRColorBackground04, FRColorBackground05, FRColorBackground06, FRColorBackground07, FRColorBackground08, FRColorBackground09, FRColorBackground10, nil];
    }
    return self;
}

- (FRPageViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    // Return the data view controller for the given index.
    NSLog(@"viewControllerAtIndex: %lu", (unsigned long)index);
    if (([self.text count] == 0) || (index >= [self.text count])) {
        return nil;
    }
    
    NSString *key =[NSString stringWithFormat:@"%lu", (unsigned long)index];
    FRPageViewController *numberViewController = (FRPageViewController *)[_viewMap valueForKey:key];
    if(!numberViewController) {
        // Create a new view controller and pass suitable data.
        NSLog(@"viewControllerAtIndex: create new view controller");
        numberViewController = [storyboard instantiateViewControllerWithIdentifier:@"FRPageViewController"];
        numberViewController.model = [FRPageModel pageWithText:self.text[index] foregroundColor: self.foregroundColor[index] backgroundColor:self.backgroundColor[index]];
        [_viewMap setObject:numberViewController forKey:key];
    }
    return numberViewController;
}

- (NSUInteger)indexOfViewController:(FRPageViewController *)viewController {
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.text indexOfObject:viewController.model.text];
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(FRPageViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(FRPageViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.text count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
