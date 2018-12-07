//
//  MineViewController.m
//  KaiXinQianDai
//
//  Created by xiaoning on 2018/11/29.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "MineViewController.h"
#import "MineView.h"
#import "DetailViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

Strong UITableView *tableView;
Copy NSArray *cellTitArr;
Copy NSArray *cellImgArr;

@end

@implementation MineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的";
    
    [self configData];
    [self configView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavigationBarShow];
    [self configNavigationBarImage:[UIImage new]];
    [self configNavigationBarShadow:[UIImage new]];
    [self configStatusBarLight];
    [self configNavigationBarTitleWithColor:BTDKHexColor(@"#ffffff")];

}

- (void)configData {
    self.cellTitArr = [NSArray arrayWithObjects:@"我的申请",@"银行卡管理",@"关于白条贷款",@"设置", nil];
    self.cellImgArr = [NSArray arrayWithObjects:@"applyfor",@"Bankcard",@"about",@"set", nil];
}
- (void)configView {
    MineView *view = [[MineView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 295)];
    [self.view addSubview:view];
    [self createTableView];
}

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 295, ScreenWidth, ScreenHeight-TabBarHeight-295) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 56;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    self.tableView = tableView;
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
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.imageView.image = BTDKImage(self.cellImgArr[indexPath.section*2+indexPath.row]);
    [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).with.offset(20);
        make.centerY.equalTo(cell.contentView);
    }];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.cellTitArr[indexPath.section*2+indexPath.row]];
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(cell.imageView.mas_right).with.offset(13);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = BTDKHexColor(@"#f4f4f4");
    [cell.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView);
        make.bottom.equalTo(cell.contentView);
        make.size.mas_offset(CGSizeMake(ScreenWidth, 1));
    }];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *vc = [[DetailViewController alloc]init];
    vc.itemNum = indexPath.section*2+indexPath.row;
    vc.tit = [NSString stringWithFormat:@"%@",self.cellTitArr[indexPath.section*2+indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
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
