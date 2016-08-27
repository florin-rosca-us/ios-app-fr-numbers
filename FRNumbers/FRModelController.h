//
//  ModelController.h
//  FRNumbers
//
//  The model controller
//
//  Created by Florin Rosca on 1/29/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#ifndef FRModelController_h
#define FRModelController_h

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "FRPageController.h"
#import "FRPage.h"
#import "FRUtils.h"

@class FRPageController;

@interface FRModelController : NSObject <UIPageViewControllerDataSource>
- (FRPageController*)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(FRPageController *)viewController;
@end

#endif