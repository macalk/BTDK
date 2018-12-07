//
//  BTDKHandle.m
//  KaiXinQianDai
//
//  Created by xiaoning on 2018/11/27.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "BTDKHandle.h"

@implementation BTDKHandle

+ (instancetype)shareHandle {
    static BTDKHandle *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[BTDKHandle alloc] init];
    });
    return handle;
}

@end
