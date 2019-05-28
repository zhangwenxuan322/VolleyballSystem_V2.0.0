
//
//  RealTimeVC.m
//  Volleyball
//
//  Created by 张文轩 on 2018/5/22.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import "RealTimeVC.h"
#import "PlayerModel.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface RealTimeVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *data;//数据
    NSArray *precent;//比率
    int startTimes;//发球数
    int startGetTimes;//发球得分数
    int startLossTimes;//发球失分数
    int firstTimes;//一传数
    int firstDaoweiTimes;//一传到位数
    int firstShiwuTimes;//一传失误数
    int lanTimes;//拦网数
    int lanGetTimes;//拦网得分数
    int lanLossTimes;//拦网失分数
    int lanShiwuTimes;//拦网失误数
    int fangTimes;//防守数
    int fangNengTimes;//防守能攻数
    int fangShiwuTimes;//防守失误数
    int firstKouTimes;//一攻扣球数
    int firstKouGetTimes;//一攻扣得分数
    int firstKouLossTimes;//一攻扣失分数
    int fanKouTimes;//反击扣数
    int fanKouGetTimes;//反击扣得分数
    int fanKouLossTimes;//反击扣失分数
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PlayerModel *playerModel;
@end

@implementation RealTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"startTimes:%d",startTimes);
    self.tableView.tableFooterView = [[UIView alloc]init];
    data = @[@"发球得分率",@"发球失分率",@"一传到位率",@"一传失误率",@"拦网得分率",@"拦网失分率",@"防守能攻率",@"拦防失误率",@"拦防反得分率",@"一攻扣得分率",@"一攻扣失分率",@"反击扣得分率",@"反击扣失分率"];
    [self calculatePrecent];
}

- (void)viewWillAppear:(BOOL)animated{
    //取消导航栏偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void) calculatePrecent{
    for (int i = 0; i < self.detailScoreArray.count; i++) {
        self.playerModel = (PlayerModel*)self.detailScoreArray[i];
        startTimes += self.playerModel.start;//发球数
        startGetTimes += self.playerModel.startGet;//发球得分
        startLossTimes += self.playerModel.startLoss;//发球失分
        firstTimes += self.playerModel.first;//一传数
        firstDaoweiTimes += self.playerModel.firstDao;//一传到位
        firstShiwuTimes += self.playerModel.firstLoss;//一传失误
        lanTimes += self.playerModel.lan;//拦网数
        lanGetTimes += self.playerModel.lanGet;//拦网得分
        lanLossTimes += self.playerModel.lanShi;//拦网失分
        lanShiwuTimes += self.playerModel.lanGui;//拦网失误
        fangTimes += self.playerModel.fang;//防守数
        fangNengTimes += self.playerModel.fangNeng;//防守能攻
        fangShiwuTimes += self.playerModel.fangShi;//防守失误
        firstKouTimes += self.playerModel.firstKou;//一攻扣数
        firstKouGetTimes += self.playerModel.firstKouGet;//一攻扣得分
        firstKouLossTimes += self.playerModel.firstKouLoss+self.playerModel.firstKouBeiLanSi;//一攻扣失分
        fanKouTimes += self.playerModel.fanKou;//反击扣数
        fanKouGetTimes += self.playerModel.fanKouGet;//反击扣得分
        fanKouLossTimes += self.playerModel.fanKouLoss+self.playerModel.fanKouBeiLanSi;//反击扣失分
    }
    float sgp = (float)startGetTimes/(float)startTimes*100;
    if (isnan(sgp)) { sgp = 0.0; }
    float slp = (float)startLossTimes/(float)startTimes*100;
    if (isnan(slp)) { slp = 0.0; }
    float fdp = (float)firstDaoweiTimes/(float)firstTimes*100;
    if (isnan(fdp)) { fdp = 0.0; }
    float fsp = (float)firstShiwuTimes/(float)firstTimes*100;
    if (isnan(fsp)) { fsp = 0.0; }
    float lgp = (float)lanGetTimes/(float)lanTimes*100;
    if (isnan(lgp)) { lgp = 0.0; }
    float llp = (float)lanLossTimes/(float)lanTimes*100;
    if (isnan(llp)) { llp = 0.0; }
    float fnp = (float)fangNengTimes/(float)fangTimes*100;
    if (isnan(fnp)) { fnp = 0.0; }
    float lfsp = ((float)lanShiwuTimes+fangShiwuTimes)/((float)lanTimes+fangTimes)*100;
    if (isnan(lfsp)) { lfsp = 0.0; }
    float lfkgp = ((float)lanGetTimes+fanKouGetTimes)/((float)lanTimes+fangTimes+fanKouTimes)*100;
    if (isnan(lfkgp)) { lfkgp = 0.0; }
    float fkgp = (float)firstKouGetTimes/(float)firstKouTimes*100;
    if (isnan(fkgp)) { fkgp = 0.0; }
    float fklp = (float)firstKouLossTimes/(float)firstKouTimes*100;
    if (isnan(fklp)) { fklp = 0.0; }
    float fakgp = (float)fanKouGetTimes/(float)fanKouTimes*100;
    if (isnan(fakgp)) { fakgp = 0.0; }
    float faklp = (float)fanKouLossTimes/(float)fanKouTimes*100;
    if (isnan(faklp)) { faklp = 0.0; }
    NSString *startGetPer = [NSString stringWithFormat:@"%d/%d  %.1f %%",startGetTimes,startTimes,sgp];
    NSString *startLossPer = [NSString stringWithFormat:@"%d/%d  %.1f %%",startLossTimes,startTimes,slp];
    NSString *firstDaoweiPer = [NSString stringWithFormat:@"%d/%d  %.1f %%",firstDaoweiTimes,firstTimes,fdp];
    NSString *firstShiwuPer = [NSString stringWithFormat:@"%d/%d  %.1f %%",firstShiwuTimes,firstTimes,fsp];
    NSString *lanGetPer = [NSString stringWithFormat:@"%d/%d  %.1f %%",lanGetTimes,lanTimes,lgp];
    NSString *lanLossPer = [NSString stringWithFormat:@"%d/%d  %.1f %%",lanLossTimes,lanTimes,llp];
    NSString *fangNengPer = [NSString stringWithFormat:@"%d/%d  %.1f %%",fangNengTimes,fangTimes,fnp];
    NSString *lanFangShiwuPer = [NSString stringWithFormat:@"%d/%d  %.1f %%",lanShiwuTimes+fangShiwuTimes,lanTimes+fangTimes,lfsp];
    NSString *lanFangKouGetPer = [NSString stringWithFormat:@"%d/%d  %.1f %%",lanGetTimes+fanKouGetTimes,lanTimes+fangTimes+fanKouTimes,lfkgp];
    NSString *firstKouGetPer = [NSString stringWithFormat:@"%d/%d  %.1f %%",firstKouGetTimes,firstKouTimes,fkgp];
    NSString *firstKouLossPer = [NSString stringWithFormat:@"%d/%d  %.1f %%",firstKouLossTimes,firstKouTimes,fklp];
    NSString *fanKouGetPer = [NSString stringWithFormat:@"%d/%d  %.1f %%",fanKouGetTimes,fanKouTimes,fakgp];
    NSString *fanKouLossPer = [NSString stringWithFormat:@"%d/%d  %.1f %%",fanKouLossTimes,fanKouTimes,faklp];
    precent = @[startGetPer,startLossPer,firstDaoweiPer,firstShiwuPer,lanGetPer,lanLossPer,fangNengPer,lanFangShiwuPer,lanFangKouGetPer,firstKouGetPer,firstKouLossPer,fanKouGetPer,fanKouLossPer];
}

#pragma 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RealTimeIdentifier";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier
                             forIndexPath:indexPath];
    NSString *name = [NSString stringWithFormat:@"%@",data[indexPath.row]];
    cell.textLabel.text = name;
    UILabel *label = [[UILabel alloc] init]; //定义一个在cell最右边显示的label
    label.text = [NSString stringWithFormat:@"%@",precent[indexPath.row]];
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
