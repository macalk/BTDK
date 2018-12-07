//
//  UnallowedAndMarketView.m
//  BTDK
//
//  Created by xiaoning on 2018/12/5.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "UnallowedAndMarketView.h"

@interface UnallowedAndMarketView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation UnallowedAndMarketView

- (NSMutableArray *)productList {
    if (!_productList) {
        _productList = [NSMutableArray arrayWithCapacity:0];
    }
    return _productList;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return  self;
}

- (void)configView {
    UIImageView *img = [[UIImageView alloc]init];
    img.image = BTDKImage(@"bigds");
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(21+TopBarHeight);
        make.size.mas_offset(CGSizeMake(95, 108));
    }];
    
    UILabel *tit = [[UILabel alloc]init];
    tit.text = @"审核未通过";
    tit.font = BTDKFont(20);
    tit.textColor = BTDKHexColor(@"#afafaf");
    [self addSubview:tit];
    [tit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(img.mas_bottom).with.offset(12);
    }];
    
    UILabel *subTit = [[UILabel alloc]init];
    subTit.text = @"抱歉审核未通过，请七天后再来尝试哦~";
    subTit.font = BTDKFont(15);
    subTit.textColor = BTDKHexColor(@"#cecece");
    [self addSubview:subTit];
    [subTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(tit.mas_bottom).with.offset(12);
    }];
    
//    UIView *bottomBgView = [[UIView alloc]init];
//    bottomBgView.backgroundColor = BTDKHexColor(@"e4edf3");
//    [self addSubview:bottomBgView];
//    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.right.equalTo(self);
//        make.top.equalTo(subTit.mas_bottom).with.offset(37);
//        make.bottom.equalTo(self);
//    }];
//
//    UILabel *leftTit = [[UILabel alloc]initWithFrame:CGRectMake(10, 18, 70, 20)];
//    leftTit.text = @"借款推荐";
//    leftTit.font = BTDKFont(16);
//    leftTit.textColor = BTDKHexColor(@"#333333");
//    [bottomBgView addSubview:leftTit];
//
//    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    moreBtn.frame = CGRectMake(ScreenWidth-80, 13, 60, 30);
//    moreBtn.titleLabel.font = BTDKFont(14);
//    [moreBtn setTitle:@"换一换" forState:UIControlStateNormal];
//    [moreBtn setTitleColor:BTDKHexColor(@"#333333") forState:UIControlStateNormal];
//    [moreBtn setImage:BTDKImage(@"in") forState:UIControlStateNormal];
//    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
//    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
//    moreBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [moreBtn addTarget:self action:@selector(onMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomBgView addSubview:moreBtn];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    self.myCollectionView.backgroundColor = BTDKHexColor(@"#e4edf3");
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.contentInset = UIEdgeInsetsZero;
    [self addSubview:self.myCollectionView];
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(subTit.mas_bottom).with.offset(37);
        make.bottom.equalTo(self);
    }];
    
    [self.myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader"];
    [self.myCollectionView registerClass:[BTDKMarketCell class] forCellWithReuseIdentifier:[BTDKMarketCell className]];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, 70);
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = BTDKFont(19);
    titleLabel.textColor = BTDKHexColor(@"#333333");
    titleLabel.text = @"借款推荐";
    titleLabel.frame = CGRectMake(15, 25, 80, 19);
    [headerView addSubview:titleLabel];
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(ScreenWidth-15-75, 25, 75, 19);
    moreBtn.titleLabel.font = BTDKFont(14);
    [moreBtn setTitle:@"换一换" forState:UIControlStateNormal];
    [moreBtn setTitleColor:BTDKHexColor(@"#333333") forState:UIControlStateNormal];
    [moreBtn setImage:BTDKImage(@"in") forState:UIControlStateNormal];
    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -34, 0, 0);
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
    [moreBtn addTarget:self action:@selector(onMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:moreBtn];
    return headerView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.productList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ScreenWidth/4, 100);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTDKMarketCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BTDKMarketCell className] forIndexPath:indexPath];
    if (self.productList.count > indexPath.item) {
        BTDKMarketModel *model = self.productList[indexPath.item];
        cell.model = model;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.productList.count > indexPath.item) {
        BTDKMarketModel *model = self.productList[indexPath.item];
        if (model.url) {
            [BTDKTool jumpWebWithUrl:model.url];
        }
    }
}

- (void)onMoreBtnClick:(UIButton *)sender {
    [BTDKTool jumpWebWithUrl:[BTDKTool getHTMLWithPath:LoanPage_LoanMarketList_HTMLUrl]];
}

@end
