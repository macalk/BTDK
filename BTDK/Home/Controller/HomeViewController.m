//
//  HomeViewController.m
//  KaiXinQianDai
//
//  Created by xiaoning on 2018/11/29.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "HomeViewController.h"
#import "BTDKSlider.h"
#import "IdCardViewController.h"
#import "UnallowedView.h"
#import "ApplyForView.h"
#import "UnallowedAndMarketView.h"

@interface HomeViewController ()

Strong BTDKSlider *slider;
Strong UILabel *moneyLabel;
Strong UIView *bgView;
Strong ApplyForView *applyView;
Strong UnallowedAndMarketView *unallowedAndMarketView;

Assign LoanStatus loanStatus;


@end

@implementation HomeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"白条贷款";
    //获取订单信息
    [self requestOrderList];

}

- (void)statusWithOrderStatus {
    [self configData];
    if ([BTDKHandle shareHandle].isApplyFor == LoanStatus_Fail) {//审核拒绝
        [self configNavigationBarTitleWithColor:[UIColor blackColor]];
        [self configStatusBarDefault];
    }else {
        [self configStatusBarLight];
        [self configNavigationBarTitleWithColor:[UIColor whiteColor]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavigationBarShow];
    [self configNavigationBarImage:[UIImage new]];
    [self configNavigationBarShadow:[UIImage new]];
}

- (void)configData {
    
    if ([BTDKHandle shareHandle].isApplyFor == LoanStatus_Fail) {
        [self auditFailure];
    }else {
        [self goLoan];
    }
}
- (void)auditFailure {
    if ([BTDKHandle shareHandle].isShowApplyMarket) {
        UnallowedAndMarketView *view = [[UnallowedAndMarketView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-TabBarHeight)];
        self.unallowedAndMarketView = view;
        [self.view addSubview:view];
        [self requestProductList];
    }else {
        UnallowedView *view = [[UnallowedView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-TabBarHeight)];
        [self.view addSubview:view];
    }
}
- (void)goLoan {
    ApplyForView *applyView = [[ApplyForView alloc]initWithFrame:self.view.frame];
    self.applyView = applyView;
    [applyView.applyForBtn addTarget:self action:@selector(applyForBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successApplyFor)name:@"successApplyFor" object:nil];
}

- (void)successApplyFor {
    [self checkLoanStatusForVisiableView];
}

- (void)rightBarButtonAciton {
    [self QrCode];
}

- (void)QrCode {
    UIView *bgView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].delegate.window.bounds];
    bgView.backgroundColor = BTDKHexColorAlpha(@"#000000", 0.4);
    [[UIApplication sharedApplication].delegate.window addSubview:bgView];
    UIImageView *codeBgImg = [[UIImageView alloc]init];
    codeBgImg.image = BTDKImage(@"Popup");
    [bgView addSubview:codeBgImg];
    self.bgView = bgView;
    [codeBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
        make.size.mas_offset(CGSizeMake(240, 288));
    }];
    
    UIImageView *codeImg = [[UIImageView alloc]init];
    codeImg.image = BTDKImage(@"");
    codeImg.backgroundColor = BTDKHexColor(@"#ededed");
    [codeBgImg addSubview:codeImg];
    [codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeBgImg).with.offset(76);
        make.centerX.equalTo(codeBgImg);
        make.size.mas_offset(CGSizeMake(160, 160));
    }];
    
    UILabel *subLabel = [[UILabel alloc]init];
    subLabel.text = @"关注微信“白条贷款”公众号";
    subLabel.textColor = BTDKHexColor(@"#454545");
    subLabel.font = [UIFont systemFontOfSize:13];
    [codeBgImg addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeImg);
        make.top.equalTo(codeImg.mas_bottom).with.offset(18);
    }];
    
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
    rec.numberOfTapsRequired = 1;
    [bgView addGestureRecognizer:rec];

}

- (void)sliderChangeAction:(UISlider *)sender {
    self.moneyLabel.text = [NSString stringWithFormat:@"%0.f",sender.value];
}

- (void)applyForBtnClick:(UIButton *)sender {
    IdCardViewController *idVC = [[IdCardViewController alloc]init];
    idVC.moneyNum = self.applyView.moneyLabel.text;
    [self.navigationController pushViewController:idVC animated:YES];
}

- (void)doTapChange:(UITapGestureRecognizer *)sender {
    [self.bgView removeFromSuperview];
}

- (void)checkLoanStatusForVisiableView {
    
    __block int timeout=10; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.applyView removeFromSuperview];
                [BTDKHandle shareHandle].isApplyFor = LoanStatus_Fail;
                [self auditFailure];
            });
        }else{
            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d:%.2d",minutes, seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.applyView.applyForBtn.enabled = NO;
                [self.applyView.applyForBtn setBackgroundColor:BTDKHexColor(@"#bababa")];
                [self.applyView.applyForBtn setTitle:BTDKString(@"审 核 中 （%@）",strTime) forState:normal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)requestProductList {
    [ApiManager requestWithTpye:@"GET" path:products_list parameters:@{@"sign":@"RgUfwcoJbWVPmT2dghPm4y6jRKF6i4"} success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            if (response[ResponseData] && [response[ResponseData] isKindOfClass:[NSArray class]]) {
                [self.unallowedAndMarketView.productList removeAllObjects];
                for (NSDictionary *dic in response[ResponseData]) {
                    BTDKMarketModel *model = [BTDKMarketModel modelWithDictionary:dic];
                    [self.unallowedAndMarketView.productList addObject:model];
                }
                [self.unallowedAndMarketView.myCollectionView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//获取是否通过审核
- (void)requestOrderList {
    NSString *userId = [BTDKHandle shareHandle].userId;
    NSDictionary *param = @{@"userId":userId};
    [ApiManager requestWithTpye:nil path:s1_order_list parameters:param success:^(NSURLSessionDataTask *task, id response) {
        NSLog(@"%@",response);
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            if (response[ResponseData]) {
                NSString *orderStatus = [NSString stringWithFormat:@"%@",[response[ResponseData] valueForKey:@"status"]];
                [BTDKHandle shareHandle].isApplyFor = [orderStatus integerValue];
                [self statusWithOrderStatus];
            }
        }else {
            [UIView hudWithMessage:BTDKString(@"%@", response[ResponseMessage])];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIView hudWithMessage:BTDKString(@"%@", error.domain)];
    }];
}

@end
