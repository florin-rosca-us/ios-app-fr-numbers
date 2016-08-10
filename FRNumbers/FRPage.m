//
//  FRPageModel.m
//  FRNumbers
//
//  Created by Florin Rosca on 8/9/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#import "FRPage.h"

@implementation FRPage

+ (instancetype)pageWithText:(NSString*)text foregroundColor:(UIColor*)foregroundColor backgroundColor:(UIColor*)backgroundColor {
    return [[FRPage alloc] initWithText:text foregroundColor:foregroundColor backgroundColor:backgroundColor];
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


#pragma mark - NSObject methods

- (BOOL)isEqual:(id)object {
    if(self == object) {
        return YES;
    }
    if(![object isKindOfClass:[FRPage class]]) {
        return NO;
    }
    FRPage *this = self;
    FRPage *that = (FRPage*)object;
    if(((!this.text) && that.text) || ![this.text isEqual:that.text]) {
        return NO;
    }
    if(((!this.foregroundColor) && that.foregroundColor) || ![this.foregroundColor isEqual:that.foregroundColor]) {
        return NO;
    }
    if(((!this.backgroundColor) && that.backgroundColor) || ![this.backgroundColor isEqual:that.backgroundColor]) {
        return NO;
    }
    return YES;
}

@end
