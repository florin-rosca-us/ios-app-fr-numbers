//
//  ShareViewController.m
//  FRAudio
//
//  Created by Florin Rosca on 8/15/16.
//  Copyright © 2016 Florin Rosca. All rights reserved.
//
//  See https://developer.apple.com/library/ios/documentation/General/Conceptual/ExtensibilityPG/ExtensionCreation.html
//

#import "FRShareViewController.h"


@interface FRShareViewController () {
    NSUInteger selection;
}
@end


@implementation FRShareViewController


#pragma mark - UIViewController methods

- (instancetype)init {
    if(self = [super init]) {
        self->selection = 0;
    }
    return self;
}

// Sets up the navigation bar: sets the title, adds Cancel and Save buttons
- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *bar = self.navigationBar;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleDone target:nil action:@selector(doCancel)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleDone target:nil action:@selector(doSave)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"Count With Me", nil)];
    item.leftBarButtonItem = leftButton;
    item.rightBarButtonItem = rightButton;
    item.hidesBackButton = YES;
    [bar pushNavigationItem:item animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectionChanged:) name:FRNotifySelectionChanged object:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - Other methods

- (void)selectionChanged:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    if(!userInfo) {
        return;
    }
    NSNumber *value = [userInfo objectForKey:FRUserInfoSelection];
    self->selection = [value unsignedIntegerValue];
    NSLog(@"selectionChanged: - the selection is now: %lu", (unsigned long)self->selection);
}

// Invoked when the user taps "Cancel"
- (void)doCancel {
    NSLog(@"doCancel - begin");
    NSExtensionContext *context = self.extensionContext;
    // cancelRequestWithError cannot return nil
    NSError* error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil];
    NSLog(@"doCancel - end");
    [context cancelRequestWithError:error];
}

// Invoked when the user taps "Save"
- (void)doSave {
    NSLog(@"doSave - begin");
    
    NSArray* typeIdentifiers = [NSArray arrayWithObjects:(NSString*)kUTTypeFileURL, (NSString*)kUTTypeMPEG4Audio, nil];
    NSExtensionContext *context = self.extensionContext;
    NSArray *inputItems = [context inputItems];

    // From http://stackoverflow.com/questions/24056024/sharing-extension-in-ios8-beta
    if(inputItems.count == 0) {
        NSLog(@"doSave - no items");
        [context cancelRequestWithError: [NSError errorWithDomain:NSCocoaErrorDomain code:NSFeatureUnsupportedError userInfo:nil]];
        return;
    }
    
    NSExtensionItem *item = inputItems.firstObject;
    NSItemProvider *itemProvider = item.attachments.firstObject;
    
    // Check if the item provider conforms to all type identifiers that we are looking for
    for(id typeIdentifier in typeIdentifiers) {
        if (![itemProvider hasItemConformingToTypeIdentifier:(NSString*)typeIdentifier]) {
            NSLog(@"doSave - nothing to share");
            [context cancelRequestWithError: [NSError errorWithDomain:NSCocoaErrorDomain code:NSFeatureUnsupportedError userInfo:nil]];
            return;
        }
    }
    
    // Load the content. We are interested in the URL only.
    [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeFileURL options:nil completionHandler:^(NSURL *url, NSError *error) {
        [self doShareWithUrl:url error:error];
    }];
    
    NSLog(@"doSave - end");
}

// Invoked in the completion handler block of [itemProvider loadItemForTypeIdentifier]. Here we copy one m4a file to the shared app group container.
// Next time the FRNumbers is activated, it will look for files there, copy them to Documents and remove them from the shared app group container.
- (void)doShareWithUrl:(NSURL*)inputURL error:(NSError*)inputError {
    NSLog(@"doShareWithUrl:error: - loaded URL=%@ error=%@", inputURL, inputError);
    NSExtensionContext *context = self.extensionContext;

    if(inputError) {
        NSLog(@"doShareWithUrl:error: - an error occurred in loadItemForTypeIdentifier");
        [context cancelRequestWithError:inputError];
        return;
    }
    
    // Share the file with the group here
    NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier: FRAppGroup];
    NSLog(@"doShareWithUrl:error: - groupURL=%@", groupURL);

    // Use the current selection from the FRNumberTableViewController to build the output file name.
    // The selection is zero-based.
    NSString *fileName = nil;
    fileName = [NSString stringWithFormat:@"%02lu", (self->selection + 1)];
    fileName = [fileName stringByAppendingPathExtension:inputURL.lastPathComponent.pathExtension];
    NSURL *outputURL = [NSURL URLWithString:[groupURL.absoluteString stringByAppendingPathComponent:fileName]];
    NSLog(@"doShareWithUrl:error outputURL=%@", outputURL);

    // To avoid data corruption, we must synchronize data accesses. Apparently NSFileCoordinators can be used since 8.2.
    // See http://www.atomicbird.com/blog/sharing-with-app-extensions
    // There is no benefit to keeping a file coordinator object past the length of the planned operation.
    NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
    NSError *coordinatorError = nil;
    [fileCoordinator coordinateWritingItemAtURL:outputURL options:NSFileCoordinatorWritingForReplacing error:&coordinatorError byAccessor:^(NSURL *newURL) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *fileError;
        // Delete existing file. We don't want backup files
        if([fileManager fileExistsAtPath:[outputURL path]]) {
            NSLog(@"doShareWithUrl:error:^byAccessor - removing existing %@", outputURL);
            if(![fileManager removeItemAtURL:outputURL error:&fileError]) {
                NSLog(@"doShareWithUrl:error:^byAccessor - removeItemAtURL: %@", fileError);
                NSLog(@"doShareWithUrl:error:^byAccessor - end");
                return;
            }
        }
        // Copy the content of the input file to the output file
        NSLog(@"doShareWithUrl:error: - copying %@ to %@", inputURL, outputURL);
        if(![fileManager copyItemAtURL:inputURL toURL:outputURL error:&fileError]) {
            NSLog(@"doShareWithUrl:error: - copyItemAtURL: %@", fileError);
        }
    }];
    if(coordinatorError) {
        NSLog(@"doShareWithUrl:error: - an error occurred in coordinateWritingItemAtURL");
        [context cancelRequestWithError:inputError];
        return;
    }

    // We are not modifying any input items so we are completing the request and returning an empty array
    NSArray *outputItems = [NSArray array];
    [context completeRequestReturningItems:outputItems completionHandler:^(BOOL expired){
        // If the system calls your block with an expired value of YES, you must immediately suspend your app extension.
        // If you fail to do this, the system terminates your extension’s process.
        NSLog(@"doShareWithUrl:error:^completionHandler - expired=%@", expired?@"YES":@"NO");
    }];
    
    NSLog(@"doShareWithUrl:error: - end");
}

@end
