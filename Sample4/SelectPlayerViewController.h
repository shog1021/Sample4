//
//  SelectPlayer.h
//  Sample4
//
//  Created by 中村 祥二 on 13/08/05.
//  Copyright (c) 2013年 中村 祥二. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"


@interface SelectPlayerViewController : UIViewController<ELCImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, copy) NSArray *chosenImages;


@end
