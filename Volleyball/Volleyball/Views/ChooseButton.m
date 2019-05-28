//
//  ChooseButton.m
//  Volleyball
//
//  Created by 张文轩 on 2018/4/5.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import "ChooseButton.h"

@implementation ChooseButton

- (void) setChooseButton:(NSString *)name {
    //正常文字
    UILabel *norLabel = [[UILabel alloc]initWithFrame:self.frame];
    norLabel.text = name;
    norLabel.textColor = [UIColor whiteColor];
    norLabel.textAlignment = NSTextAlignmentCenter;
    norLabel.font = [UIFont systemFontOfSize:25];
    norLabel.adjustsFontSizeToFitWidth = YES;
    UIImage *norImg = [self imageWithUIView:norLabel];
    [self setImage:norImg forState:UIControlStateNormal];
    //选中文字
    UILabel *selectedLabel = [[UILabel alloc]initWithFrame:self.frame];
    selectedLabel.text = name;
    selectedLabel.textColor = [UIColor orangeColor];
    selectedLabel.textAlignment = NSTextAlignmentCenter;
    selectedLabel.font = [UIFont systemFontOfSize:25];
    selectedLabel.adjustsFontSizeToFitWidth = YES;
    UIImage *selectedImg = [self imageWithUIView:selectedLabel];
    [self setImage:selectedImg forState:UIControlStateSelected];
    //切换状态
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

//状态切换
- (void)buttonClick:(UIButton *)button {
    button.selected = !button.selected;
}

//Label转Image
- (UIImage*) imageWithUIView:(UIView*) view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}
@end
