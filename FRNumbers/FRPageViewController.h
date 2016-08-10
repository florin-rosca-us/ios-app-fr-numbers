//
//  NumberViewController.h
//  Numbers
//
//  The view controller for one page. Created on demand by FRModelController.
//
//  Created by Florin Rosca on 1/29/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "FRPage.h"

@interface FRPageViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) FRPage *model;

+ (BOOL) playingSound;
+ (void) setPlayingSound: (BOOL)val;

@end

