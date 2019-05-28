
//
//  PlayerModel.m
//  Volleyball
//
//  Created by 张文轩 on 2018/4/30.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import "PlayerModel.h"
#define Name @"name"
#define Number @"number"
#define Position @"position"
#define Start @"start"
#define StartGet @"startGet"
#define StartPo @"startPo"
#define StartNeng @"startNeng"
#define StartDao @"startDao"
#define StartLoss @"startLoss"
#define First @"first"
#define FirstDao @"firstDao"
#define FirstNeng @"firstNeng"
#define FirstPo @"firstPo"
#define FirstLoss @"firstLoss"
#define FirstKou @"firstKou"
#define FirstKouGet @"firstKouGet"
#define FirstKouBeiFangQi @"firstKouBeiFangQi"
#define FirstKouBeiLanSi @"firstKouBeiLanSi"
#define FirstKouLoss @"firstKouLoss"
#define Lan @"lan"
#define LanGet @"lanGet"
#define LanQi @"lanQi"
#define LanHui @"lanHui"
#define LanShi @"lanShi"
#define LanGui @"lanGui"
#define Fang @"fang"
#define FangDao @"fangDao"
#define FangNeng @"fangNeng"
#define FangPo @"fangPo"
#define FangShi @"fangShi"
#define FanKou @"fanKou"
#define FanKouGet @"fanKouGet"
#define FanKouBeiFangQi @"fanKouBeiFangQi"
#define FanKouBeiLanSi @"fanKouBeiLanSi"
#define FanKouLoss @"fanKouLoss"
#define Second @"second"
#define SecondGet @"secondGet"
#define SecondLoss @"secondLoss"
@implementation PlayerModel
//需要实现NSCoding中的协议的两个方法
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        self.name = [aDecoder decodeObjectForKey:Name];
        self.number = [aDecoder decodeObjectForKey:Number];
        self.position = [aDecoder decodeObjectForKey:Position];
        self.start = [[aDecoder decodeObjectForKey:Start]integerValue];
        self.startGet = [[aDecoder decodeObjectForKey:StartGet]integerValue];
        self.startPo = [[aDecoder decodeObjectForKey:StartPo]integerValue];
        self.startNeng = [[aDecoder decodeObjectForKey:StartNeng]integerValue];
        self.startDao = [[aDecoder decodeObjectForKey:StartDao]integerValue];
        self.startLoss = [[aDecoder decodeObjectForKey:StartLoss]integerValue];
        self.first = [[aDecoder decodeObjectForKey:First]integerValue];
        self.firstDao = [[aDecoder decodeObjectForKey:FirstDao]integerValue];
        self.firstNeng = [[aDecoder decodeObjectForKey:FirstNeng]integerValue];
        self.firstPo = [[aDecoder decodeObjectForKey:FirstPo]integerValue];
        self.firstLoss = [[aDecoder decodeObjectForKey:FirstLoss]integerValue];
        self.firstKou = [[aDecoder decodeObjectForKey:FirstKou]integerValue];
        self.firstKouGet = [[aDecoder decodeObjectForKey:FirstKouGet]integerValue];
        self.firstKouBeiFangQi = [[aDecoder decodeObjectForKey:FirstKouBeiFangQi]integerValue];
        self.firstKouBeiLanSi = [[aDecoder decodeObjectForKey:FirstKouBeiLanSi]integerValue];
        self.firstKouLoss = [[aDecoder decodeObjectForKey:FirstKouLoss]integerValue];
        self.lan = [[aDecoder decodeObjectForKey:Lan]integerValue];
        self.lanGet = [[aDecoder decodeObjectForKey:LanGet]integerValue];
        self.lanQi = [[aDecoder decodeObjectForKey:LanQi]integerValue];
        self.lanHui = [[aDecoder decodeObjectForKey:LanHui]integerValue];
        self.lanShi = [[aDecoder decodeObjectForKey:LanShi]integerValue];
        self.lanGui = [[aDecoder decodeObjectForKey:LanGui]integerValue];
        self.fang = [[aDecoder decodeObjectForKey:Fang]integerValue];
        self.fangDao = [[aDecoder decodeObjectForKey:FangDao]integerValue];
        self.fangNeng = [[aDecoder decodeObjectForKey:FangNeng]integerValue];
        self.fangPo = [[aDecoder decodeObjectForKey:FangPo]integerValue];
        self.fangShi = [[aDecoder decodeObjectForKey:FangShi]integerValue];
        self.fanKou = [[aDecoder decodeObjectForKey:FanKou]integerValue];
        self.fanKouGet = [[aDecoder decodeObjectForKey:FanKouGet]integerValue];
        self.fanKouBeiFangQi = [[aDecoder decodeObjectForKey:FanKouBeiFangQi]integerValue];
        self.fanKouBeiLanSi = [[aDecoder decodeObjectForKey:FanKouBeiLanSi]integerValue];
        self.fanKouLoss = [[aDecoder decodeObjectForKey:FanKouLoss]integerValue];
        self.second = [[aDecoder decodeObjectForKey:Second]integerValue];
        self.secondGet = [[aDecoder decodeObjectForKey:SecondGet]integerValue];
        self.secondLoss = [[aDecoder decodeObjectForKey:SecondLoss]integerValue];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:Name];
    [aCoder encodeObject:self.number forKey:Number];
    [aCoder encodeObject:self.position forKey:Position];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.start] forKey:Start];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.startGet] forKey:StartGet];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.startPo] forKey:StartPo];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.startNeng] forKey:StartNeng];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.startDao] forKey:StartDao];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.startLoss] forKey:StartLoss];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.first] forKey:First];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.firstDao] forKey:FirstDao];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.firstNeng] forKey:FirstNeng];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.firstPo] forKey:FirstPo];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.firstLoss] forKey:FirstLoss];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.firstKou] forKey:FirstKou];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.firstKouGet] forKey:FirstKouGet];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.firstKouBeiFangQi] forKey:FirstKouBeiFangQi];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.firstKouBeiLanSi] forKey:FirstKouBeiLanSi];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.firstKouLoss] forKey:FirstKouLoss];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.lan] forKey:Lan];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.lanGet] forKey:LanGet];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.lanQi] forKey:LanQi];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.lanHui] forKey:LanHui];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.lanShi] forKey:LanShi];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.lanGui] forKey:LanGui];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fang] forKey:Fang];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fangDao] forKey:FangDao];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fangNeng] forKey:FangNeng];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fangPo] forKey:FangPo];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fangShi] forKey:FangShi];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fanKou] forKey:FanKou];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fanKouGet] forKey:FanKouGet];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fanKouBeiFangQi] forKey:FanKouBeiFangQi];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fanKouBeiLanSi] forKey:FanKouBeiLanSi];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fanKouLoss] forKey:FanKouLoss];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.second] forKey:Second];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.secondGet] forKey:SecondGet];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.secondLoss] forKey:SecondLoss];
}

#pragma mark NSCoping
- (id)copyWithZone:(NSZone *)zone {
    PlayerModel *copy = [[[self class] allocWithZone:zone] init];
    copy.name = [self.name copyWithZone:zone];
    copy.number = self.number;
    copy.position = self.position;
    copy.start = self.start;
    copy.startGet = self.startGet;
    copy.startPo = self.startPo;
    copy.startNeng = self.startNeng;
    copy.startDao = self.startDao;
    copy.startLoss = self.startLoss;
    copy.first = self.first;
    copy.firstDao = self.firstDao;
    copy.firstNeng = self.firstNeng;
    copy.firstPo = self.firstPo;
    copy.firstLoss = self.firstLoss;
    copy.firstKou = self.firstKou;
    copy.firstKouGet = self.firstKouGet;
    copy.firstKouBeiFangQi = self.firstKouBeiFangQi;
    copy.firstKouBeiLanSi = self.firstKouBeiLanSi;
    copy.firstKouLoss = self.firstKouLoss;
    copy.lan = self.lan;
    copy.lanGet = self.lanGet;
    copy.lanQi = self.lanQi;
    copy.lanHui = self.lanHui;
    copy.lanShi = self.lanShi;
    copy.lanGui = self.lanGui;
    copy.fang = self.fang;
    copy.fangDao = self.fangDao;
    copy.fangNeng = self.fangNeng;
    copy.fangPo = self.fangPo;
    copy.fangShi = self.fangShi;
    copy.fanKou = self.fanKou;
    copy.fanKouGet = self.fanKouGet;
    copy.fanKouBeiFangQi = self.fanKouBeiFangQi;
    copy.fanKouBeiLanSi = self.fanKouBeiLanSi;
    copy.fanKouLoss = self.fanKouLoss;
    copy.second = self.second;
    copy.secondGet = self.secondGet;
    copy.secondLoss = self.secondLoss;
    return copy;
}
//重写构造函数
- (id)init{
    if (self=[super init]) {
        self.name = @"";
        self.number = 0;
        self.position = @"";
    }
    return self;
}
@end
