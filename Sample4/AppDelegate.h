//
//  AppDelegate.h
//  Sample4
//
//  Created by 中村 祥二 on 13/08/04.
//  Copyright (c) 2013年 中村 祥二. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectPlayerViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SelectPlayerViewController *viewController;


@end
