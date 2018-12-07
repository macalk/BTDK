//
//  LoanViewController.m
//  KaiXinQianDai
//
//  Created by xiaoning on 2018/11/29.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "RecommendedVC.h"
#import "BaseWebViewController.h"


@interface RecommendedVC ()

Strong BaseWebViewController *webVC;

@end

@implementation RecommendedVC

- (BaseWebViewController *)webVC {
    if (!_webVC) {
        _webVC = [[BaseWebViewController alloc] init];
        _webVC.url = [BTDKTool getHTMLWithPath:LoanPage_LoanMarketList_HTMLUrl];
        _webVC.marginTop = StatusBarHeight;
        _webVC.isBindRefresh = YES;
    }
    return _webVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.webVC.view];
    [self.webVC didMoveToParentViewController:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin) name:LoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogout) name:LogoutNotification object:nil];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavigationBarHidden];
    [self configStatusBarDefault];
    
}

- (void)onLogin {
    
}

- (void)onLogout {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
