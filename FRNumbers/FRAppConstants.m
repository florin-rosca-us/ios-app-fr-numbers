//
//  FRAppConstants.m
//  FRNumbers
//
//  Application constants.
//
//  Created by Florin on 8/22/16.
//  Copyright © 2016 Florin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRAppConstants.h"

// The application group
NSString *const FRAppGroup = @"group.florin-rosca-us.FRNumbers";


@implementation FRAppConstants

// Audio file names, without extension
+ (NSArray<NSString*> *)audioFileNames {
    static NSArray<NSString*> * _audioFileNames;
    @synchronized(self) {
        if(!_audioFileNames) {
            _audioFileNames = [NSArray arrayWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", nil];
        }
    }
    return _audioFileNames;
}

// The extension for audio files
+ (NSString *)audioFileExtension {
    static NSString* _audioFileExt = @"m4a";
    return _audioFileExt;
}

@end