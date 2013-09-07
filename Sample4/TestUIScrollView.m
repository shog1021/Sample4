//
//  TestUIScrollView.m
//  Sample4
//
//  Created by 中村 祥二 on 13/09/07.
//  Copyright (c) 2013年 中村 祥二. All rights reserved.
//

#import "TestUIScrollView.h"

@implementation TestUIScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    NSLog(@"scrollview_began x->%f, y->%f", point.x, point.y);
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    NSLog(@"scrollview_end x->%f, y->%f", point.x, point.y);
    [super touchesEnded:touches withEvent:event];
}

@end
