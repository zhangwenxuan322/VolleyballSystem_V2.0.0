//
//  TerminalChangVC.h
//  Volleyball
//
//  Created by 张文轩 on 2018/5/15.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TerminalChangVC : UIViewController
@property (nonatomic) BOOL isClickChangeBtn;
@property (nonatomic, strong) NSMutableArray *receivePlayersArray;
@property (nonatomic, strong) NSMutableArray *positionArray;
@end
