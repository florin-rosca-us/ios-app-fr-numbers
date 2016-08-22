//
//  ShareViewController.m
//  FRAudio
//
//  Created by Florin on 8/15/16.
//  Copyright © 2016 Florin. All rights reserved.
//
//  See https://developer.apple.com/library/ios/documentation/General/Conceptual/ExtensibilityPG/ExtensionCreation.html
//

#import "FRShareViewController.h"

// The application group
NSString *const FRAppGroup = @"group.florin-rosca-us.FRNumbers";


@interface FRShareViewController ()
@end


@implementation FRShareViewController

// Sets up the navigation bar: sets the title, adds Cancel and Done buttons
- (void)viewDidLoad {
    UINavigationBar *bar = self.navigationBar;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:nil action:@selector(doCancel)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:nil action:@selector(doShare)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Audio"];
    item.leftBarButtonItem = leftButton;
    item.rightBarButtonItem = rightButton;
    item.hidesBackButton = YES;
    [bar pushNavigationItem:item animated:NO];
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

// Invoked when the user taps "Done"
- (void)doShare {
    NSLog(@"doShare - begin");
    
    NSArray* typeIdentifiers = [NSArray arrayWithObjects:(NSString*)kUTTypeFileURL, (NSString*)kUTTypeMPEG4Audio, nil];
    NSExtensionContext *context = self.extensionContext;
    NSArray *inputItems = [context inputItems];

    // From http://stackoverflow.com/questions/24056024/sharing-extension-in-ios8-beta
    if(inputItems.count == 0) {
        NSLog(@"doShare - no items");
        [context cancelRequestWithError: [NSError errorWithDomain:NSCocoaErrorDomain code:NSFeatureUnsupportedError userInfo:nil]];
        return;
    }
    
    NSExtensionItem *item = inputItems.firstObject;
    NSItemProvider *itemProvider = item.attachments.firstObject;
    
    // Check if the item provider conforms to all type identifiers that we are looking for
    for(id typeIdentifier in typeIdentifiers) {
        if (![itemProvider hasItemConformingToTypeIdentifier:(NSString*)typeIdentifier]) {
            NSLog(@"doShare - nothing to share");
            [context cancelRequestWithError: [NSError errorWithDomain:NSCocoaErrorDomain code:NSFeatureUnsupportedError userInfo:nil]];
            return;
        }
    }
    
    // Load the content. We are interested in the URL only.
    [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeFileURL options:nil completionHandler:^(NSURL *url, NSError *error) {
        [self doShareWithUrl:url error:error];
    }];
    
    NSLog(@"doShare - end");
}

// Invoked in the completion handler block of [itemProvider loadItemForTypeIdentifier]. Here we copy one m4a file to the shared app group container.
// Next time the FRNumbers is activated, it will look for files there, copy them to Documents and remove them from the shared app group container.
- (void)doShareWithUrl:(NSURL*)inputURL error:(NSError*)inputError {
    NSLog(@"doShareWithUrl:error - loaded URL=%@ error=%@", inputURL, inputError);
    NSExtensionContext *context = self.extensionContext;

    if(inputError) {
        NSLog(@"doShareWithUrl:error - an error occurred in loadItemForTypeIdentifier");
        [context cancelRequestWithError:inputError];
        return;
    }
    
    // Share the file with the group here
    NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier: FRAppGroup];
    NSLog(@"doShareWithUrl:error - groupURL=%@", groupURL);

    // TODO: get selection from Maininterface instead of lastPathComponent. We should be able to use any incoming file name
    NSURL *outputURL = [NSURL URLWithString:[groupURL.absoluteString stringByAppendingPathComponent:inputURL.lastPathComponent]];
    NSLog(@"doShareWithUrl:error outputURL=%@", outputURL);

    // To avoid data corruption, we must synchronize data accesses. Apparently NSFileCoordinators can be used since 8.2
    // See http://www.atomicbird.com/blog/sharing-with-app-extensions
    // There is no benefit to keeping a file coordinator object past the length of the planned operation
    NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
    NSError *coordinatorError = nil;

    [fileCoordinator coordinateWritingItemAtURL:outputURL options:NSFileCoordinatorWritingForReplacing error:&coordinatorError byAccessor:^(NSURL *newURL) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *fileError;
        
        // Delete existing file. We don't want backup files
        if([fileManager fileExistsAtPath:[outputURL path]]) {
            if(![fileManager removeItemAtURL:outputURL error:&fileError]) {
                NSLog(@"doShareWithUrl:error - removeItemAtURL: an error occurred while deleting %@", outputURL);
                if(fileError ) {
                    NSLog(@"doShareWithUrl:error - removeItemAtURL: %@", fileError);
                }
                return;
            }
            else {
                NSLog(@"doShareWithUrl:error - removeItemAtURL: removed existing %@", outputURL);
            }
        }
        
        // Copy the content of the input file to the output file
        if([fileManager copyItemAtURL:inputURL toURL:outputURL error:&fileError]) {
            NSLog(@"doShareWithUrl:error - copyItemAtURL: copied %@ to %@", inputURL, outputURL);
        }
        else {
            NSLog(@"doShareWithUrl:error - copyItemAtURL: an error occurred while copying %@ to %@", inputURL, outputURL);
            if(fileError ) {
                NSLog(@"doShareWithUrl:error - copyItemAtURL: %@", fileError);
            }
        }
    }];
    
    if(coordinatorError) {
        NSLog(@"doShareWithUrl:error - an error occurred in coordinateWritingItemAtURL");
        [context cancelRequestWithError:inputError];
        return;
    }

    // We are not modifying any input items so we are completing the request and returning an empty array
    NSArray *outputItems = [NSArray array];
    [context completeRequestReturningItems:outputItems completionHandler:^(BOOL expired){
        // If the system calls your block with an expired value of YES, you must immediately suspend your app extension.
        // If you fail to do this, the system terminates your extension’s process.
        NSLog(@"doShareWithUrl:error - completeRequestReturningItems - expired=%@", expired?@"YES":@"NO");
    }];
    
    NSLog(@"doShareWithUrl:error - end");
}

@end
