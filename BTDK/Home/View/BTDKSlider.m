//
//  BTDKSlider.m
//  BTDK
//
//  Created by xiaoning on 2018/12/4.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "BTDKSlider.h"

@implementation BTDKSlider

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    CGRect tempRect = rect;
    tempRect.origin.x = rect.origin.x-30;
    tempRect.size.width = rect.size.width+60;
    return CGRectInset([super thumbRectForBounds:bounds trackRect:tempRect value:value], 0, 0);
}

@end
