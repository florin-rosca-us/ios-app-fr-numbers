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

@class FRPageController;


@interface FRModelController : NSObject <UIPageViewControllerDataSource>

- (FRPageController*)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;

- (NSUInteger)indexOfViewController:(FRPageController *)viewController;

@end

