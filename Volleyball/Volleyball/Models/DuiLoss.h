//
//  DuiLoss.h
//  Volleyball
//
//  Created by 张文轩 on 2018/4/30.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DuiLoss : NSObject<NSCoding>
//对失
@property (nonatomic,assign) NSInteger duiLoss;
@property (nonatomic,assign) NSInteger duiKouLoss;
@property (nonatomic,assign) NSInteger duiStartLoss;
@property (nonatomic,assign) NSInteger duiGui;
@property (nonatomic,assign) NSInteger duiElseLoss;
@end
