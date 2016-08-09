//
//  FRPageModel.m
//  FRNumbers
//
//  Created by Florin Rosca on 8/9/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#import "FRPageModel.h"

@implementation FRPageModel

@synthesize text = _text;
@synthesize foregroundColor = _foregroundColor;

+ (instancetype)pageWithText:(NSString*)text foregroundColor:(UIColor*)foregroundColor backgroundColor:(UIColor*)backgroundColor {
    return [[FRPageModel alloc] initWithText:text foregroundColor:foregroundColor backgroundColor:backgroundColor];
}

- (instancetype)initWithText:(NSString*)text foregroundColor:(UIColor*)foregroundColor backgroundColor:(UIColor*)backgroundColor {
    if(self = [super init]) {
        _text = text;
        _foregroundColor = foregroundColor;
        _backgroundColor = backgroundColor;
    }
    return self;
}

- (instancetype)init {
    return [self initWithText:@"0" foregroundColor:FRColorForeground01 backgroundColor:FRColorBackground01];
}

@end
