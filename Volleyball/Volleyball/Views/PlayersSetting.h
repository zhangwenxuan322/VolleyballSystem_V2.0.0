//
//  PlayersSetting.h
//  Volleyball
//
//  Created by 张文轩 on 2018/5/2.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZNumberField.h"
@interface PlayersSetting : UIView<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *numberLabel;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UILabel *position;
- (void) creatSettingView:(int)number withName:(NSString*)name andPosition:(NSString*)position;
- (UIColor*) refreshColor:(NSString*)position;
@end
