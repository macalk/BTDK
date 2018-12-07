//
//  DetailViewController.m
//  BTDK
//
//  Created by xiaoning on 2018/12/6.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = self.tit;
    [self configView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configStatusBarDefault];
    [self configNavigationBarTitleWithColor:[UIColor blackColor]];
    [self configLeftBarButtonWithImage:@"return2" Title:nil];
}

- (void)configView {
    if (self.itemNum == 3) {
        [self createTableView];
    }else {
        [self viewWithTag:self.itemNum];
    }
}

- (void)viewWithTag:(NSInteger)tag {
    
    NSArray *imgArr = @[@"apply",@"bank",@"bank"];
    NSArray *titArr = @[@"您还没有相关的申请哦~",@"您还没有添加银行卡哦~",@"欢迎关注，带你解锁拿钱新姿势"];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:BTDKImage(imgArr[tag])];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(96);
        make.size.mas_offset(CGSizeMake(210, 143));
    }];
    UILabel *subLabel = [[UILabel alloc]init];
    subLabel.textColor = BTDKHexColor(@"#cecece");
    subLabel.font = BTDKFont(15);
    subLabel.text = [NSString stringWithFormat:@"%@",titArr[tag]];
    [self.view addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imgView.mas_bottom).with.offset(25);
    }];
}

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabBarHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 56;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = BTDKHexColor(@"#f4f4f4");
    [self.view addSubview:tableView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor = BTDKHexColor(@"#f4f4f4");
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0) {
        cell.imageView.image = BTDKImage(@"version");
        [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(20);
            make.centerY.equalTo(cell.contentView);
        }];
        cell.textLabel.text = @"当前版本";
        cell.textLabel.textColor = BTDKHexColor(@"#2e2e2e");
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(cell.imageView.mas_right).with.offset(13);
        }];
        cell.detailTextLabel.text = AppVersion;

    }else {
        cell.textLabel.text = @"安全退出";
        cell.textLabel.font = BTDKFont(18);
        cell.textLabel.textColor = BTDKHexColor(@"#ff472e");
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
        }];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserData_CacheKey];
        [BTDKHandle shareHandle].isLogin = NO;
        [BTDKHandle shareHandle].userId = nil;
        [BTDKHandle shareHandle].userName = nil;
        [BTDKHandle shareHandle].phone = nil;
        [BTDKTool jumpLoginWithSuccessBlock:^{
            [self.navigationController popToRootViewControllerAnimated:NO];
            UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            if (tabBarController) {
                tabBarController.selectedIndex = 0;
            }
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
    }
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
