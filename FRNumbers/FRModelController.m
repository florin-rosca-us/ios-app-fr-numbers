//
//  ModelController.m
//  Numbers
//
//  Created by Florin Rosca on 1/29/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#import "FRModelController.h"
#import "FRPageController.h"
#import "FRPage.h"
#import "FRUtils.h"

@interface FRModelController () {
    FRList* _pageList;
    NSMutableDictionary* _viewMap;
}
@end

@implementation FRModelController

- (instancetype)init {
    if(self = [super init]) {
        _viewMap = [[NSMutableDictionary alloc] init];
        _pageList = [FRArrayList listWithCapacity:10];
        [_pageList add:[FRPage pageWithText:@"1" foregroundColor:FRColorForeground01 backgroundColor:FRColorBackground01 sound:@"01"]];
        [_pageList add:[FRPage pageWithText:@"2" foregroundColor:FRColorForeground02 backgroundColor:FRColorBackground02 sound:@"02"]];
        [_pageList add:[FRPage pageWithText:@"3" foregroundColor:FRColorForeground03 backgroundColor:FRColorBackground03 sound:@"03"]];
        [_pageList add:[FRPage pageWithText:@"4" foregroundColor:FRColorForeground04 backgroundColor:FRColorBackground04 sound:@"04"]];
        [_pageList add:[FRPage pageWithText:@"5" foregroundColor:FRColorForeground05 backgroundColor:FRColorBackground05 sound:@"05"]];
        [_pageList add:[FRPage pageWithText:@"6" foregroundColor:FRColorForeground06 backgroundColor:FRColorBackground06 sound:@"06"]];
        [_pageList add:[FRPage pageWithText:@"7" foregroundColor:FRColorForeground07 backgroundColor:FRColorBackground07 sound:@"07"]];
        [_pageList add:[FRPage pageWithText:@"8" foregroundColor:FRColorForeground08 backgroundColor:FRColorBackground08 sound:@"08"]];
        [_pageList add:[FRPage pageWithText:@"9" foregroundColor:FRColorForeground09 backgroundColor:FRColorBackground09 sound:@"09"]];
        [_pageList add:[FRPage pageWithText:@"10" foregroundColor:FRColorForeground10 backgroundColor:FRColorBackground10 sound:@"10"]];
    }
    return self;
}


#pragma mark - FRModelController methods

- (FRPageController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    // Return the data view controller for the given index.
    NSLog(@"viewControllerAtIndex: %lu", (unsigned long)index);
    if (!_pageList || [_pageList size] == 0 || (index >= [_pageList size])) {
        return nil;
    }
    
    NSNumber *key =[NSNumber numberWithInteger: index];
    FRPageController *numberViewController = (FRPageController *)[_viewMap objectForKey:key];
    if(!numberViewController) {
        // Create a new view controller
        NSLog(@"viewControllerAtIndex: create new view controller");
        numberViewController = [storyboard instantiateViewControllerWithIdentifier:@"FRPageViewController"];
        numberViewController.model = [_pageList get:index];
        [_viewMap setObject:numberViewController forKey:key];
    }
    return numberViewController;
}

- (NSUInteger)indexOfViewController:(FRPageController *)viewController {
    return [_pageList indexOf:viewController.model];
}


#pragma mark - UIPageViewControllerDataSource methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(FRPageController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(FRPageController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [_pageList size]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
