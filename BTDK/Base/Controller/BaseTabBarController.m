//
//  BaseTabBarController.m
//  KaiXinQianDai
//
//  Created by xiaoning on 2018/11/27.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "RecommendedVC.h"
#import "HoleViewController.h"

@interface BaseTabBarController()<UITabBarControllerDelegate>


@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.translucent = NO;
    self.delegate = self;
    [self configTabBar];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self animateTabBarButton];
}

- (void)configTabBar {
    if(![BTDKHandle shareHandle].isMarket) {
        //首页
        HomeViewController *homeVC = [[HomeViewController alloc]init];
        BaseNavigationController *homeNav = [[BaseNavigationController alloc]initWithRootViewController:homeVC];
        homeNav.tabBarItem.title = @"首页";
        homeNav.tabBarItem.image = [BTDKImage(@"sy2") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        homeNav.tabBarItem.selectedImage = [BTDKImage(@"sy") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [homeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Normal} forState:UIControlStateNormal];
        [homeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Selected} forState:UIControlStateSelected];
        
        [self addChildViewController:homeNav];
        

    }else {
        //推荐
        RecommendedVC *loanVC = [[RecommendedVC alloc]init];
        BaseNavigationController *loanNav = [[BaseNavigationController alloc]initWithRootViewController:loanVC];
        loanNav.tabBarItem.title = @"推荐";
        loanNav.tabBarItem.image = [BTDKImage(@"bottom_re2") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        loanNav.tabBarItem.selectedImage = [BTDKImage(@"bottom_re") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [loanNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Normal} forState:UIControlStateNormal];
        [loanNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Selected} forState:UIControlStateSelected];
        [self addChildViewController:loanNav];
        
        //口子
        HoleViewController *cashVC = [[HoleViewController alloc]init];
        BaseNavigationController *cashNav = [[BaseNavigationController alloc]initWithRootViewController:cashVC];
        cashNav.tabBarItem.title = @"口子";
        cashNav.tabBarItem.image = [BTDKImage(@"bottom_get2") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        cashNav.tabBarItem.selectedImage = [BTDKImage(@"bottom_get") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [cashNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Normal} forState:UIControlStateNormal];
        [cashNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Selected} forState:UIControlStateSelected];
        [self addChildViewController:cashNav];
    }
    
    //我的
    MineViewController *mineVC = [[MineViewController alloc]init];
    BaseNavigationController *mineNav = [[BaseNavigationController alloc]initWithRootViewController:mineVC];
    mineVC.tabBarItem.title = @"我的";
    mineVC.tabBarItem.image = [BTDKImage(@"bottom_me2") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.selectedImage = [BTDKImage(@"bottom_me") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [mineVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Normal} forState:UIControlStateNormal];
    [mineVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Selected} forState:UIControlStateSelected];
    [self addChildViewController:mineNav];
}

- (void)animateTabBarButton {
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            [imageView.layer addAnimation:animation forKey:nil];
            break;
        }
    }
}

@end
