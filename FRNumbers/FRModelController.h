//
//  ModelController.h
//  Numbers
//
//  The model controller
//
//  Created by Florin Rosca on 1/29/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class FRPageViewController;


@interface FRModelController : NSObject <UIPageViewControllerDataSource>

- (FRPageViewController*)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;

- (NSUInteger)indexOfViewController:(FRPageViewController *)viewController;

@end

