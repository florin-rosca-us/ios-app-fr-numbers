//
//  NumberViewController.m
//  Numbers
//
//  Created by Florin Rosca on 1/29/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#import "FRPageViewController.h"

@interface FRPageViewController ()

@end

@implementation FRPageViewController {
    NSTimer *timer;
    SystemSoundID sound;
    NSString *lang;
    NSString *voice;
}

static BOOL playingSound = NO;

+ (BOOL)playingSound {
    @synchronized(self) {
        return playingSound;
    }
}

+ (void)setPlayingSound:(BOOL)val {
    @synchronized(self) {
        playingSound = val;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = self.model.backgroundColor;
    self.label.text = self.model.text;
    
    NSMutableAttributedString *at = [[NSMutableAttributedString alloc] initWithAttributedString: self.label.attributedText];
    [at addAttribute:NSForegroundColorAttributeName value:self.model.foregroundColor range:NSMakeRange(0, self.model.text.length)];
    [self.label setAttributedText:at];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self playSoundLater];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)stopTimer {
    @synchronized(self) {
        [timer invalidate];
        timer = nil;
    }
}

// Play sound
//
- (void) playSound {
    @synchronized(self) {
        if([FRPageViewController playingSound]) {
            [self playSoundLater];
            return;
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *udVoice = [defaults objectForKey:@"voice_id"];
        NSString *udLang = [defaults objectForKey:@"lang_id"];
        NSLog(@"user defaults voice: %@", udVoice);
        NSLog(@"user defaults lang : %@", udLang);
        if(!udVoice) {
            udVoice = @"Dana";
            [defaults setObject:udVoice forKey:@"voice_id"];
        }
        if(!udLang) {
            udLang = @"ro";
            [defaults setObject:udLang forKey:@"lang_id"];
        }
        if(!voice || !lang || ![voice isEqualToString:udVoice] || ![lang isEqualToString:udLang]) {
            lang = udLang;
            voice = udVoice;
            if(sound) {
                AudioServicesDisposeSystemSoundID(sound);
                sound = 0;
            }
            NSString *soundName = [NSString stringWithFormat:@"%@_%@_%@", voice, lang, self.model.text];
            NSLog(@"sound: %@", soundName);
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"wav"];
            NSLog(@"viewControllerAtIndex: soundPath: %@", soundPath);
            if (soundPath) {
                AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &sound);
            }
        }
        if(!sound) {
            return;
        }
        [FRPageViewController setPlayingSound:YES];
        AudioServicesPlaySystemSoundWithCompletion(sound, ^void {
            [FRPageViewController setPlayingSound: NO];
        });
    }
}

// Play sound later
//
- (void) playSoundLater {
    @synchronized(self) {
        if(timer) {
            return;
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(playSound) userInfo:nil repeats:NO];
    }
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer {
    [self playSound];
}


@end
