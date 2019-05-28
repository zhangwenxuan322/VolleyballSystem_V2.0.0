//
//  ChangPlayerView.m
//  Volleyball
//
//  Created by 张文轩 on 2018/5/16.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import "ChangePlayerView.h"
@implementation ChangePlayerView
- (void) createChangePlayerView:(NSMutableArray*)positionArray changePlayer:(NSMutableArray *)changePlayerArray{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = self.frame.size.width*0.1/2.0;
    self.layer.masksToBounds = YES;
    //顶部banner
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.4, 0, self.frame.size.width*0.2, self.frame.size.height*0.15)];
    title.text = @"换人";
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
    //左右文字介绍
    UILabel *LabelL = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.1, self.frame.size.height*0.2, self.frame.size.width*0.3, self.frame.size.height*0.15)];
    LabelL.text = @"场上球员";
    LabelL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:LabelL];
    UILabel *LabelR = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.6, self.frame.size.height*0.2, self.frame.size.width*0.3, self.frame.size.height*0.15)];
    LabelR.text = @"场下球员";
    LabelR.textAlignment = NSTextAlignmentCenter;
    [self addSubview:LabelR];
}
@end
