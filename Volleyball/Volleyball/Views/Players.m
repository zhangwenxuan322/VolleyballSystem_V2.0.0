//
//  Players.m
//  Volleyball
//
//  Created by 张文轩 on 2018/3/19.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import "Players.h"

@implementation Players

- (void) setPlayerNumber:(NSString*)number playername:(NSString*)name playerposition:(UIColor*)position{
    self.startX = self.frame.origin.x;
    self.startY = self.frame.origin.y;
    self.startWidth = self.frame.size.width;
    self.startHeight = self.frame.size.height;
    self.endX = self.frame.origin.x;
    self.endY = self.frame.origin.y;
    self.endWidth = self.frame.size.width;
    self.endHeight = self.frame.size.height;
    _playerName = name;
    _playerNumber = number;
    //号码和站位
    UILabel *circle = [[UILabel alloc]init];
    self.number = circle;
    circle.frame = CGRectMake(self.frame.size.width*0.17, 0, self.frame.size.width*0.66, self.frame.size.height*0.66);
    circle.layer.cornerRadius=circle.bounds.size.width/2;
    circle.layer.masksToBounds=YES;
    circle.textAlignment = NSTextAlignmentCenter;
    circle.text = number;
    circle.textColor = [UIColor whiteColor];
    circle.backgroundColor = position;
    [self addSubview:circle];
    //姓名
    UILabel *Name = [[UILabel alloc]init];
    self.name = Name;
    Name.frame = CGRectMake(0, self.frame.size.height*0.66, self.frame.size.width, self.frame.size.height*0.34);
    Name.text = name;
    Name.textAlignment = NSTextAlignmentCenter;
    Name.adjustsFontSizeToFitWidth = YES;
    [self addSubview:Name];
}

@end
