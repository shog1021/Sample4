//
//  ELCImagePickerDemoAppDelegate.h
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectPlayerViewController;

@interface ELCImagePickerDemoAppDelegate : NSObject <UIApplicationDelegate> 

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SelectPlayerViewController *viewController;

@end

