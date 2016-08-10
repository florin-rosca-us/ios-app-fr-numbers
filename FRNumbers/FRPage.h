//
//  FRPageModel.h
//  FRNumbers
//
//  The page model
//
//  Created by Florin Rosca on 8/9/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#ifndef FRPage_h
#define FRPage_h

#import "FRColors.h"

@interface FRPage : NSObject

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) UIColor *foregroundColor, *backgroundColor;

+ (instancetype)pageWithText:(NSString*)text foregroundColor:(UIColor*)foregroundColor backgroundColor:(UIColor*)backgroundColor;

- (instancetype)initWithText:(NSString*)text foregroundColor:(UIColor*)foregroundColor backgroundColor:(UIColor*)backgroundColor;

@end

#endif