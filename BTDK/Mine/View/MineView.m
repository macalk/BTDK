//
//  MineView.m
//  BTDK
//
//  Created by xiaoning on 2018/12/6.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "MineView.h"

@implementation MineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView {
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = BTDKHexColor(@"#14a0ff");
    topView.frame = CGRectMake(0, 0, ScreenWidth, StatusBarHeight);
    [self addSubview:topView];
    
    UIImageView *topImg = [[UIImageView alloc]initWithImage:BTDKImage(@"mine_bg")];
    [self addSubview:topImg];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.width.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(@175);
    }];
    
    UIImageView *headImg = [[UIImageView alloc]initWithImage:BTDKImage(@"portrait")];
    [self addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(TopBarHeight+80);
        make.size.mas_offset(CGSizeMake(90, 90));
    }];
    
    UILabel *accountLabel = [[UILabel alloc]init];
    accountLabel.font = BTDKFont(15);
    accountLabel.textColor = BTDKHexColor(@"#252525");
    accountLabel.text = [BTDKTool getFixPhone:[BTDKHandle shareHandle].phone];
    [self addSubview:accountLabel];
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(headImg.mas_bottom).with.offset(18);
    }];
    
    
}

@end
