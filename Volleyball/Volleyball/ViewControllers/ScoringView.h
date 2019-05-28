//
//  ViewController.h
//  Volleyball
//
//  Created by 张文轩 on 2018/3/15.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Players.h"
@interface ScoringView : UIViewController
@property (nonatomic, strong) NSMutableArray *receivePlayersArray;
@property (nonatomic, strong) NSMutableArray *receivePlayersFirstArray;
@property (nonatomic, strong) NSMutableArray *receiveFreemanArray;
@property (strong,nonatomic) Players *player;//球员图标，选择栏旁边
@end

