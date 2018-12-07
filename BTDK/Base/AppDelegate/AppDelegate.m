//
//  AppDelegate.m
//  KaiXinQianDai
//
//  Created by xiaoning on 2018/11/26.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchViewController.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "BaseTabBarController.h"

@interface AppDelegate ()

Strong dispatch_source_t timer;
Assign NSInteger time;
Assign BOOL isTimeout;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self configKeyWindow];
    [self configUserData];
    [self fireLauchTimer];
    [self configThirdPart];
    [self requestAppConfig];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)configThirdPart {
    [self configKeyBoard];
}

- (void)configKeyBoard {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)configUserData {
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults] objectForKey:UserData_CacheKey];
    if (userData){
        [BTDKHandle shareHandle].isLogin = YES;
        [BTDKHandle shareHandle].userId = userData[@"userId"];
        [BTDKHandle shareHandle].userName = userData[@"userName"];
        [BTDKHandle shareHandle].phone = userData[@"account"];
    }
}

- (void)fireLauchTimer {
    self.time = 3; // 给最多3秒时间用户做requestAppConfig的缓冲，若请求未完成则视为请求失败，进入主页面（因为在请求未回来之前是卡在启动图的位置，所以不宜过久）
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if (self.time > 0) {
                self.time--;
            } else {
                self.time = 0;
                self.isTimeout = YES;
                if (![BTDKHandle shareHandle].isLogin) {
                    [self configLoginController];
                } else {
                    [self configTabBarRootViewController];
                }
                dispatch_source_cancel(self.timer);
            }
        });
    });
    dispatch_resume(self.timer);
}

- (void)requestAppConfig {
    @weakify(self);
    [ApiManager requestWithTpye:@"" path:s1_apps_version_model parameters:@{} success:^(NSURLSessionDataTask *task, id response) {
        @strongify(self);
        NSLog(@"%@",response);
        if (response[ResponseData]) {
            [BTDKHandle shareHandle].isMarket = ([response[ResponseData][@"model"] integerValue] == 2);
            [BTDKHandle shareHandle].isShowApplyMarket = ([response[ResponseData][@"model"] integerValue] != 2 && [response[ResponseData][@"status"] boolValue]);
        }
        dispatch_source_cancel(self.timer);
        if (!self.isTimeout) {
            if (![BTDKHandle shareHandle].isLogin) {
                [self configLoginController];
            } else {
                [self configTabBarRootViewController];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)configKeyWindow {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    [UIApplication sharedApplication].delegate.window = window;
    [self configPreLauchController];
}

- (void)configPreLauchController {
    LaunchViewController *preLauchVC = [[LaunchViewController alloc] init];
    [UIApplication sharedApplication].delegate.window.rootViewController = preLauchVC;
}

- (void)configLoginController {
    LoginViewController *loginVC = [[LoginViewController alloc] initWithSuccessBlock:^{
        [self configTabBarRootViewController];
    }];
    BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [UIApplication sharedApplication].delegate.window.rootViewController = navVC;
}

- (void)configTabBarRootViewController {
    BaseTabBarController *tabBarVC = [[BaseTabBarController alloc] init];
    [UIApplication sharedApplication].delegate.window.rootViewController = tabBarVC;
}

@end
