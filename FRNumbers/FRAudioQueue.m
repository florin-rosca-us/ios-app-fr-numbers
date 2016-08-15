//
//  FRAudioQueue.m
//  FRNumbers
//
//  Created by Florin on 8/10/16.
//  Copyright © 2016 Florin. All rights reserved.
//

#import "FRAudioQueue.h"
#import "FRUtils.h"

@interface FRAudioQueue ()
@property(atomic) BOOL stopRequested;
@end


@implementation FRAudioQueue {
    NSCondition *condition;
    id<FRQueue> queue;
    NSTimer *timer;
    NSThread *thread;
    SystemSoundID sound;
}

+ (instancetype)sharedQueue {
    static FRAudioQueue *sharedQueue = nil;
    @synchronized(self) {
        if(!sharedQueue) {
            sharedQueue = [[self alloc] init];
        }
    }
    return sharedQueue;
}

- (instancetype)init {
    if(self = [super init]) {
        condition = [[NSCondition alloc] init];
        queue = [FRLinkedList list];
        sound = 0;
        self.stopRequested = NO;
    }
    return self;
}

- (BOOL)add:(NSString*)name {
    [condition lock];
    if([queue contains:name]) {
        [queue remove:name];
    }
    BOOL result = [queue offer:name];
    [condition signal];
    [condition unlock];
    return result;
}

- (BOOL)contains:(NSString*)name {
    [condition lock];
    BOOL result = [queue contains:name];
    [condition unlock];
    return result;
}

- (BOOL)remove:(NSString*)name {
    [condition lock];
    BOOL result =  [queue remove:name];
    [condition signal];
    [condition unlock];
    return result;
}

- (void)clear {
    [condition lock];
    [queue clear];
    [condition unlock];
}

- (NSUInteger)size {
    [condition lock];
    NSUInteger result = [queue size];
    [condition unlock];
    return result;
}

// Starts playing. Creates a thread for playing sounds one after another.
- (BOOL)play {
    [condition lock];
    BOOL result = NO;
    self.stopRequested = NO;
    if(!thread || thread.finished || thread.cancelled) {
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(playLoop) object:nil];
        [thread start];
        result = YES;
    }
    else {
        [condition signal];
    }
    [condition unlock];
    return result;
}

// The play thread loop. Waits for the current sound to play then plays next.
- (void)playLoop {
    while(true) {
        BOOL stop = NO;
        [condition lock];
        while(sound || [queue size] == 0) {
            [condition wait];
        }
        NSString* name = [queue poll];
        if(name) {
            [self playWithName:name];
        }
        stop = self.stopRequested;
        [condition unlock];
        if(stop) {
            break;
        }
    }
}

// Invoked from the play thread. Do not lock/unlock the condition except in other threads.
- (void)playWithName:(NSString*)name {
    NSLog(@"playWithName:%@ - begin", name);
    // NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dirDocuments = [paths objectAtIndex:0];
    NSString *path = [dirDocuments stringByAppendingPathComponent:[name stringByAppendingString:@".wav"]];
    if([fileManager fileExistsAtPath:path]) {
        NSLog(@"Found: %@", path);
    }
    else {
        NSLog(@"Cannot find %@, looking for a resource with same name...", path);
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
    }
    if(!path) {
        NSLog(@"Cannot find %@", name);
        return;
    }
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: path], &sound);
    if(!sound) {
        return;
    }
    AudioServicesPlaySystemSoundWithCompletion(sound, ^void {
        NSLog(@"playWithName:%@ - end", name);
        [condition lock];
        AudioServicesDisposeSystemSoundID(sound);
        sound = 0;
        [condition signal];
        [condition unlock];
    });
}

// Stops playing. Attempts to kill the play thread.
- (BOOL)stop {
    [condition lock];
    BOOL result = NO;
    if(thread) {
        result = self.stopRequested = YES;
        [condition signal];
    }
    [condition unlock];
    return result;
}


@end
