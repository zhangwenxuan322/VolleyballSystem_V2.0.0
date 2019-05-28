//
//  ChangPlayerView.h
//  Volleyball
//
//  Created by 张文轩 on 2018/5/16.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCPickerView.h"
@interface ChangePlayerView : UIView
@property (nonatomic, strong) UIButton *done;//完成换人按钮
@property (nonatomic, strong) UILabel *positionPlayer;//场上球员
@property (nonatomic, strong) UILabel *changePlayer;//替补球员
- (void) createChangePlayerView:(NSMutableArray*)positionArray changePlayer: (NSMutableArray*)changePlayerArray;
@end
