//
//  OurPlayersSettingVC.m
//  Volleyball
//
//  Created by 张文轩 on 2018/5/1.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import "OurPlayersSettingVC.h"
#import "PlayersSetting.h"
#import "YCPickerView.h"
#import "Players.h"
#import "positionLabel.h"
#import "ScoringView.h"
#import "TerminalChangVC.h"
#import "IQKeyboardManager.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface OurPlayersSettingVC (){
    float x1;
    float x2;
    float x3;
    float x4;
    float y1;
    float y2;
    float y3;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) YCPickerView *ycPickerView;
@property (nonatomic, strong) PlayersSetting *player;
@property (nonatomic, strong) Players *dropPlayers;
@property (nonatomic, strong) UIView *HLView;
@property (nonatomic, strong) positionLabel *positionView;
@property (nonatomic, strong) NSMutableArray *playersArray;
@property (nonatomic, strong) NSMutableArray *playersFirstArray;
@property (nonatomic, strong) NSMutableArray *freemanArray;
@end

@implementation OurPlayersSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playersArray = [NSMutableArray new];
    self.playersFirstArray = [NSMutableArray new];
    self.freemanArray = [NSMutableArray new];
    [self StatusBarAndNavigationBarInit];
    [self BasicViewInit];
    [self addTargetMethod];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

//导航条初始化
- (void) StatusBarAndNavigationBarInit{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UILabel *title = [[UILabel alloc] init];
    self.titleLabel = title;
    title.adjustsFontSizeToFitWidth = YES;
    title.text = @"我方球员设置";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    UIButton *game = [UIButton buttonWithType:UIButtonTypeSystem];
    game.frame = CGRectMake(0, 0, 80, 40);
    [game setTitle:@"开始比赛" forState:UIControlStateNormal];
    [game setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [game addTarget:self action:@selector(gameStart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:game];
    self.navigationItem.rightBarButtonItem = rightItem;
}

//开始比赛
- (void) gameStart{
    BOOL canPush = YES;
    for (int i = 201; i < 207; i++) {
        positionLabel *PL = [self.view viewWithTag:i];
        if (PL.player == 0) {
            canPush = NO;
            break;
        }
    }
    if (canPush) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *scoringView = [sb instantiateViewControllerWithIdentifier:@"scoringView"];
        ScoringView *scView = (ScoringView*)scoringView;
        scView.receivePlayersArray = self.playersArray;
        scView.receivePlayersFirstArray = self.playersFirstArray;
        scView.receiveFreemanArray = self.freemanArray;
        for (int i = 21; i < 35; i++) {
            Players *view = [self.view viewWithTag:i];
            [self.playersArray addObject:view];
        }
        for (int i = 201; i < 207; i++) {
            positionLabel *PL = [self.view viewWithTag:i];
            Players *first = [self.view viewWithTag:PL.player];
            if (first != nil) {
                [self.playersFirstArray addObject:first];
            }
        }
        [self.navigationController pushViewController:scoringView animated:YES];
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"首发未选择完成"
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

//基础视图初始化
- (void) BasicViewInit{
    //背景图
//    UIImageView *background = [[UIImageView alloc]init];
//    [background setImage:[UIImage imageNamed:@"球员设置背景"]];
//    background.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [self.view addSubview:background];
    //键盘与文本框的间距设置
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 100.0/768.0*SCREEN_HEIGHT;
    //顶部label
    for (int i = 0; i < 2; i++) {
        UILabel *introduceLabel = [[UILabel alloc]init];
        introduceLabel.frame = CGRectMake(i*SCREEN_WIDTH*0.25, 64, SCREEN_WIDTH*0.25, 20);
        introduceLabel.text = @"号码        姓名        位置";
        introduceLabel.textColor = [UIColor blackColor];
        introduceLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:introduceLabel];
    }
    //左边球员设置
    int players = 14;
    float x = SCREEN_WIDTH*0.04;
    float y = 94.0/768.0 * SCREEN_HEIGHT;
    float width = SCREEN_WIDTH*0.25-SCREEN_WIDTH*0.05;
    float height = (SCREEN_HEIGHT - y - (players/2-1)*(50.0/768.0*SCREEN_HEIGHT))/(players/2);
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < players/2; j++) {
            PlayersSetting *player = [[PlayersSetting alloc]initWithFrame:CGRectMake(x, y, width, height)];
            self.player = player;
            if (i * 7 + j + 1 == 7 || i * 7 + j + 1 == 14) {
                [player creatSettingView:-1 withName:@"" andPosition:@"自由人"];
                player.position.userInteractionEnabled = NO;
                player.numberLabel.backgroundColor = [UIColor colorWithRed:136.0/255.0 green:99.0/255.0 blue:255.0/255.0 alpha:1.0];
                player.position.backgroundColor = [UIColor colorWithRed:136.0/255.0 green:99.0/255.0 blue:255.0/255.0 alpha:1.0];
            }else{
                [player creatSettingView:-1 withName:@"" andPosition:@""];
                player.position.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLabelAction:)];
                [player.position addGestureRecognizer:tapGesture];
                UIView *singleTapView = [tapGesture view];
                singleTapView.tag = (i * 7 + j + 1)*100;
            }
            player.tag = i * 7 + j + 1;
            [self.view addSubview:player];
            y += 50.0/768.0*SCREEN_HEIGHT +height;
        }
        y = 94.0/768.0 * SCREEN_HEIGHT;
        x += x + width;
    }
    //右边球场
    UIImageView *court = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.6, 94.0/768.0 * SCREEN_HEIGHT, SCREEN_WIDTH*0.38, SCREEN_HEIGHT*0.83)];
    court.image = [UIImage imageNamed:@"沙盘-竖"];
    [self.view addSubview:court];
    //高亮部分
    UIView *HLView = [[UIView alloc]init];
    self.HLView = HLView;
    HLView.frame = CGRectMake(court.frame.size.width*0.145, court.frame.size.height*0.5, court.frame.size.width*0.69, court.frame.size.height*0.4);
//    HLView.backgroundColor = [UIColor yellowColor];
    [court addSubview:HLView];
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
    float dropX = SCREEN_WIDTH*0.5 - (10.0/1024.0)*SCREEN_WIDTH;
    float dropY = 94.0/768.0 * SCREEN_HEIGHT;
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < players/2; j++) {
            Players *dropPlayers = [[Players alloc]init];
            self.dropPlayers = dropPlayers;
            dropPlayers.tag = i * 7 + j + 1 + 20;
            dropPlayers.frame = CGRectMake(dropX, dropY, (50.0/1024.0)*SCREEN_WIDTH, (50.0/1024.0)*SCREEN_WIDTH);
            if (i * 7 + j + 1 == 7 || i * 7 + j + 1 == 14) {
                dropPlayers.userInteractionEnabled = NO;
                [dropPlayers setPlayerNumber:@"" playername:@"未命名" playerposition:[UIColor colorWithRed:136.0/255.0 green:99.0/255.0 blue:255.0/255.0 alpha:1.0]];
                [self.freemanArray addObject:dropPlayers];
            }else{
                dropPlayers.userInteractionEnabled = YES;
                UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
                [dropPlayers addGestureRecognizer:pan];
                [dropPlayers setPlayerNumber:@"" playername:@"未命名" playerposition:[UIColor grayColor]];
            }
            [self.view addSubview:dropPlayers];
            dropY += dropPlayers.frame.size.height + (47.0/768.0) * SCREEN_HEIGHT;
        }
        dropX += (50.0 + 10.0)/1024.0*SCREEN_WIDTH;
        dropY = 94.0/768.0 * SCREEN_HEIGHT;
    }
}

//选择站位时对应颜色
- (void) clickLabelAction:(UITapGestureRecognizer *)sender{
    self.ycPickerView = [[YCPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.ycPickerView.arrPickerData = @[@"主攻",@"副攻",@"二传",@"接应"];
    [self.ycPickerView.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.view addSubview:self.ycPickerView];
    [self.ycPickerView popPickerView];
    PlayersSetting *player = [self.view viewWithTag:[sender view].tag/100];
    Players *dropPlayer = [self.view viewWithTag:[sender view].tag/100+20];
    self.ycPickerView.selectBlock = ^(NSString *str) {
        player.position.text = str;
        dropPlayer.number.backgroundColor = [player refreshColor:str];
    };
}
#pragma mark - 添加监听方法
- (void) addTargetMethod{
    for (int i = 1; i <= 14; i++) {
        PlayersSetting *player = [self.view viewWithTag:i];
        [player.numberLabel addTarget:self action:@selector(textFieldNumberChange:) forControlEvents:UIControlEventEditingChanged];
        [player.nameTF addTarget:self action:@selector(textFieldNameChange:) forControlEvents:UIControlEventEditingChanged];
    }
}
- (void) textFieldNumberChange:(UITextField *)textField{
    UIView *view = textField.superview;
    NSString *toBeString = textField.text;
    if (toBeString.length > 2) {
        textField.text = [toBeString substringToIndex:2];
    }
    Players *dropPlayer = [self.view viewWithTag:view.tag+20];
    dropPlayer.number.text = textField.text;
}
- (void) textFieldNameChange:(UITextField *)textField{
    UIView *view = textField.superview;
    Players *dropPlayer = [self.view viewWithTag:view.tag+20];
    dropPlayer.name.text = textField.text;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //界面所有输入框都停止编辑
    [self.view endEditing:YES];
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
    if (centerX - viewhalfW < KWidth/2){
        centerX = viewhalfW + KWidth/2;
    }
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
            CGRect c = CGRectMake(label.frame.origin.x+SCREEN_WIDTH*0.6+SCREEN_WIDTH*0.38*0.145, label.frame.origin.y+94.0/768.0 * SCREEN_HEIGHT+SCREEN_HEIGHT*0.83*0.5, label.frame.size.width, label.frame.size.height);
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
    x1 = self.HLView.frame.origin.x+SCREEN_WIDTH*0.6;
    x2 = self.HLView.frame.origin.x+self.HLView.frame.size.width*0.33+SCREEN_WIDTH*0.6;
    x3 = self.HLView.frame.origin.x+self.HLView.frame.size.width*0.66+SCREEN_WIDTH*0.6;
    x4 = self.HLView.frame.origin.x+self.HLView.frame.size.width+SCREEN_WIDTH*0.6;
    y1 = self.HLView.frame.origin.y+94.0/768.0 * SCREEN_HEIGHT;
    y2 = self.HLView.frame.origin.y+self.HLView.frame.size.height*0.5+94.0/768.0 * SCREEN_HEIGHT;
    y3 = self.HLView.frame.origin.y+self.HLView.frame.size.height+94.0/768.0 * SCREEN_HEIGHT;
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
