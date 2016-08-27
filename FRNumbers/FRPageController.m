//
//  NumberViewController.m
//  Numbers
//
//  Created by Florin Rosca on 1/29/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#import "FRPageController.h"

@interface FRPageController () {
    BOOL wasInBackground;
}
@end


@implementation FRPageController

#pragma mark - NSObject methods

- (instancetype)init {
    if(self = [super init]) {
        self->wasInBackground = NO;
    }
    return self;
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[FRAudioQueue sharedQueue] clear];
    [[FRAudioQueue sharedQueue] stop];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear: - begin");
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = self.model.backgroundColor;
    self.label.text = self.model.text;
    
    NSMutableAttributedString *at = [[NSMutableAttributedString alloc] initWithAttributedString: self.label.attributedText];
    [at addAttribute:NSForegroundColorAttributeName value:self.model.foregroundColor range:NSMakeRange(0, self.model.text.length)];
    [self.label setAttributedText:at];
    NSLog(@"viewWillAppear: - end");
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear: - begin");
    [super viewDidAppear:animated];
    // Add self as observer for ApplicationDidBecomeActive notifications
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UIApplication *app = [UIApplication sharedApplication];
    [nc addObserver:self selector:@selector(onEnterBackground) name:UIApplicationWillResignActiveNotification object:app];
    [nc addObserver:self selector:@selector(onEnterForeground) name:UIApplicationDidBecomeActiveNotification object:app];

    [[FRAudioQueue sharedQueue] add:self.model.sound];
    [[FRAudioQueue sharedQueue] play];
    NSLog(@"viewDidAppear: - end");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // Remove self as observer for enter foreground notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Remove audio from queue
    [[FRAudioQueue sharedQueue] remove:self.model.sound];
}


#pragma mark - UIGestureRecognizerDelegate methods

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer {
    [[FRAudioQueue sharedQueue] add:self.model.sound];
    [[FRAudioQueue sharedQueue] play];
}


#pragma mark - FRPageController methods

- (void)onEnterBackground {
    @synchronized (self) {
        self->wasInBackground = YES;
    }
}
    
- (void)onEnterForeground {
    @synchronized (self) {
        // Play audio when entering foreground. Note that the audio file might have changed in the app delegate
        // Since the app enters the foreground when starting, we need to avoid playing the audio twice
        // Make sure that the app was sent to background before playing audio
        if(self->wasInBackground) {
            [[FRAudioQueue sharedQueue] add:self.model.sound];
            [[FRAudioQueue sharedQueue] play];
            self->wasInBackground = NO;
        }
    }
}


@end
