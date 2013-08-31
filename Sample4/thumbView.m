//
//  thumbView.m
//  list
//
//  Created by kunii on 09/08/26.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ThumbView.h"

#define DRAG_THRESHOLD 10		//	ドラッグを開始させるのに必要な距離

@implementation ThumbView
@synthesize home;
@synthesize touchLocation;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}

/*
	タッチされた。
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");

    touchLocation = [[touches anyObject] locationInView:self];	//	タッチ開始位置を記録
}

/*
	a b 間の距離を返す。
*/
static float distanceBetweenPoints(CGPoint a, CGPoint b) {
    float deltaX = a.x - b.x;
    float deltaY = a.y - b.y;
    return sqrtf( (deltaX * deltaX) + (deltaY * deltaY) );
}

/*
	最初のタッチ位置からある程度（DRAG_THRESHOLD）動かない限り、ドラッグを開始しない。
*/
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesMoved");
    
    CGPoint newTouchLocation = [[touches anyObject] locationInView:self];
	if (dragging) {
		//	すでにドラッグ中。あたらしい位置に自分を移動。
        float deltaX = newTouchLocation.x - touchLocation.x;
        float deltaY = newTouchLocation.y - touchLocation.y;
        [self moveByOffset:CGPointMake(deltaX, deltaY)];
    } else if (distanceBetweenPoints(touchLocation, newTouchLocation) > DRAG_THRESHOLD) {
		//	最初のタッチ位置からある程度（DRAG_THRESHOLD）動いたので、ドラッグとみなす。
        touchLocation = newTouchLocation;	//	ドラッグ開始位置を保存
		home = self.frame;
        dragging = YES;						//	次回からドラッグ処理開始。
    }
}

/*
	ドラッグしていたら自分が帰るべき位置に移動。
*/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded");
    if (dragging) {
		//	ドラッグしていたので、自分が帰るべき位置に移動。
        [self goHome];
        dragging = NO;
    } else if ([[touches anyObject] tapCount] == 1) {
		//	タップとみなす。
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled");
	//	無条件で、自分が帰るべき位置に移動。
    [self goHome];
    dragging = NO;
}

/*
	現在のframe位置からhome位置にアニメーションで戻す。
*/
- (void)goHome {
    float distanceFromHome = distanceBetweenPoints([self frame].origin, [self home].origin);  
    //	1ピクセルを1ミリ秒で移動させる。ただし最低、0.1秒のアニメーションを保証。
    float animationDuration = 0.1 + distanceFromHome * 0.001; 
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [self setFrame:[self home]];						//	home 位置に移動させる。
    [UIView commitAnimations];
}

/*
	frameを指定したオフセット分ずらす。
*/
- (void)moveByOffset:(CGPoint)offset {
    CGRect frame = [self frame];
    frame.origin.x += offset.x;
    frame.origin.y += offset.y;
    [self setFrame:frame];
}    

@end
