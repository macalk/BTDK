//
//  BaseWebViewController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "BaseWebViewController.h"

/* ----- 这里写支持的js message name ----- !!!别忘了把定义的JSMessage加入到下面的jsMessageNames中*/
#define JSMessage_JumpLogin @"JumpLogin"
#define JSMessage_GoBack @"GoBack"
/* ----- 这里写支持的js message name ----- */

@implementation ScriptMessageHandler

- (NSArray *)jsMessageNames
{
    return @[
             JSMessage_JumpLogin,
             JSMessage_GoBack,
             ];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:JSMessage_JumpLogin]) {
        [BTDKTool jumpLogin];
    }
    else if ([message.name isEqualToString:JSMessage_GoBack]) {
        UIViewController *controller = [BTDKTool getViewController];
        if (controller && [controller isKindOfClass:[BaseWebViewController class]]) {
            BaseWebViewController *webViewController = (BaseWebViewController *)controller;
            [webViewController back];
        }
    }
}

@end


@interface BaseWebViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) ScriptMessageHandler *jsHandler;
@property (nonatomic, assign) BOOL isSelfLoad;

@end

@implementation BaseWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.webTitle ?: @"加载中...";
    
    self.jsHandler = [[ScriptMessageHandler alloc] init];
    self.jsHandler.webViewController = self;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[self webViewConfiguration]];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    if (self.isBindRefresh) {
        [self.webView.scrollView bindHeadRefreshHandler:^{
            [self loadHtml];
        } themeColor:[UIColor colorWithHexString:@"#F5E3CB"] refreshStyle:KafkaRefreshStyleNative];
    }

    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.progressTintColor = [UIColor colorWithHexString:@"#F5E3CB"];
    self.progressView.trackTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.progressView.userInteractionEnabled = NO;
    self.progressView.alpha = 0;
    self.progressView.progress = 0;
    [self.view addSubview:self.progressView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    [self loadHtml];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.marginTop ? CGRectMake(self.view.left, self.view.top+self.marginTop, self.view.width, self.view.height-self.marginTop) : self.view.bounds;
    self.progressView.width = self.webView.width;
    self.progressView.left = 0;
    self.progressView.top = 0;
}

- (void)loadHtml {
    if (self.webView.loading) {
        return;
    }
    self.isSelfLoad = YES;
    [self AppendCommonParamters];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)AppendCommonParamters {
    if ([self.url hasPrefix:BaseHTMLUrl]) {
        if ([self.url containsString:@".html"]) {
            NSString *htmlUrl = [self.url substringToIndex:[self.url rangeOfString:@".html"].location+[self.url rangeOfString:@".html"].length];
            NSString *paramUrl = [self.url substringFromIndex:[self.url rangeOfString:@".html"].location+[self.url rangeOfString:@".html"].length];
            if ([paramUrl hasPrefix:@"?"]) {
                paramUrl = [paramUrl substringFromIndex:1];
            }
            
            NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
            if (!NULLString(paramUrl)) {
                if ([paramUrl containsString:@"&"]) {
                    NSArray *keyValues = [paramUrl componentsSeparatedByString:@"&"];
                    if (keyValues.count) {
                        for (NSString *keyValuePair in keyValues) {
                            if (!NULLString(keyValuePair) && [keyValuePair containsString:@"="]) {
                                NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
                                [queryDic setObject:pairComponents[1] forKey:pairComponents[0]];
                            }
                        }
                    }
                } else {
                    if ([paramUrl containsString:@"="]) {
                        NSArray *pairComponents = [paramUrl componentsSeparatedByString:@"="];
                        [queryDic setObject:pairComponents[1] forKey:pairComponents[0]];
                    }
                }
            }
            
            [queryDic setObject:[BTDKHandle shareHandle].userId?:@"" forKey:@"userId"];
            
            __block NSString *webUrl = [htmlUrl stringByAppendingString:@"?"];
            [queryDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                webUrl = [webUrl stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, obj]];
            }];
            if ([[webUrl substringFromIndex:webUrl.length-1] isEqualToString:@"&"]) {
                webUrl = [webUrl substringToIndex:webUrl.length-1];
            }
            if ([[webUrl substringFromIndex:webUrl.length-1] isEqualToString:@"?"]) {
                webUrl = [webUrl substringToIndex:webUrl.length-1];
            }
            self.url = [webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
}

#pragma mark - Actions
- (void)leftBarButtonAciton {
    [self back];
}

- (void)back
{
    if([self.webView canGoBack])
    {
        [self.webView goBack];
    }
    else
    {
        [self close];
    }
}

- (void)close
{
    if(self.navigationController.viewControllers.count == 1)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *alertActionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:alertActionCancel];
    [alertController addAction:alertActionOK];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields.firstObject;
        completionHandler(textField.text);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (navigationAction.targetFrame == nil)
    {
        [webView loadRequest:navigationAction.request];
    }
    
    //应用下载协议
    NSString *url = navigationAction.request.URL.absoluteString;
    if ([url containsString:@"itms-services"] || [url containsString:@"itunes.apple"] || [url containsString:@"fir.im"] || [url containsString:@"pgyer.com"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    if ([self.url hasPrefix:BaseHTMLUrl]) {
        if (!self.isSelfLoad) {
            NSString *url = navigationResponse.response.URL.absoluteString;
            if ([self.url isEqualToString:url]) {
                BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
                webVC.url = url;
                webVC.hidesBottomBarWhenPushed = YES;
                [[BTDKTool getViewController].navigationController pushViewController:webVC animated:YES];
                decisionHandler(WKNavigationResponsePolicyCancel);
            } else {
                if (@available(iOS 9.0, *)) {
                    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
                    [[BTDKTool getViewController] presentViewController:safariVC animated:YES completion:nil];
                    decisionHandler(WKNavigationResponsePolicyCancel);
                } else {
                    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
                    webVC.url = url;
                    webVC.hidesBottomBarWhenPushed = YES;
                    [[BTDKTool getViewController].navigationController pushViewController:webVC animated:YES];
                    decisionHandler(WKNavigationResponsePolicyCancel);
                }
            }
        } else {
            self.isSelfLoad = NO;
            decisionHandler(WKNavigationResponsePolicyAllow);
        }
    } else {
       decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    @weakify(self);
    [UIView animateWithDuration:0.25
                     animations:^{
                         @strongify(self);
                         self.progressView.alpha = 1;
                     }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    @weakify(self);
    [UIView animateWithDuration:0.25
                     animations:^{
                         @strongify(self);
                         self.progressView.alpha = 0;
                     }];
    if (!webView.isLoading) {
        self.progressView.progress = 0;
    }
    [self.webView.scrollView.headRefreshControl endRefreshing];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    @weakify(self);
    [UIView animateWithDuration:0.25
                     animations:^{
                         @strongify(self);
                         self.progressView.alpha = 0;
                     }];
    [self.webView.scrollView.headRefreshControl endRefreshing];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    @weakify(self);
    [UIView animateWithDuration:0.25
                     animations:^{
                         @strongify(self);
                         self.progressView.alpha = 0;
                     }];
    [self.webView.scrollView.headRefreshControl endRefreshing];
}

#pragma mark - Private Method

- (WKWebViewConfiguration *)webViewConfiguration
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    for(NSString *name in self.jsHandler.jsMessageNames)
    {
        [configuration.userContentController addScriptMessageHandler:self.jsHandler name:name];
    }
    return configuration;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        [self.progressView setProgress:[change[@"new"] doubleValue] animated:YES];
    }
    else if ([keyPath isEqualToString:@"title"]){
        if (!self.webTitle) {
            self.navigationItem.title = change[@"new"];
        }
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    for(NSString *name in self.jsHandler.jsMessageNames)
    {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:name];
    }
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
