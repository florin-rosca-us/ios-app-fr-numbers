//
//  FRAudioQueue.h
//  FRNumbers
//
//  Created by Florin Rosca on 8/10/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#ifndef FRAudioQueue_h
#define FRAudioQueue_h

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "FRAppConstants.h"
#import "FRUtils.h"


@interface FRAudioQueue : NSObject

// The singleton
+ (instancetype)sharedQueue;

// Adds a sound to the queue. Does not start playing automatically. To start playing call play:
- (BOOL)add:(NSString*)name;

// Returns YES if the queue contains the specified sound.
- (BOOL)contains:(NSString*)name;

// Removes a sound from the queue. If the sound is already playing, it will not be stopped.
- (BOOL)remove:(NSString*)name;

// Removes all sounds from queue. The sound currently playing is not stopped.
- (void)clear;

// Starts playing sounds from this queue in the order they were added. Ignored if the queue was already playing.
- (BOOL)play;

// Stops playing after playing the current sound, if any. Does not remove sounds from queue.
- (BOOL)stop;

@end

#endif