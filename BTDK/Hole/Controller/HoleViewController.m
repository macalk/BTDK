//
//  LoanViewController.m
//  KaiXinQianDai
//
//  Created by xiaoning on 2018/11/29.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "HoleViewController.h"
#import "BaseWebViewController.h"

@interface HoleViewController ()

Strong BaseWebViewController *webVC;

@end

@implementation HoleViewController

- (BaseWebViewController *)webVC {
    if (!_webVC) {
        _webVC = [[BaseWebViewController alloc] init];
        _webVC.url = [BTDKTool getHTMLWithPath:MarketPage_LoanMarketList_HTMLUrl];
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
    
    self.navigationItem.title = nil;
    
    [self.view addSubview:self.webVC.view];
    [self.webVC didMoveToParentViewController:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin) name:LoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogout) name:LogoutNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configStatusBarDefault];
    [self configNavigationBarHidden];
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
