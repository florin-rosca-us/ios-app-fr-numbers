//
//  FRAppConstants.m
//  FRNumbers
//
//  Created by Florin on 8/22/16.
//  Copyright © 2016 Florin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRAppConstants.h"

@implementation FRAppConstants

+ (NSArray<NSString*> *)audioFileNames {
    static NSArray<NSString*> * _audioFileNames;
    @synchronized(self) {
        if(!_audioFileNames) {
            _audioFileNames = [NSArray arrayWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", nil];
        }
    }
    return _audioFileNames;
}

+ (NSString *)audioFileExtension {
    static NSString* _audioFileExt = @"m4a";
    return _audioFileExt;
}

@end