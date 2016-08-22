//
//  FRConstants.h
//  FRNumbers
//
//  Created by Florin on 8/10/16.
//  Copyright © 2016 Florin. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef FRAppConstants_h
#define FRAppConstants_h

// 1
#define FRColorForeground01 [UIColor colorWithRed:28.0/255.0 green:165.0/255.0 blue:216.0/255.0 alpha:1.0]
#define FRColorBackground01 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]

// 2
#define FRColorForeground02 [UIColor colorWithRed:226.0/255.0 green:31.0/255.0 blue:122.0/255.0 alpha:1.0]
#define FRColorBackground02 [UIColor colorWithRed:244.0/255.0 green:198.0/255.0 blue:47.0/255.0 alpha:1.0]

// 3
#define FRColorForeground03 [UIColor colorWithRed:250.0/255.0 green:237.0/255.0 blue:55.0/255.0 alpha:1.0]
#define FRColorBackground03 [UIColor colorWithRed:234.0/255.0 green:85.0/255.0 blue:121.0/255.0 alpha:1.0]

// 4
#define FRColorForeground04 [UIColor colorWithRed:116.0/255.0 green:165.0/255.0 blue:50.0/255.0 alpha:1.0]
#define FRColorBackground04 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]

// 5
#define FRColorForeground05 [UIColor colorWithRed:248.0/255.0 green:241.0/255.0 blue:54.0/255.0 alpha:1.0]
#define FRColorBackground05 [UIColor colorWithRed:49.0/255.0 green:164.0/255.0 blue:217.0/255.0 alpha:1.0]

// 6
#define FRColorForeground06 [UIColor colorWithRed:238.0/255.0 green:54.0/255.0 blue:141.0/255.0 alpha:1.0]
#define FRColorBackground06 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]

// 7
#define FRColorForeground07 [UIColor colorWithRed:29.0/255.0 green:149.0/255.0 blue:204.0/255.0 alpha:1.0]
#define FRColorBackground07 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]

// 8
#define FRColorForeground08 [UIColor colorWithRed:246.0/255.0 green:147.0/255.0 blue:51.0/255.0 alpha:1.0]
#define FRColorBackground08 [UIColor colorWithRed:163.0/255.0 green:133.0/255.0 blue:170.0/255.0 alpha:1.0]

// 9
#define FRColorForeground09 [UIColor colorWithRed:238.0/255.0 green:50.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FRColorBackground09 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]

// 10
#define FRColorForeground10 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define FRColorBackground10 [UIColor colorWithRed:91.0/255.0 green:179.0/255.0 blue:190.0/255.0 alpha:1.0]

// The application group
FOUNDATION_EXPORT NSString *const FRAppGroup;

@interface FRAppConstants : NSObject
// TODO: These should be @property (class) but that is available in iOS10 only
+ (NSArray<NSString*> *) audioFileNames;
+ (NSString*) audioFileExtension;
@end

#endif /* FRAppConstants */