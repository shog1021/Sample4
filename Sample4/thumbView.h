//
//  thumbView.h
//  list
//
//  Created by kunii on 09/08/26.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThumbView : UIView {
    CGRect home;			//	ドラッグ前の位置を記憶。    
    BOOL dragging;			//	ドラッグ中はYES
    CGPoint touchLocation;	//	最初タッチ位置、ドラッグ時はドラッグ開始位置を記録。
}

@property (nonatomic, assign) CGRect home;
@property (nonatomic, assign) CGPoint touchLocation;

- (void)goHome;							// 現在のframe位置からhome位置にアニメーションで戻す。
- (void)moveByOffset:(CGPoint)offset;	// frameを指定したオフセット分ずらす。

@end
