//
//  SettingVC.m
//  Volleyball
//
//  Created by 张文轩 on 2018/5/22.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import "SettingVC.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define vCFBundleShortVersionStr [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
@interface SettingVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self StatusBarAndNavigationBarInit];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
    //取消导航栏偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
}


//导航条初始化
- (void) StatusBarAndNavigationBarInit{
    self.navigationItem.title = @"设置";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                    NSFontAttributeName:[UIFont systemFontOfSize:16]
                                                                    };
}

#pragma 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SettingIdentifier";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier
                             forIndexPath:indexPath];
    //    NSString *name = [NSString stringWithFormat:@"第%ld场比赛",indexPath.row+1];
    cell.textLabel.text = @"版本";
    UILabel *label = [[UILabel alloc] init]; //定义一个在cell最右边显示的label
    label.text = vCFBundleShortVersionStr;
    label.font = [UIFont boldSystemFontOfSize:17];
    [label sizeToFit];
    label.backgroundColor = [UIColor clearColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        label.frame =CGRectMake(SCREEN_WIDTH - label.frame.size.width - 10,\
                                12, label.frame.size.width, label.frame.size.height);
    } else {
        label.frame =CGRectMake(SCREEN_WIDTH - label.frame.size.width - 20,\
                                12, label.frame.size.width, label.frame.size.height);
    }
    [cell.contentView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    cell.userInteractionEnabled = NO;
    return cell;
}

#pragma 代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
@end
