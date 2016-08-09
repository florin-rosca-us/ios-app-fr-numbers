//
//  NumberViewController.h
//  Numbers
//
//  Created by Florin Rosca on 1/29/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "FRPageModel.h"

@interface FRPageViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) FRPageModel *model;

+ (BOOL) playingSound;
+ (void) setPlayingSound: (BOOL)val;

@end

