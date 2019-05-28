//
//  HomePageVC.m
//  Volleyball
//
//  Created by 张文轩 on 2018/5/17.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import "HomePageVC.h"

@interface HomePageVC ()

@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self StatusBarAndNavigationBarInit];
}

//导航条初始化
- (void) StatusBarAndNavigationBarInit{
    self.navigationItem.title = @"首页";
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                    NSFontAttributeName:[UIFont systemFontOfSize:16]
                                                                    };
}
- (IBAction)alert:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"该板块未开放"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              NSLog(@"action = %@", action);
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
