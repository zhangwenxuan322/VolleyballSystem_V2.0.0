//
//  PlayerModel.h
//  Volleyball
//
//  Created by 张文轩 on 2018/4/30.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerModel : NSObject<NSCoding>
//球员姓名
@property (nonatomic,strong) NSString *name;
//球员号码
@property (nonatomic,assign) NSString *number;
//球员站位
@property (nonatomic,strong) NSString *position;
//发球
@property (nonatomic,assign) NSInteger start;
@property (nonatomic,assign) NSInteger startGet;
@property (nonatomic,assign) NSInteger startPo;
@property (nonatomic,assign) NSInteger startNeng;
@property (nonatomic,assign) NSInteger startDao;
@property (nonatomic,assign) NSInteger startLoss;
//一传
@property (nonatomic,assign) NSInteger first;
@property (nonatomic,assign) NSInteger firstDao;
@property (nonatomic,assign) NSInteger firstNeng;
@property (nonatomic,assign) NSInteger firstPo;
@property (nonatomic,assign) NSInteger firstLoss;
//一攻扣球
@property (nonatomic,assign) NSInteger firstKou;
@property (nonatomic,assign) NSInteger firstKouGet;
@property (nonatomic,assign) NSInteger firstKouBeiFangQi;
@property (nonatomic,assign) NSInteger firstKouBeiLanSi;
@property (nonatomic,assign) NSInteger firstKouLoss;
//拦网
@property (nonatomic,assign) NSInteger lan;
@property (nonatomic,assign) NSInteger lanGet;
@property (nonatomic,assign) NSInteger lanQi;
@property (nonatomic,assign) NSInteger lanHui;
@property (nonatomic,assign) NSInteger lanShi;
@property (nonatomic,assign) NSInteger lanGui;
//防守
@property (nonatomic,assign) NSInteger fang;
@property (nonatomic,assign) NSInteger fangDao;
@property (nonatomic,assign) NSInteger fangNeng;
@property (nonatomic,assign) NSInteger fangPo;
@property (nonatomic,assign) NSInteger fangShi;
//反击扣球
@property (nonatomic,assign) NSInteger fanKou;
@property (nonatomic,assign) NSInteger fanKouGet;
@property (nonatomic,assign) NSInteger fanKouBeiFangQi;
@property (nonatomic,assign) NSInteger fanKouBeiLanSi;
@property (nonatomic,assign) NSInteger fanKouLoss;
//二传及其他
@property (nonatomic,assign) NSInteger second;
@property (nonatomic,assign) NSInteger secondGet;
@property (nonatomic,assign) NSInteger secondLoss;
@end
