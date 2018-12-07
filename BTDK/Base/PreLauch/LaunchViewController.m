//
//  LaunchViewController.m
//  KaiXinQianDai
//
//  Created by xiaoning on 2018/11/27.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "LaunchViewController.h"

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *lauchView = [[UIImageView alloc] init];
    lauchView.frame = self.view.bounds;
    [self.view addSubview:lauchView];
    
    if (IS_IPHONE_4_OR_LESS) {
        lauchView.image = [UIImage imageNamed:@"3.5"];
    }
    else if (IS_IPHONE_5) {
        lauchView.image = [UIImage imageNamed:@"4.0"];
    }
    else if (IS_IPHONE_6) {
        lauchView.image = [UIImage imageNamed:@"4.7"];
    }
    else if (IS_IPHONE_6_PLUS) {
        lauchView.image = [UIImage imageNamed:@"5.5"];
    }
    else if (IS_IPHONE_X) {
        lauchView.image = [UIImage imageNamed:@"5.8"];
    }
    else {
        lauchView.image = [UIImage imageNamed:@"5.8"];
    }
}

@end
