//
//  FRPageController.h
//  FRNumbers
//
//  The view controller for one page. Created on demand by FRModelController.
//
//  Created by Florin Rosca on 1/29/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#ifndef FRPageController_h
#define FRPageController_h

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "FRAudioQueue.h"
#import "FRPage.h"

@interface FRPageController : UIViewController <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) FRPage *model;
@end

#endif