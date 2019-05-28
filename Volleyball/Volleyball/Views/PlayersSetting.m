//
//  PlayersSetting.m
//  Volleyball
//
//  Created by 张文轩 on 2018/5/2.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import "PlayersSetting.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@implementation PlayersSetting

- (void)creatSettingView:(int)number withName:(NSString*)name andPosition:(NSString*)position{
    UITextField *numberLabel = [[UITextField alloc]init];
    self.numberLabel = numberLabel;
    numberLabel.delegate = self;
    numberLabel.keyboardType = UIKeyboardTypeNumberPad;
    numberLabel.borderStyle = UITextBorderStyleRoundedRect;
    numberLabel.font = [UIFont systemFontOfSize:17.0];
    numberLabel.adjustsFontSizeToFitWidth = YES;
    float width = self.frame.size.width * 0.2;
    numberLabel.frame = CGRectMake(0, 0, width, width);
    if (number == -1) {
        numberLabel.text = [NSString stringWithFormat:@""];
    }else{
        numberLabel.text = [NSString stringWithFormat:@"%d",number];
    }
    numberLabel.layer.cornerRadius = width/2;
    numberLabel.layer.masksToBounds = YES;
    numberLabel.backgroundColor = [UIColor grayColor];
    numberLabel.adjustsFontSizeToFitWidth = YES;
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:numberLabel];
    UITextField *nameTF = [[UITextField alloc]init];
    self.nameTF = nameTF;
    nameTF.frame = CGRectMake(width+10, 0, self.frame.size.width*0.4-15, self.frame.size.height);
    nameTF.text = name;
    nameTF.textAlignment = NSTextAlignmentCenter;
    UIImage *textFieldBgImage = [UIImage imageNamed:@"名字下划线"];
    [nameTF setBackground:textFieldBgImage];
    [self addSubview:nameTF];
    UILabel *positionLabel = [[UILabel alloc]init];
    self.position = positionLabel;
    positionLabel.frame = CGRectMake(self.frame.size.width*0.6, 0, self.frame.size.width*0.4, self.frame.size.height*0.8);
    positionLabel.text = position;
    positionLabel.layer.cornerRadius = 5;
    positionLabel.layer.masksToBounds = YES;
    positionLabel.backgroundColor = [UIColor grayColor];
    positionLabel.textColor = [UIColor whiteColor];
    positionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:positionLabel];
}
- (UIColor*) refreshColor:(NSString *)position{
    NSArray *array = @[@"主攻",@"副攻",@"二传",@"接应",@"自由人"];
    int select = 0;
    UIColor *color;
    for (int i = 0; i < array.count; i++) {
        if ([position isEqualToString:array[i]]) {
            select = i;
        }
    }
    switch (select) {
        case 0:
            color = [UIColor colorWithRed:253.0/255.0 green:63.0/255.0 blue:93.0/255.0 alpha:1.0];
            [self setColor:color];
            break;
        case 1:
            color = [UIColor colorWithRed:34.0/255.0 green:168.0/255.0 blue:220.0/255.0 alpha:1.0];
            [self setColor:color];
            break;
        case 2:
            color = [UIColor colorWithRed:255.0/255.0 green:149.0/255.0 blue:2.0/255.0 alpha:1.0];
            [self setColor:color];
            break;
        case 3:
            color = [UIColor colorWithRed:98.0/255.0 green:218.0/255.0 blue:58.0/255.0 alpha:1.0];
            [self setColor:color];
            break;
        case 4:
            color = [UIColor colorWithRed:136.0/255.0 green:99.0/255.0 blue:255.0/255.0 alpha:1.0];
            [self setColor:color];
            break;
        default:
            break;
    }
    return color;
}

- (void) setColor:(UIColor*)color{
    self.numberLabel.backgroundColor = color;
    self.position.backgroundColor = color;
}
//代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.numberLabel == textField) {
        return [self validateNumber:string];
    }
    return YES;
}
//限制只能输入数字
- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}
@end
