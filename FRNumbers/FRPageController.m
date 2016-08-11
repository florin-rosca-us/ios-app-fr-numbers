//
//  NumberViewController.m
//  Numbers
//
//  Created by Florin Rosca on 1/29/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//

#import "FRPageController.h"
#import "FRAudioQueue.h"

@interface FRPageController ()
@end


@implementation FRPageController


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
    [super viewWillAppear:animated];
    self.view.backgroundColor = self.model.backgroundColor;
    self.label.text = self.model.text;
    
    NSMutableAttributedString *at = [[NSMutableAttributedString alloc] initWithAttributedString: self.label.attributedText];
    [at addAttribute:NSForegroundColorAttributeName value:self.model.foregroundColor range:NSMakeRange(0, self.model.text.length)];
    [self.label setAttributedText:at];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[FRAudioQueue sharedQueue] add:self.model.sound];
    [[FRAudioQueue sharedQueue] play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[FRAudioQueue sharedQueue] remove:self.model.sound];
}


#pragma mark - UIGestureRecognizerDelegate methods

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer {
    [[FRAudioQueue sharedQueue] add:self.model.sound];
    [[FRAudioQueue sharedQueue] play];
}

@end
