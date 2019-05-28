//
//  TerminalChangVC.m
//  Volleyball
//
//  Created by 张文轩 on 2018/5/15.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import "TerminalChangVC.h"
#import "Players.h"
#import "positionLabel.h"
#import "ScoringView.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface TerminalChangVC (){
    float x1;
    float x2;
    float x3;
    float x4;
    float y1;
    float y2;
    float y3;
}
@property (nonatomic, strong) Players *dropPlayers;
@property (nonatomic, strong) UIView *HLView;
@property (nonatomic, strong) positionLabel *positionView;
@end

@implementation TerminalChangVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseViewInit];
}

//基础视图初始化
- (void) baseViewInit{
    //顶部banner
    UILabel *banner = [[UILabel alloc]init];
    banner.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64.0/768.0*SCREEN_HEIGHT);
    banner.backgroundColor = [UIColor blackColor];
    banner.text = @"球员站位设置";
    banner.textColor = [UIColor whiteColor];
    banner.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:banner];
    //球场
    UIImageView *court = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.3, 94.0/768.0 * SCREEN_HEIGHT, SCREEN_WIDTH*0.4, SCREEN_HEIGHT*0.83)];
    court.image = [UIImage imageNamed:@"沙盘-竖"];
    [self.view addSubview:court];
    //高亮部分
    UIView *HLView = [[UIView alloc]init];
    self.HLView = HLView;
    HLView.frame = CGRectMake(court.frame.size.width*0.145, court.frame.size.height*0.5, court.frame.size.width*0.69, court.frame.size.height*0.4);
//    HLView.backgroundColor = [UIColor yellowColor];
    [court addSubview:HLView];
    x1 = self.HLView.frame.origin.x+SCREEN_WIDTH*0.3;
    x2 = self.HLView.frame.origin.x+self.HLView.frame.size.width*0.33+SCREEN_WIDTH*0.3;
    x3 = self.HLView.frame.origin.x+self.HLView.frame.size.width*0.66+SCREEN_WIDTH*0.3;
    x4 = self.HLView.frame.origin.x+self.HLView.frame.size.width+SCREEN_WIDTH*0.3;
    y1 = self.HLView.frame.origin.y+94.0/768.0 * SCREEN_HEIGHT;
    y2 = self.HLView.frame.origin.y+self.HLView.frame.size.height*0.5+94.0/768.0 * SCREEN_HEIGHT;
    y3 = self.HLView.frame.origin.y+self.HLView.frame.size.height+94.0/768.0 * SCREEN_HEIGHT;
    NSArray *positionArray = @[@"4",@"3",@"2",@"5",@"6",@"1"];
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j< 3; j++) {
            positionLabel *positionView = [[positionLabel alloc]init];
            self.positionView = positionView;
            positionView.frame = CGRectMake(j*HLView.frame.size.width*0.33, i*HLView.frame.size.height*0.5, HLView.frame.size.width*0.33, HLView.frame.size.height*0.5);
            positionView.text = [NSString stringWithFormat:@"%@",positionArray[i*3+j]];
            positionView.textAlignment = NSTextAlignmentCenter;
            positionView.font = [UIFont systemFontOfSize:17.0];
            positionView.tag = (i*3+j+1)+200;
            [self.HLView addSubview:positionView];
        }
    }
    //可拖动球员
    int players = 14;
    float dropX = SCREEN_WIDTH*0.15;
    float dropY = 94.0/768.0 * SCREEN_HEIGHT;
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < players/2; j++) {
            Players *dropPlayers = [[Players alloc]init];
            Players *player = self.receivePlayersArray[i*7+j];
            self.dropPlayers = dropPlayers;
            dropPlayers.tag = i * 7 + j + 1 + 20;
            dropPlayers.frame = CGRectMake(dropX, dropY, (50.0/1024.0)*SCREEN_WIDTH, (50.0/1024.0)*SCREEN_WIDTH);
            if (i * 7 + j + 1 == 7 || i * 7 + j + 1 == 14) {
                dropPlayers.userInteractionEnabled = NO;
                [dropPlayers setPlayerNumber:player.number.text playername:player.name.text playerposition:player.number.backgroundColor];
            }else{
                dropPlayers.userInteractionEnabled = YES;
                UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
                [dropPlayers addGestureRecognizer:pan];
                [dropPlayers setPlayerNumber:player.number.text playername:player.name.text playerposition:player.number.backgroundColor];
            }
            [self.view addSubview:dropPlayers];
            dropY += dropPlayers.frame.size.height + (47.0/768.0) * SCREEN_HEIGHT;
        }
        dropX += (50.0 + 10.0)/1024.0*SCREEN_WIDTH;
        dropY = 94.0/768.0 * SCREEN_HEIGHT;
    }
    UIButton *finish = [[UIButton alloc]init];
    finish.frame = CGRectMake(court.frame.origin.x+court.frame.size.width+50.0/1024.0*SCREEN_WIDTH, court.frame.size.height/2.0+70.0/768.0 * SCREEN_HEIGHT, 100/1024.0*SCREEN_WIDTH, 50/1024.0*SCREEN_WIDTH);
    finish.layer.cornerRadius = 5;
    finish.layer.masksToBounds = YES;
    finish.backgroundColor = [UIColor blackColor];
    [finish setTitle:@"完成设置" forState:UIControlStateNormal];
    [finish addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finish];
    positionLabel *positionLabel1 = [self.view viewWithTag:201];
    positionLabel *positionLabel2 = [self.view viewWithTag:202];
    positionLabel *positionLabel3 = [self.view viewWithTag:203];
    positionLabel *positionLabel4 = [self.view viewWithTag:204];
    positionLabel *positionLabel5 = [self.view viewWithTag:205];
    positionLabel *positionLabel6 = [self.view viewWithTag:206];
    if (_isClickChangeBtn == YES) {
        for (int i = 0; i < self.positionArray.count; i++) {
            for (int j = 0; j < self.receivePlayersArray.count; j++) {
                Players *positionPlayer = self.positionArray[i];
                Players *allPlayer = self.receivePlayersArray[j];
                if ([positionPlayer.number.text isEqualToString:allPlayer.number.text]) {
                    Players *p = [self.view viewWithTag:j+21];
                    switch (i) {
                        case 0:
                            p.center = CGPointMake((x2+x1)/2.0, (y2+y1)/2.0);
                            positionLabel1.player = p.tag;
                            break;
                        case 1:
                            p.center = CGPointMake((x3+x2)/2.0, (y2+y1)/2.0);
                            positionLabel2.player = p.tag;
                            break;
                        case 2:
                            p.center = CGPointMake((x4+x3)/2.0, (y2+y1)/2.0);
                            positionLabel3.player = p.tag;
                            break;
                        case 3:
                            p.center = CGPointMake((x2+x1)/2.0, (y3+y2)/2.0);
                            positionLabel4.player = p.tag;
                            break;
                        case 4:
                            p.center = CGPointMake((x3+x2)/2.0, (y3+y2)/2.0);
                            positionLabel5.player = p.tag;
                            break;
                        case 5:
                            p.center = CGPointMake((x4+x3)/2.0, (y3+y2)/2.0);
                            positionLabel6.player = p.tag;
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
    }
}

- (void) dismiss{
    BOOL canPresent = YES;
    for (int i = 201; i < 207; i++) {
        positionLabel *psLabel = [self.view viewWithTag:i];
        if (psLabel.player == 0) {
            canPresent = NO;
            break;
        }
    }
    if (canPresent) {
        [self.positionArray removeAllObjects];
        for (int i = 201; i < 207; i++) {
            positionLabel *PL = [self.view viewWithTag:i];
            Players *first = [self.view viewWithTag:PL.player];
            if (first != nil) {
                [self.positionArray addObject:first];
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"站位设置未完成"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"继续调整" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  //响应事件
                                                                  NSLog(@"action = %@", action);
                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 手势执行的方法
-(void)handlePan:(UIPanGestureRecognizer *)rec{
    //通过手势的tag值获取球员
    Players *player = [self.view viewWithTag:[rec view].tag];
    //    NSLog(@"%f---%f---%f---%f",player.frame.origin.x,player.frame.origin.y,player.frame.size.width,player.frame.size.height);
    CGFloat KWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat KHeight = [UIScreen mainScreen].bounds.size.height;
    CGRect formerRect;
    if (rec.state == UIGestureRecognizerStateBegan) formerRect = rec.view.frame;
    //返回在横坐标上、纵坐标上拖动了多少像素
    CGPoint point=[rec translationInView:self.view];
    //        NSLog(@"%f,%f",point.x,point.y);
    
    CGFloat centerX = rec.view.center.x+point.x;
    CGFloat centerY = rec.view.center.y+point.y;
    
    CGFloat viewHalfH = rec.view.frame.size.height/2;
    CGFloat viewhalfW = rec.view.frame.size.width/2;
    
    //确定特殊的centerY
    if (centerY - viewHalfH < 65 ) {
        centerY = viewHalfH + 65;
    }
    if (centerY + viewHalfH > KHeight ) {
        centerY = KHeight - viewHalfH;
    }
    
    //确定特殊的centerX
//    if (centerX - viewhalfW < KWidth){
//        centerX = viewhalfW + KWidth;
//    }
    if (centerX + viewhalfW > KWidth){
        centerX = KWidth - viewhalfW;
    }
    //球场上的六个首发位置，通过tag值获取
    positionLabel *positionLabel1 = [self.view viewWithTag:201];
    positionLabel *positionLabel2 = [self.view viewWithTag:202];
    positionLabel *positionLabel3 = [self.view viewWithTag:203];
    positionLabel *positionLabel4 = [self.view viewWithTag:204];
    positionLabel *positionLabel5 = [self.view viewWithTag:205];
    positionLabel *positionLabel6 = [self.view viewWithTag:206];
    NSArray *positionArray = @[positionLabel1,positionLabel2,positionLabel3,positionLabel4,positionLabel5,positionLabel6];
    if (rec.state == UIGestureRecognizerStateBegan) {
        //手势开始时判断一下每个位置上是否有球员
        for (int i = 0; i < 6 ; i++) {
            positionLabel *label = positionArray[i];
            CGRect c = CGRectMake(label.frame.origin.x+SCREEN_WIDTH*0.3+SCREEN_WIDTH*0.38*0.145, label.frame.origin.y+94.0/768.0 * SCREEN_HEIGHT+SCREEN_HEIGHT*0.83*0.5, label.frame.size.width, label.frame.size.height);
            for (int j = 21; j < 35; j++) {//tag值获取可拖动球员
                Players *p = [self.view viewWithTag:j];
                //判断是否在frame里
                if (CGRectContainsRect(c, p.frame)) {
                    label.player = j;
                    break;
                }else{
                    label.player = 0;
                }
            }
        }
    }
    
    
    rec.view.center=CGPointMake(centerX, centerY);
    //手势结束时调用
    if (rec.state == UIGestureRecognizerStateEnded||rec.state == UIGestureRecognizerStateCancelled) {
        //换位，包括三种换位情况：1、站位里没人直接进站位 2、站位里有人让站位里的人回原位自己进入 3、两个站位之间的对换
        switch ([self areaDefine:centerX And:centerY]) {//返回第几个站位
            case 1:
                rec.view.center = CGPointMake((x4+x3)/2.0, (y3+y2)/2.0);//进入站位
                [self canEnter:positionLabel6.player start:rec.view.center player:player];//换位动画
                [self sendEndX:(x4+x3)/2.0-25.0 endY:(y3+y2)/2.0-25.0 endWidth:50.0 endHeight:50.0 player:player];//endX Y Width Height重新设置
                positionLabel6.player = player.tag;//球员进站位
                break;
            case 2:
                rec.view.center = CGPointMake((x4+x3)/2.0, (y2+y1)/2.0);
                [self canEnter:positionLabel3.player start:rec.view.center player:player];
                [self sendEndX:(x4+x3)/2.0-25.0 endY:(y2+y1)/2.0-25.0 endWidth:50.0 endHeight:50.0 player:player];
                positionLabel3.player = player.tag;
                break;
            case 3:
                rec.view.center = CGPointMake((x3+x2)/2.0, (y2+y1)/2.0);
                [self canEnter:positionLabel2.player start:rec.view.center player:player];
                [self sendEndX:(x3+x2)/2.0-25.0 endY:(y2+y1)/2.0-25.0 endWidth:50.0 endHeight:50.0 player:player];
                positionLabel2.player = player.tag;
                break;
            case 4:
                rec.view.center = CGPointMake((x2+x1)/2.0, (y2+y1)/2.0);
                [self canEnter:positionLabel1.player start:rec.view.center player:player];
                [self sendEndX:(x2+x1)/2.0-25.0 endY:(y2+y1)/2.0-25.0 endWidth:50.0 endHeight:50.0 player:player];
                positionLabel1.player = player.tag;
                break;
            case 5:
                rec.view.center = CGPointMake((x2+x1)/2.0, (y3+y2)/2.0);
                [self canEnter:positionLabel4.player start:rec.view.center player:player];
                [self sendEndX:(x2+x1)/2.0-25.0 endY:(y3+y2)/2.0-25.0 endWidth:50.0 endHeight:50.0 player:player];
                positionLabel4.player = player.tag;
                break;
            case 6:
                rec.view.center = CGPointMake((x3+x2)/2.0, (y3+y2)/2.0);
                [self canEnter:positionLabel5.player start:rec.view.center player:player];
                [self sendEndX:(x3+x2)/2.0-25.0 endY:(y3+y2)/2.0-25.0 endWidth:50.0 endHeight:50.0 player:player];
                positionLabel5.player = player.tag;
                break;
            default://松手回位
                rec.view.frame = CGRectMake(player.startX, player.startY, player.startWidth, player.startHeight);
                [self sendEndX:player.startX endY:player.startY endWidth:50.0 endHeight:50.0 player:player];
                break;
        }
    }
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [rec setTranslation:CGPointMake(0, 0) inView:self.view];
    
}

//返回手势最终停在第几个站位上
- (int) areaDefine:(CGFloat)X And:(CGFloat)Y{
    if (X>x1 && X<x2 && Y>y1 && Y<y2) {
        return 4;
    }else if (X>x2 && X<x3 && Y>y1 && Y<y2) {
        return 3;
    }else if (X>x3 && X<x4 && Y>y1 && Y<y2) {
        return 2;
    }else if (X>x3 && X<x4 && Y>y2 && Y<y3) {
        return 1;
    }else if (X>x2 && X<x3 && Y>y2 && Y<y3) {
        return 6;
    }else if (X>x1 && X<x2 && Y>y2 && Y<y3) {
        return 5;
    }
    return 0;
}

//endX Y Width Height重新设置
- (void) sendEndX:(float)endX endY:(float)endY endWidth:(float)endWidth endHeight:(float)endHeight player:(Players*)player{
    player.endX = endX;
    player.endY = endY;
    player.endWidth = endWidth;
    player.endHeight = endHeight;
}

//换位动画
- (void) canEnter:(NSInteger)player start:(CGPoint)startPoint player:(Players*)p{
    if (player != 0) {
        Players *backView = [self.view viewWithTag:player];
        // 位置移动
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        // 0秒后执行
        animation.beginTime = CACurrentMediaTime();
        // 持续时间
        animation.duration = 0.5;
        // 重复次数
        animation.repeatCount = 1;
        // 起始位置
        animation.fromValue = [NSValue valueWithCGPoint:startPoint];
        // 终止位置
        if (p.endX == p.startX) {//判断手势的开始位置是否在球场外
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(backView.startX+backView.startWidth/2.0, backView.startY+backView.startHeight/2.0)];
        }else{
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(p.endX+p.endWidth/2.0, p.endY+p.endHeight/2.0)];
        }
        // 添加动画
        [backView.layer addAnimation:animation forKey:@"move"];
        if (p.endX == p.startX) {//判断手势的开始位置是否在球场外
            backView.frame = CGRectMake(backView.startX, backView.startY, backView.startWidth, backView.startHeight);
            backView.endX = backView.startX;
            backView.endY = backView.startY;
            backView.endWidth = backView.startWidth;
            backView.endHeight = backView.startHeight;
        }else{
            backView.frame = CGRectMake(p.endX, p.endY, p.endWidth, p.endHeight);
            backView.endX = p.endX;
            backView.endY = p.endY;
            backView.endWidth = p.endWidth;
            backView.endHeight = p.endHeight;
        }
    }
}

@end
