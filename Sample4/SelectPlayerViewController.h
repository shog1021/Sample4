//
//  SelectPlayer.h
//  Sample4
//
//  Created by 中村 祥二 on 13/08/05.
//  Copyright (c) 2013年 中村 祥二. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"


@interface SelectPlayerViewController : UIViewController<ELCImagePickerControllerDelegate>
{
    UIScrollView *thumbScrollView;	//	サムネイル一覧を埋め込んだスクロールビュー
    UIView       *slideUpView;		//	thumbScrollViewを埋め込んだビュー

}


@end
