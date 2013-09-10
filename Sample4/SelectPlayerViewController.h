//
//  SelectPlayer.h
//  Sample4
//
//  Created by 中村 祥二 on 13/08/05.
//  Copyright (c) 2013年 中村 祥二. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"
#import "TestUIScrollView.h"
#import "BoardTypeEnum.h"

@interface SelectPlayerViewController : UIViewController<ELCImagePickerControllerDelegate>
{
    TestUIScrollView *thumbScrollView;	//	サムネイル一覧を埋め込んだスクロールビュー
}
@property (weak, nonatomic) IBOutlet UINavigationItem *navigation;
@property (weak, nonatomic) IBOutlet UIImageView *boadImage;
@property (nonatomic) BoardTypeEnum boardType;

@end
