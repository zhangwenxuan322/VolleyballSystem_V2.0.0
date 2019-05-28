//
//  ChooseButton.h
//  Volleyball
//
//  Created by 张文轩 on 2018/4/5.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseButton : UIButton
/**
 * 左侧的选择按钮
 * 选中为橘色，未选中为白色
 * 提供事件名name
 */
- (void) setChooseButton:(NSString *)name;
@end
