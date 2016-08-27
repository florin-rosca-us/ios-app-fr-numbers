//
//  FRNumberTableViewController.m
//  FRNumbers
//
//  Created by Florin on 8/23/16.
//  Copyright © 2016 Florin. All rights reserved.
//

#import "FRNumberTableViewController.h"


@interface FRNumberTableViewController () {
    NSUInteger selection;
}
@end


@implementation FRNumberTableViewController

#pragma mark - UIViewController methods

- (instancetype)init {
    if(self = [super init]) {
        self->selection = 0;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self postSelectionChangedTo:self->selection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource methods

// Returns the number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Returns the number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

// Configures the cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    NSUInteger row = indexPath.row;
    cell.textLabel.text = [NSString stringWithFormat:@"%lu", (row + 1)];
    cell.accessoryType = row == self->selection ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

// Configures the table title
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"Use audio for:", nil);
}



#pragma mark - UITableViewDelegate methods

// Updates the selection and posts a notification via NSNotificationCenter
// The selection is the current table row (zero-based)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableView:didSelectRowIndexAtPath: - begin");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self->selection inSection:0];
    
    if(indexPath.row == oldIndexPath.row) {
        NSLog(@"tableView:didSelectRowIndexAtPath: - end (no change)");
        return;
    }
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self->selection = indexPath.row;
        [self postSelectionChangedTo:self->selection];
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSLog(@"tableView:didSelectRowIndexAtPath: - end");
}



#pragma mark - Other methods

// Posts a notification via NSNotificationCenter
- (void) postSelectionChangedTo:(NSUInteger)theSelection {
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:theSelection], FRUserInfoSelection, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:FRNotifySelectionChanged object:self userInfo:userInfo];

}

@end
