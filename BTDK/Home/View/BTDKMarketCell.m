//
//  BTDKMarketCell.m
//  BTDK
//
//  Created by xiaoning on 2018/12/6.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "BTDKMarketCell.h"

@implementation BTDKMarketModel


@end

@interface BTDKMarketCell()

Strong UIImageView *imageView;
Strong UILabel *titleLabel;

@end

@implementation BTDKMarketCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

- (void)configViews {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake((ScreenWidth/4-52)/2, 0, 52, 52);
    self.imageView.backgroundColor = BTDKHexColor(@"#F9F9F9");
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 10.f;
    self.imageView.layer.borderWidth = 1.f;
    self.imageView.layer.borderColor = BTDKHexColor(@"#FFFFFF").CGColor;
    [self.contentView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(10, self.imageView.bottom+15, ScreenWidth/4-10*2, 14);
    self.titleLabel.font = BTDKFont(14);
    self.titleLabel.textColor = BTDKHexColor(@"#333333");
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
}

- (void)setModel:(BTDKMarketModel *)model {
    _model = model;
    [self.imageView setImageWithURL:[NSURL URLWithString:model.logo?:@""] placeholder:nil];
    self.titleLabel.text = model.name?:@"";
}

@end
