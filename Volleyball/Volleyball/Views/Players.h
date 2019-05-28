//
//  Players.h
//  Volleyball
//
//  Created by 张文轩 on 2018/3/19.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Players : UIView

/**
  * 球员号码和球员姓名的组合，上部圆圈内是号码，下方是姓名，颜色代表站位
  * 提供球员号码，姓名，颜色
  * 需要先初始化frame
  */
@property (nonatomic) float startX;
@property (nonatomic) float startY;
@property (nonatomic) float startWidth;
@property (nonatomic) float startHeight;
@property (nonatomic) float endX;
@property (nonatomic) float endY;
@property (nonatomic) float endWidth;
@property (nonatomic) float endHeight;
@property (copy) NSString *playerNumber;
@property (copy) NSString *playerName;
@property (nonatomic, strong) UILabel *number;
@property (nonatomic, strong) UILabel *name;
- (void) setPlayerNumber:(NSString*)number playername:(NSString*)name playerposition:(UIColor*)position;
@end
