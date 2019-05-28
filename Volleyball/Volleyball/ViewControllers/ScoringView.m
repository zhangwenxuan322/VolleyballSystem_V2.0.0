//
//  ViewController.m
//  Volleyball
//
//  Created by 张文轩 on 2018/3/15.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import "ScoringView.h"
#import "Court.h"
#import "ChooseButton.h"
#import "D3View.h"
#import "PlayerModel.h"
#import "DuiLoss.h"
#import "OurPlayersSettingVC.h"
#import "TerminalChangVC.h"
#import "ChangePlayerView.h"
#import "YCPickerView.h"
#import "DetailScoreVC.h"
#import "HomePageVC.h"
#import "RealTimeVC.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface ScoringView ()
{
    NSArray *choices;//选择按钮的数组
    NSMutableArray *players;//球员数组
    float x;//进程计数
    float y;//趋势计数
    int scoreTeamA;//A队得分
    int scoreTeamB;//B队得分
    int bigScoreA;//A队大比分
    int bigScoreB;//B队大比分
    int turns;//回合数
    NSString *processStr;//进程事件名
    NSString *resultStr;//每轮的结束名
    NSMutableAttributedString *resultMuStr;//富文本Str
    int lastScore;//上一分的得分判断 1-我方得分 2-对方得分
    NSString *firstTouch;//记录第一次点击
    NSArray *gameOne;//第一局成绩
    NSArray *gameTwo;//第二局成绩
    NSArray *gameThree;//第三局成绩
    NSArray *gameFour;//第四局成绩
    NSArray *gameFive;//第五局成绩
    NSArray *currentGame;//当前局
    DuiLoss *duiLoss;//对失
}
@property (nonatomic, strong) YCPickerView *ycPickerView;//选择框
@property (weak, nonatomic) IBOutlet UIView *processView;//顶部进度条视图
@property (weak, nonatomic) IBOutlet UIView *chooseView;//左侧选择栏
@property (weak, nonatomic) IBOutlet UIScrollView *tendencyChart;//右上侧趋势图
@property (strong,nonatomic) UIScrollView *process;//进度条滑动块
@property (strong,nonatomic) UIButton *tmpBtn;//选择栏按钮顶替
@property (strong,nonatomic) UIView *table;//事件表，按钮最多的那个
@property (strong,nonatomic) UIButton *positionPlayer;//场上球员
@property (strong,nonatomic) UIButton *changePlayer;//场下球员
@property (nonatomic, assign) UIView *background;//大图点击后的背景
@property (nonatomic, assign) Court *court;//右侧球场
@property (nonatomic, strong) NSMutableArray *positionArray;//当前站位数组
@property (nonatomic, strong) NSMutableArray *playerDetailArray;//球员详细得分数组
@end

@implementation ScoringView
- (void) viewDidLoad {
    [super viewDidLoad];
    //数据初始化，具体释义看上面的申明
    x = 10;
    y = 10;
    scoreTeamA = 0;
    scoreTeamB = 0;
    bigScoreA = 0;
    bigScoreB = 0;
    turns = 1;
    processStr = @"发球";
    resultStr = @"";
    //导航条初始化
    [self StatusBarAndNavigationBarInit];
    //基础界面初始化
    [self BaseViewsInit];
}

- (void) viewWillAppear:(BOOL)animated{
    for (int i = 1; i <= 6; i++) {
        Players *player = [self.view viewWithTag:i];
        Players *playerCP = self.positionArray[i-1];
        player.number.text = playerCP.number.text;
        player.name.text = playerCP.name.text;
        player.number.backgroundColor = playerCP.number.backgroundColor;
    }
    //取消导航栏偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}

//导航条初始化
- (void) StatusBarAndNavigationBarInit{
    //中止比赛按钮
    UIButton *gameOver = [UIButton buttonWithType:UIButtonTypeSystem];
    gameOver.frame = CGRectMake(0, 0, 80, 40);
    [gameOver setTitle:@"中止比赛" forState:UIControlStateNormal];
    [gameOver setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gameOver addTarget:self action:@selector(gameOver) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:gameOver];
    self.navigationItem.rightBarButtonItem = rightItem;
    //取消导航栏返回按钮
    [self.navigationItem setHidesBackButton:TRUE animated:NO];
    //导航栏标题
    NSString *title = [NSString stringWithFormat:@"第%d局\t\t\t总比分\t\t\t%d  :  %d\t\t\t小比分\t\t\t%d  :  %d",turns,bigScoreA,bigScoreB,scoreTeamA,scoreTeamB];
    self.navigationItem.title = title;
    //富文本做字体颜色调整
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                    NSFontAttributeName:[UIFont systemFontOfSize:16]
                                                                    };
}

- (void) gameOver{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"中止比赛"
                                                                   message:@"将丢失已记录的数据"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              NSLog(@"action = %@", action);
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             NSLog(@"action = %@", action);
                                                         }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//基础视图初始化
- (void) BaseViewsInit{
    gameOne = [NSArray new];
    gameTwo = [NSArray new];
    gameThree = [NSArray new];
    gameFour = [NSArray new];
    gameFive = [NSArray new];
    //球员详细得分数组
    self.playerDetailArray = [NSMutableArray new];
    for (int i = 0; i < 14; i++) {
        Players *player = self.receivePlayersArray[i];
        PlayerModel *playerDetail = [[PlayerModel alloc]init];
        playerDetail.number = player.number.text;
        playerDetail.name = player.name.text;
        [self.playerDetailArray addObject:playerDetail];
    }
    duiLoss = [DuiLoss new];
    //站位数组重新分配内存空间，不能直接修改接收的（首发）球员数组
    self.positionArray = [NSMutableArray new];
    self.positionArray = [NSMutableArray arrayWithArray:_receivePlayersFirstArray];
    players = [[NSMutableArray alloc]init];
    players = [NSMutableArray arrayWithArray:_receivePlayersArray];
    //进度条frame适配
    self.processView.frame = CGRectMake(5, 66, SCREEN_WIDTH*0.7778, SCREEN_HEIGHT*0.1091);
    //进度条细节设置，圆角、颜色
    self.processView.layer.cornerRadius = 5;
    self.processView.layer.masksToBounds = YES;
    UIColor *gray = [UIColor colorWithRed:52.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.processView.backgroundColor = gray;
    //滑动块适配，贴在进程视图上
    UIScrollView *process = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.7778, SCREEN_HEIGHT*0.1091)];
    self.process = process;
    [self.processView addSubview:process];
    //选择框frame适配
    self.chooseView.frame = CGRectMake(5,self.processView.frame.origin.y+self.processView.frame.size.height+10,SCREEN_WIDTH*0.1636,SCREEN_HEIGHT*0.77);
    //选择框细节设置，圆角、颜色
    self.chooseView.layer.cornerRadius = 5;
    self.chooseView.layer.masksToBounds = YES;
    self.chooseView.backgroundColor = gray;
    //趋势图frame适配
    self.tendencyChart.frame = CGRectMake(self.processView.frame.origin.x+self.processView.frame.size.width+5, self.processView.frame.origin.y, SCREEN_WIDTH-(self.processView.frame.origin.x+self.processView.frame.size.width+10), (self.chooseView.frame.origin.y+self.chooseView.frame.size.height-self.processView.frame.origin.y)*0.5);
    //趋势图细节设置，圆角
    self.tendencyChart.layer.cornerRadius = 5;
    self.tendencyChart.layer.masksToBounds = YES;
    //球场初始化
    Court *court = [[Court alloc]init];
    self.court = court;
    //球场frame适配
    court.frame = CGRectMake(self.tendencyChart.frame.origin.x, self.tendencyChart.frame.origin.y+self.tendencyChart.frame.size.height+5, self.tendencyChart.frame.size.width, self.tendencyChart.frame.size.height*0.4);
    //球场贴图
    [court courtInit:nil];
    //允许 imageView 用户交互
    //允许用户交互
    court.userInteractionEnabled = YES;
    UILabel *courtLabel = [[UILabel alloc]init];
    courtLabel.frame = CGRectMake(0, 0, court.frame.size.width, court.frame.size.height);
    courtLabel.text = @"实时站位";
    courtLabel.textAlignment = NSTextAlignmentCenter;
    courtLabel.textColor = [UIColor whiteColor];
    courtLabel.font = [UIFont systemFontOfSize:25];
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:courtLabel.text attributes:@{NSKernAttributeName : @(3.0f)}];
    [courtLabel setAttributedText:attributedString];
    [court addSubview:courtLabel];
    //添加点击手势，查看大图
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cleckImageViewAction)];
    [court addGestureRecognizer:tapGesture];
    [self.view addSubview:court];
    //换人按钮
    UIButton *changeBtn = [[UIButton alloc]init];
    changeBtn.frame = CGRectMake(court.frame.origin.x, court.frame.origin.y+court.frame.size.height+20.0/768.0*SCREEN_HEIGHT, court.frame.size.width, court.frame.size.height*0.33);
    [changeBtn setTitle:@"换人" forState:UIControlStateNormal];
    changeBtn.layer.cornerRadius = 5;
    changeBtn.layer.masksToBounds = YES;
    [changeBtn addTarget:self action:@selector(clickChangeButton) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:changeBtn];
    //详细得分按钮
    UIButton *detailScore = [[UIButton alloc]init];
    detailScore.frame = CGRectMake(court.frame.origin.x, changeBtn.frame.origin.y+changeBtn.frame.size.height+20.0/768.0*SCREEN_HEIGHT, court.frame.size.width, court.frame.size.height*0.33);
    [detailScore setTitle:@"详细得分" forState:UIControlStateNormal];
    detailScore.layer.cornerRadius = 5;
    detailScore.layer.masksToBounds = YES;
    [detailScore addTarget:self action:@selector(pushDetailScoreVC) forControlEvents:UIControlEventTouchUpInside];
    detailScore.backgroundColor = [UIColor blackColor];
    [self.view addSubview:detailScore];
    //详细得分按钮
    UIButton *realTimeScore = [[UIButton alloc]init];
    realTimeScore.frame = CGRectMake(court.frame.origin.x, detailScore.frame.origin.y+detailScore.frame.size.height+20.0/768.0*SCREEN_HEIGHT, court.frame.size.width, court.frame.size.height*0.33);
    [realTimeScore setTitle:@"实时得分" forState:UIControlStateNormal];
    realTimeScore.layer.cornerRadius = 5;
    realTimeScore.layer.masksToBounds = YES;
    [realTimeScore addTarget:self action:@selector(pushRealTimeVC) forControlEvents:UIControlEventTouchUpInside];
    realTimeScore.backgroundColor = [UIColor blackColor];
    [self.view addSubview:realTimeScore];
    //创建最左边选择按钮，贴在选择框上
    choices = [NSArray arrayWithObjects:@"发球",@"一传",@"一攻扣",@"拦网",@"防守",@"反击扣",@"二传及其他",@"对失", nil];
    for (int choice = 0; choice < choices.count; choice++){
        //自己封装的button
        ChooseButton *chooseBtn = [ChooseButton buttonWithType:UIButtonTypeCustom];
        //frame适配
        chooseBtn.frame = CGRectMake(
            self.chooseView.frame.size.width*0.2,//x
            0 +self.chooseView.frame.size.height*0.128*choice,//y
            self.chooseView.frame.size.width*0.6,//w
            self.chooseView.frame.size.height*0.1);//h
        //显示内容设置
        [chooseBtn setChooseButton:choices[choice]];
        //默认选中第一个按钮，呈被点击状态
        if (choice == 0) {
            chooseBtn.selected = YES;
            self.tmpBtn = chooseBtn;
        }
        //赋tag值，以便后续字符串拼接判断
        chooseBtn.tag = (choice+1)*10;
        //添加点击事件，用于事件表刷新
        [chooseBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseView addSubview:chooseBtn];
    }
    //创建球员，6个首发+2个自由人
    for (int member = 0; member < 8; member++) {
        //为视图分配内存空间
        Players *player = [[Players alloc]init];
        //和全局变量关联
        self.player = player;
        //frame适配
        self.player.frame = CGRectMake(self.chooseView.frame.origin.x+self.chooseView.frame.size.width+10, self.processView.frame.origin.y+self.processView.frame.size.height+10+member*SCREEN_HEIGHT*0.1, SCREEN_WIDTH*0.0539, SCREEN_WIDTH*0.0539);
        //从设置好的首发和球员展示视图
        if (member>=0 && member<6) {//前6个是首发
            Players *receivePlayers = self.positionArray[member];
            [self.player setPlayerNumber:receivePlayers.number.text playername:receivePlayers.name.text playerposition:receivePlayers.number.backgroundColor];
        }else{//后两个是自由人
            Players *receiveFreeman = self.receiveFreemanArray[member - 6];
            [self.player setPlayerNumber:receiveFreeman.number.text playername:receiveFreeman.name.text playerposition:receiveFreeman.number.backgroundColor];
        }
        //赋tag值
        self.player.tag = member+1;
        [self.view addSubview:self.player];
    }
    //过程按钮，初始化默认为发球界面
    NSArray *start = [NSArray arrayWithObjects:@"得分",@"到位",@"能攻",@"破攻",@"失误", nil];
    [self buildProcessTable:start];
    [self selectStartPlayer:start];
}

- (void) pushRealTimeVC {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *realtimeVC = [sb instantiateViewControllerWithIdentifier:@"realtimeVC"];
    RealTimeVC *rtVC = (RealTimeVC*)realtimeVC;
    rtVC.detailScoreArray = self.playerDetailArray;
    [self.navigationController pushViewController:realtimeVC animated:YES];
}

- (void) pushDetailScoreVC {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *detailscoreVC = [sb instantiateViewControllerWithIdentifier:@"detailscoreVC"];
    DetailScoreVC *dsVC = (DetailScoreVC*)detailscoreVC;
    dsVC.detailScoreArray = self.playerDetailArray;
    dsVC.duiLoss = duiLoss;
    [self.navigationController pushViewController:dsVC animated:YES];
}
//从一号位自动判定发球球员
- (void) selectStartPlayer:(NSArray*)array{
    //寄存器
    int memeber = 0;
    //获取一号位球员
    Players *stance1Player = self.positionArray[5];
    //找出球员在哪一行
    for (int i = 1; i <= 8 ; i++) {
        Players *player = [self.view viewWithTag:i];
        if ([player.number.text isEqualToString:stance1Player.number.text]) {
            memeber = i;
            break;
        }
    }
    //其余行不可点击
    for (int i = 1; i <= 8 ; i++) {
        for (int j = 1; j <= array.count; j++) {
            if (i != 6) {
                UIButton *enableBtn = [self.view viewWithTag:i*10+j];
                enableBtn.backgroundColor = [UIColor grayColor];
                enableBtn.enabled = NO;
            }
        }
    }
}
- (void) clickChangeButton{
    NSLog(@"换人");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *terminalVC = [sb instantiateViewControllerWithIdentifier:@"tcVC"];
    TerminalChangVC *tcVC = (TerminalChangVC*)terminalVC;
    tcVC.receivePlayersArray = self.receivePlayersArray;
    tcVC.positionArray = self.positionArray;
    tcVC.isClickChangeBtn = YES;
    [self presentViewController:terminalVC animated:YES completion:nil];
//    //创建一个黑色背景
//    //初始化一个用来当做背景的View。
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.background = bgView;
//    [bgView setBackgroundColor:[UIColor colorWithRed:0/250.0 green:0/250.0 blue:0/250.0 alpha:0.5]];
//    [self.view addSubview:bgView];
//    //创建换人界面
//    ChangePlayerView *changePlayerView = [[ChangePlayerView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.3, SCREEN_HEIGHT*0.3, SCREEN_WIDTH*0.4, SCREEN_HEIGHT*0.4)];
//    [changePlayerView d3_bounce];
//    //场上球员label
//    UIButton *positonPlayer = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.positionPlayer = positonPlayer;
//    positonPlayer.frame = CGRectMake(changePlayerView.frame.size.width*0.1, changePlayerView.frame.size.height*0.4, changePlayerView.frame.size.width*0.3, changePlayerView.frame.size.height*0.15);
//    UIImageView *dropImgL = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"下拉框"]];
//    dropImgL.frame = CGRectMake(positonPlayer.frame.size.width*0.8, positonPlayer.frame.size.height*0.25, positonPlayer.frame.size.width*0.15, positonPlayer.frame.size.height*0.5);
//    [positonPlayer addSubview:dropImgL];
//    [positonPlayer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    positonPlayer.layer.cornerRadius = 5;
//    positonPlayer.layer.masksToBounds = YES;
//    [positonPlayer setBackgroundImage:[UIImage imageNamed:@"框"] forState:UIControlStateNormal];
//    [positonPlayer addTarget:self action:@selector(clickLAction:) forControlEvents:UIControlEventTouchUpInside];
//    [changePlayerView addSubview:positonPlayer];
//    //替补球员label
//    UIButton *changePlayer = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.changePlayer = changePlayer;
//    changePlayer.frame = CGRectMake(changePlayerView.frame.size.width*0.6, changePlayerView.frame.size.height*0.4, changePlayerView.frame.size.width*0.3, changePlayerView.frame.size.height*0.15);
//    UIImageView *dropImgR = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"下拉框"]];
//    dropImgR.frame = CGRectMake(changePlayer.frame.size.width*0.8, changePlayer.frame.size.height*0.25, changePlayer.frame.size.width*0.15, changePlayer.frame.size.height*0.5);
//    [changePlayer addSubview:dropImgR];
//    [changePlayer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    changePlayer.layer.cornerRadius = 5;
//    changePlayer.layer.masksToBounds = YES;
//    [changePlayer setBackgroundImage:[UIImage imageNamed:@"框"] forState:UIControlStateNormal];
//    [changePlayer addTarget:self action:@selector(clickRAction:) forControlEvents:UIControlEventTouchUpInside];
//    [changePlayerView addSubview:changePlayer];
//    //取消按钮
//    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancel.frame = CGRectMake(changePlayerView.frame.size.width*0.9, 0, changePlayerView.frame.size.width*0.1, changePlayerView.frame.size.width*0.1);
//    [cancel setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
//    [changePlayerView addSubview:cancel];
//    [cancel addTarget:self action:@selector(closeChangeView) forControlEvents:UIControlEventTouchUpInside];
//    [changePlayerView createChangePlayerView:nil changePlayer:nil];
//    changePlayerView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.background addSubview:changePlayerView];
//    //完成按钮
//    UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
//    done.frame = CGRectMake(changePlayerView.frame.size.width*0.45, changePlayerView.frame.size.height*0.8, changePlayerView.frame.size.width*0.1, changePlayerView.frame.size.width*0.1);
//    [done setImage:[UIImage imageNamed:@"完成"] forState:UIControlStateNormal];
//    [done addTarget:self action:@selector(clickDone) forControlEvents:UIControlEventTouchUpInside];
//    done.layer.cornerRadius = 5;
//    done.layer.masksToBounds = YES;
//    [changePlayerView addSubview:done];
}

- (void) clickDone{
    int markI = 0;
    int markJ = 0;
    for (int i = 0; i < 6; i++) {
        Players *player = self.positionArray[i];
        if (player.number.text == self.positionPlayer.currentTitle) {
            markI = i;
        }
    }
    for (int j = 0; j < 13; j++) {
        Players *player = self.receivePlayersArray[j];
        if (player.number.text == self.changePlayer.currentTitle) {
            markJ = j;
        }
    }
    [self.positionArray replaceObjectAtIndex:markI withObject:self.receivePlayersArray[markJ]];
    Players *player = [self.view viewWithTag:markI+1];
    Players *playerRefresh = self.positionArray[markI];
    player.number.text = playerRefresh.number.text;
    player.name.text = playerRefresh.name.text;
    player.number.backgroundColor = playerRefresh.number.backgroundColor;
    [self closeChangeView];
    NSLog(@"完成换人");
}

- (void) clickLAction:(UIButton*)sender{
    self.ycPickerView = [[YCPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSMutableArray *positionNumber = [[NSMutableArray alloc]init];
    for (int i = 0; i < 6; i++) {
        Players *player = self.positionArray[i];
        [positionNumber addObject:player.number.text];
    }
    self.ycPickerView.arrPickerData = positionNumber;
    [self.ycPickerView.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.view addSubview:self.ycPickerView];
    [self.ycPickerView popPickerView];
    self.ycPickerView.selectBlock = ^(NSString *str) {
        [sender setTitle:str forState:UIControlStateNormal];
    };
}

- (void) clickRAction:(UIButton*)sender{
    self.ycPickerView = [[YCPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSMutableArray *allNumber = [[NSMutableArray alloc]init];
    NSMutableArray *positionNumber = [[NSMutableArray alloc]init];
    for (int i = 0; i < 6; i++) {
        Players *player = self.positionArray[i];
        [positionNumber addObject:player.number.text];
    }
    for (int i = 0; i < 13; i++) {
        if (i != 6 && i != 13) {
            Players *player = self.receivePlayersArray[i];
            [allNumber addObject:player.number.text];
        }
    }
    __block NSMutableArray *difObject = [NSMutableArray arrayWithCapacity:6];
    //找到arr1中有,arr2中没有的数据
    [allNumber enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *number1 = obj;//[obj objectAtIndex:idx];
        __block BOOL isHave = NO;
        [positionNumber enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([number1 isEqual:obj]) {
                isHave = YES;
                *stop = YES;
            }
        }];
        if (!isHave) {
            [difObject addObject:obj];
        }
    }];
    self.ycPickerView.arrPickerData = difObject;
    [self.ycPickerView.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.view addSubview:self.ycPickerView];
    [self.ycPickerView popPickerView];
    self.ycPickerView.selectBlock = ^(NSString *str) {
        [sender setTitle:str forState:UIControlStateNormal];
    };
}

- (void) closeChangeView{
    // 将大图动画回小图的位置和大小
    [UIView animateWithDuration:0.3 animations:^{
        // 改变大小
        self.background.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.background.frame = CGRectMake(SCREEN_WIDTH*0.5, SCREEN_HEIGHT*0.5, 0, 0);
        // 改变位置
        self.background.center = self.view.center;// 设置中心位置到新的位置
    }];
    // 延迟执行，移动回后再消灭掉
    double delayInSeconds = 0.3;
    __block ScoringView* bself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [bself.background removeFromSuperview];
        bself.background = nil;
    });
}
//点击图片后的方法(即图片的放大全屏效果)
- (void) cleckImageViewAction{
    NSLog(@"查看球场大图");
    //创建一个黑色背景
    //初始化一个用来当做背景的View。
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.background = bgView;
    [bgView setBackgroundColor:[UIColor colorWithRed:0/250.0 green:0/250.0 blue:0/250.0 alpha:0.5]];
    [self.view addSubview:bgView];
    //创建显示图像的视图
    //初始化要显示的图片内容的imageView
    Court *browseImgView = [[Court alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.1, SCREEN_HEIGHT*0.1, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.8)];
    browseImgView.contentMode = UIViewContentModeScaleAspectFit;
    //要显示的图片，即要放大的图片
    [browseImgView courtInit:self.positionArray];
    [bgView addSubview:browseImgView];
    browseImgView.userInteractionEnabled = YES;
    //添加点击手势（即点击图片后退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [browseImgView addGestureRecognizer:tapGesture];
    [bgView addGestureRecognizer:tapGesture];
    [self shakeToShow:bgView];//放大过程中的动画
}
//关闭视图
-(void)closeView{
    // 将大图动画回小图的位置和大小
    [UIView animateWithDuration:0.3 animations:^{
        // 改变大小
        self.background.frame = CGRectMake(SCREEN_WIDTH*0.1, SCREEN_HEIGHT*0.1, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.8);
        self.background.frame = self.court.frame;
        // 改变位置
        self.background.center = self.court.center;// 设置中心位置到新的位置
    }];
    // 延迟执行，移动回后再消灭掉
    double delayInSeconds = 0.3;
    __block ScoringView* bself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [bself.background removeFromSuperview];
        bself.background = nil;
    });
}
//放大过程中出现的缓慢动画
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
//监听选择框按钮点击
- (void) buttonClick:(UIButton *)sender{
    //点击跳出的数组可能
    NSArray *start = [NSArray arrayWithObjects:@"得分",@"到位",@"能攻",@"能攻",@"失误", nil];
    NSArray *first = [NSArray arrayWithObjects:@"到位",@"能攻",@"破攻",@"失误", nil];
    NSArray *lan = [NSArray arrayWithObjects:@"得分",@"拦起",@"拦回",@"拦失",@"犯规", nil];
    NSArray *fang = [NSArray arrayWithObjects:@"到位",@"能攻",@"破攻",@"失误", nil];
    NSArray *kou = [NSArray arrayWithObjects:@"得分",@"被防起",@"被拦死",@"扣失", nil];
    NSArray *second = [NSArray arrayWithObjects:@"得分",@"失分", nil];
    //按钮选择
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
        sender.selected = YES;
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    //根据选择来刷新相应的表单----还可待优化
    switch (sender.tag) {
        case 10://发球
            [self hidePlayers:NO];
            [self buildProcessTable:start];
            [self selectStartPlayer:start];
            processStr = @"发球";
            NSLog(@"发球");
            break;
        case 20://一传
            [self hidePlayers:NO];
            [self buildProcessTable:first];
            processStr = @"一传";
            NSLog(@"一传");
            break;
        case 30://一攻扣
            [self hidePlayers:NO];
            [self buildProcessTable:kou];
            processStr = @"一攻扣";
            NSLog(@"一攻扣");
            break;
        case 40://拦网
            [self hidePlayers:NO];
            [self buildProcessTable:lan];
            processStr = @"拦网";
            NSLog(@"拦网");
            break;
        case 50://防守
            [self hidePlayers:NO];
            [self buildProcessTable:fang];
            processStr = @"防守";
            NSLog(@"防守");
            break;
        case 60://反击扣
            [self hidePlayers:NO];
            [self buildProcessTable:kou];
            processStr = @"反击扣";
            NSLog(@"反击扣");
            break;
        case 70://二传及其他
            [self hidePlayers:NO];
            [self buildProcessTable:second];
            processStr = @"其他";
            NSLog(@"二传及其他");
            break;
        case 80://二传及其他
            [self hidePlayers:YES];
            [self buildProcessTable:nil];
            processStr = @"对失";
            NSLog(@"对失");
            break;
        default:
            break;
    }
}
//我方球员隐藏
- (void) hidePlayers:(BOOL)hide{
    for (int i = 1; i <= 8; i++) {
        UIView *player = [self.view viewWithTag:i];
        player.hidden = hide;
    }
}
//事件表刷新
- (void) buildProcessTable:(NSArray*)process{
    UIView *player1 = [self.view viewWithTag:1];
    UIView *player2 = [self.view viewWithTag:2];
    float PROCESSBTN_X = player1.frame.origin.x + player1.frame.size.width;
    float PROCESSBTN_Y = player1.frame.origin.y-5;
    float originX = PROCESSBTN_X;
    [self.table removeFromSuperview];
    UIView *table = [[UIView alloc]init];
    self.table = table;
    table.frame = CGRectMake(PROCESSBTN_X, PROCESSBTN_Y, self.processView.frame.origin.x+self.processView.frame.size.width-originX, player1.frame.size.height*8+(player2.frame.origin.y-player1.frame.origin.y-player1.frame.size.height)*7);
    if (process == nil) {
        [self creatDuishiTable:(player2.frame.origin.y - player1.frame.origin.y - player1.frame.size.height)*3];
    }else{
        [self creatTable:player2.frame.origin.y - player1.frame.origin.y - player1.frame.size.height Height:player1.frame.size.height Process:process];
    }
    [self.view addSubview:table];
}

//添加事件表按钮
- (void)creatTable:(float)gap Height:(float)height Process:(NSArray*)processArray{
    UIView *player1 = [self.view viewWithTag:1];
    float PROCESSBTN_X = player1.frame.origin.x + player1.frame.size.width;
    float originX = PROCESSBTN_X;
    float width = (self.processView.frame.origin.x+self.processView.frame.size.width-originX-10*(processArray.count-1))/processArray.count;
    float x = 0;
    float y = 0;
    //按钮表
    for (int i = 1 ; i <= 8 ; i++) {
        for (int j = 1 ; j <= processArray.count; j++){
            UIButton *processBtn = [[UIButton alloc]init];
            processBtn.layer.cornerRadius = 5;
            processBtn.layer.masksToBounds = YES;
            processBtn.frame = CGRectMake(x, y, width, height);
            NSString *title = processArray[j-1];
            NSArray *items = @[@"得分",@"失误",@"拦失",@"犯规",@"被拦死",@"扣失",@"失分"];
            NSInteger item = [items indexOfObject:title];
            [processBtn setTitle:[[NSString alloc] initWithFormat:@"%@",title] forState:UIControlStateNormal];
            [processBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
            processBtn.titleLabel.textColor = [UIColor whiteColor];
            UIColor *green = [UIColor colorWithRed:0.0/255.0 green:142.0/255.0 blue:4.0/255.0 alpha:1.0];
            switch (item) {
                case 0:
                    processBtn.backgroundColor = [UIColor redColor];
                    break;
                case 1:
                    processBtn.backgroundColor = green;
                    break;
                case 2:
                    processBtn.backgroundColor = green;
                    break;
                case 3:
                    processBtn.backgroundColor = green;
                    break;
                case 4:
                    processBtn.backgroundColor = green;
                    break;
                case 5:
                    processBtn.backgroundColor = green;
                    break;
                case 6:
                    processBtn.backgroundColor = green;
                    break;
                default:
                    processBtn.backgroundColor = [UIColor orangeColor];
                    break;
            }
            processBtn.tag = i*10+j;
            [self.table addSubview:processBtn];
            x += 10 + width;
        }
        x = 0;
        y += height + gap;
    }
}

//创建对失事件表
- (void) creatDuishiTable:(float)gap {
    [self.table removeFromSuperview];
    UIView *player1 = [self.view viewWithTag:1];
    float PROCESSBTN_X = player1.frame.origin.x + player1.frame.size.width;
    float originX = PROCESSBTN_X;
    float width = (self.processView.frame.origin.x+self.processView.frame.size.width-originX)*0.5;
    float height = (self.chooseView.frame.size.height-3*gap)*0.25;
    float x = (self.processView.frame.origin.x+self.processView.frame.size.width-originX)/4;
    float y = 0;
    NSArray *duishi = @[@"对方扣失",@"对方发失",@"对方犯规",@"对方其他失"];
    for (int i = 1; i <= 4; i++) {
        UIButton *processBtn = [[UIButton alloc]init];
        processBtn.layer.cornerRadius = 5;
        processBtn.layer.masksToBounds = YES;
        processBtn.frame = CGRectMake(x, y, width, height);
        [processBtn setTitle:[NSString stringWithFormat:@"%@",duishi[i-1]] forState:UIControlStateNormal];
        [processBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        processBtn.titleLabel.textColor = [UIColor whiteColor];
        processBtn.backgroundColor = [UIColor redColor];
        [self.table addSubview:processBtn];
        y += gap + height;
    }
}

//按钮不可点击
- (void) setBtnEnabled:(NSArray*)tagArray{
    for (UIButton *subBtn in self.chooseView.subviews){
        subBtn.enabled = YES;
    }
    if (tagArray != nil) {
        for (int i = 0; i < tagArray.count; i++) {
            NSInteger m = [tagArray[i] integerValue];
            NSLog(@"%ld",(long)m);
            UIButton *enabledBtn = (UIButton*)[self.chooseView viewWithTag:m];
            enabledBtn.enabled = NO;
        }
    }
}

//事件表按钮的点击监控
- (void)pressBtn:(UIButton*)sender{
    for (UIButton *subBtn in self.table.subviews){
        subBtn.backgroundColor = [UIColor grayColor];
        subBtn.enabled = NO;
    }
    NSArray *after10 = @[@"10",@"20",@"30"];
    NSArray *after20 = @[@"10",@"20",@"40",@"50",@"60"];
    NSArray *after30 = @[@"10",@"20",@"30"];
    NSArray *after4050 = @[@"10",@"20",@"30"];
    NSArray *after60 = @[@"10",@"20",@"30",@"70"];
    switch (self.tmpBtn.tag) {
        case 10:
            [self setBtnEnabled:after10];
            processStr = @"发球";
            break;
        case 20:
            [self setBtnEnabled:after20];
            processStr = @"一传";
            break;
        case 30:
            [self setBtnEnabled:after30];
            break;
        case 40:
            [self setBtnEnabled:after4050];
            break;
        case 50:
            [self setBtnEnabled:after4050];
            break;
        case 60:
            [self setBtnEnabled:after60];
            break;
        case 70:
            [self setBtnEnabled:nil];
            break;
        case 80:
            [self setBtnEnabled:nil];
            break;
        default:
            break;
    }
    NSString *clickedBtn;
    NSString *doneProcess;
    if (sender.tag == 0){
        clickedBtn = sender.titleLabel.text;
        doneProcess = clickedBtn;
        [self addToScore:sender detail:doneProcess];
    }else{
        Players *player = [self.view viewWithTag:(sender.tag-1)/10];
        NSString *position = [NSString stringWithFormat:@"%@号 ",player.number.text];
        clickedBtn = [position stringByAppendingString:processStr];
        clickedBtn = [clickedBtn stringByAppendingString:sender.titleLabel.text];
        doneProcess = [processStr stringByAppendingString:sender.titleLabel.text];
        [self addToScore:sender detail:doneProcess];
        NSLog(@"doneprocess:%@",doneProcess);
    }
    //结束当前局判断
    if ([sender.currentTitle isEqualToString:@"失误"]||[sender.currentTitle isEqualToString:@"得分"]||[sender.currentTitle isEqualToString:@"拦失"]||[sender.currentTitle isEqualToString:@"犯规"]||[sender.currentTitle isEqualToString:@"被拦死"]||[sender.currentTitle isEqualToString:@"扣失"]||[sender.currentTitle isEqualToString:@"失分"]||[sender.currentTitle isEqualToString:@"对方发失"]||[sender.currentTitle isEqualToString:@"对方其他失"]||[sender.currentTitle isEqualToString:@"对方扣失"]||[sender.currentTitle isEqualToString:@"对方犯规"]) {
        for(UIView *view in [self.process subviews]) {
            [view removeFromSuperview];
        }
        [self setBtnEnabled:nil];
        x = 10;
        if ([sender.currentTitle isEqualToString:@"得分"]||[sender.currentTitle isEqualToString:@"对方发失"]||[sender.currentTitle isEqualToString:@"对方扣失"]||[sender.currentTitle isEqualToString:@"对方犯规"]||[sender.currentTitle isEqualToString:@"对方其他失"]) {
            scoreTeamA++;
            //轮转站位
            if (lastScore == 2){
                Players *stance1 = self.positionArray[5];
                Players *stance2 = self.positionArray[2];
                Players *stance3 = self.positionArray[1];
                Players *stance4 = self.positionArray[0];
                Players *stance5 = self.positionArray[3];
                Players *stance6 = self.positionArray[4];
                Players *tmpPlayer = [[Players alloc]init];
                tmpPlayer = stance6;
                stance6 = stance1;
                stance1 = stance2;
                stance2 = stance3;
                stance3 = stance4;
                stance4 = stance5;
                stance5 = tmpPlayer;
                self.positionArray[5] = stance1;
                self.positionArray[2] = stance2;
                self.positionArray[1] = stance3;
                self.positionArray[0] = stance4;
                self.positionArray[3] = stance5;
                self.positionArray[4] = stance6;
                Players *tmp = [[Players alloc]init];
                Players *p4 = [self.view viewWithTag:1];
                Players *p3 = [self.view viewWithTag:2];
                Players *p2 = [self.view viewWithTag:3];
                Players *p5 = [self.view viewWithTag:4];
                Players *p6 = [self.view viewWithTag:5];
                Players *p1 = [self.view viewWithTag:6];
                tmp.frame = p1.frame;
                [tmp setPlayerNumber:p1.number.text playername:p1.name.text playerposition:p1.number.backgroundColor];
                tmp.number.text = p1.number.text;
                tmp.name.text = p1.name.text;
                tmp.number.backgroundColor = p1.number.backgroundColor;
                p1.number.text = p2.number.text;
                p1.name.text = p2.name.text;
                p1.number.backgroundColor = p2.number.backgroundColor;
                p2.number.text = p3.number.text;
                p2.name.text = p3.name.text;
                p2.number.backgroundColor = p3.number.backgroundColor;
                p3.number.text = p4.number.text;
                p3.name.text = p4.name.text;
                p3.number.backgroundColor = p4.number.backgroundColor;
                p4.number.text = p5.number.text;
                p4.name.text = p5.name.text;
                p4.number.backgroundColor = p5.number.backgroundColor;
                p5.number.text = p6.number.text;
                p5.name.text = p6.name.text;
                p5.number.backgroundColor = p6.number.backgroundColor;
                p6.number.text = tmp.number.text;
                p6.name.text = tmp.name.text;
                p6.number.backgroundColor = tmp.number.backgroundColor;
            }
            lastScore = 1;
            resultStr = [NSString stringWithFormat:@"%@ %d",clickedBtn,scoreTeamA];
            resultMuStr = [[NSMutableAttributedString alloc]initWithString:resultStr];
            if (scoreTeamA<10) {
                [resultMuStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(resultStr.length-1, 1)];
            }else{
                [resultMuStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(resultStr.length-2, 2)];
            }
            [self addToChart:1];
            [self isNextTurn];
            UIButton *fa = [self.chooseView viewWithTag:10];
            self.tmpBtn.selected = NO;
            fa.selected = YES;
            self.tmpBtn = fa;
            [self hidePlayers:NO];
            NSArray *start = [NSArray arrayWithObjects:@"得分",@"到位",@"能攻",@"破攻",@"失误", nil];
            [self buildProcessTable:start];
            [self selectStartPlayer:start];
            if (scoreTeamA == 0 && scoreTeamB == 0){
                lastScore = 1;
            }else{
                [self setBtnEnabled:@[@"20",@"30",@"40",@"50",@"60",@"70"]];
            }
            NSString *title = [NSString stringWithFormat:@"第%d局\t\t\t总比分\t\t\t%d  :  %d\t\t\t小比分\t\t\t%d  :  %d",turns,bigScoreA,bigScoreB,scoreTeamA,scoreTeamB];
            self.navigationItem.title = title;
            self.navigationController.navigationBar.titleTextAttributes = @{
                                                                            NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                            NSFontAttributeName:[UIFont systemFontOfSize:16]
                                                                            };
        }else{
            scoreTeamB++;
            lastScore = 2;
            Players *player = [self.view viewWithTag:(sender.tag-1)/10];
            clickedBtn = processStr;
            clickedBtn = [clickedBtn stringByAppendingString:sender.titleLabel.text];
            clickedBtn = [clickedBtn stringByAppendingString:[NSString stringWithFormat:@" %@号",player.number.text]];
            resultStr = [NSString stringWithFormat:@"%d %@",scoreTeamB,clickedBtn];
            resultMuStr = [[NSMutableAttributedString alloc]initWithString:resultStr];
            if (scoreTeamB<10) {
                [resultMuStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
            }else{
                [resultMuStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
            }
            [self addToChart:2];
            [self isNextTurn];
            UIButton *fa = [self.chooseView viewWithTag:20];
            self.tmpBtn.selected = NO;
            fa.selected = YES;
            self.tmpBtn = fa;
            [self hidePlayers:NO];
            NSArray *first = [NSArray arrayWithObjects:@"到位",@"能攻",@"破攻",@"失误", nil];
            [self buildProcessTable:first];
            if (scoreTeamA == 0 && scoreTeamB == 0){
                lastScore = 1;
            }else{
                [self setBtnEnabled:@[@"10",@"30",@"40",@"50",@"60",@"70"]];
            }
            NSString *title = [NSString stringWithFormat:@"第%d局\t\t\t总比分\t\t\t%d  :  %d\t\t\t小比分\t\t\t%d  :  %d",turns,bigScoreA,bigScoreB,scoreTeamA,scoreTeamB];
            self.navigationItem.title = title;
            self.navigationController.navigationBar.titleTextAttributes = @{
                                                                            NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                            NSFontAttributeName:[UIFont systemFontOfSize:16]
                                                                            };
        }
    }else{
        clickedBtn = [clickedBtn stringByAppendingString:@"→"];
    }
    NSLog(@"%@",clickedBtn);
    float y = 0;
    float width = self.processView.frame.size.width/5;
    float height = self.processView.frame.size.height;
    self.process.contentSize = CGSizeMake(x+width, 0);
    if (x > self.processView.frame.size.width) {
        self.process.contentOffset = CGPointMake(x+width-self.processView.frame.size.width, 0);
    }
    UILabel *processBtn = [[UILabel alloc]initWithFrame:CGRectMake(x, y, width, height)];
    x += width;
    processBtn.text = clickedBtn;
    if ((processBtn.frame.origin.x == 10 || processBtn.frame.origin.x == 10 + width)&&(scoreTeamA == 0 && scoreTeamB == 0)) {
        if ([processBtn.text containsString:@"一传"]) {
            lastScore = 2;
        }
    }
    processBtn.textColor = [UIColor whiteColor];
    processBtn.font = [UIFont systemFontOfSize:17];
    [self.process addSubview:processBtn];
    [processBtn d3_fadeIn];
}

//添加到趋势图
- (void) addToChart:(int)side{
    if (side==1) {//我方得分
        UILabel *res = [[UILabel alloc]init];
        res.frame = CGRectMake(0, y, self.tendencyChart.frame.size.width*0.4, self.tendencyChart.frame.size.height/5);
        res.attributedText = resultMuStr;
        res.adjustsFontSizeToFitWidth = YES;
        y += res.frame.size.height;
        [self.tendencyChart addSubview:res];
        [res d3_fadeIn];
        UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"竖线"]];
        line.frame = CGRectMake(res.frame.origin.x+res.frame.size.width+self.tendencyChart.frame.size.width*0.05, res.frame.origin.y, 5, self.tendencyChart.frame.size.height/5);
        [self.tendencyChart addSubview:line];
        [line d3_fadeIn];
    }else{
        UILabel *res = [[UILabel alloc]init];
        res.frame = CGRectMake(self.tendencyChart.frame.size.width*0.6, y, self.tendencyChart.frame.size.width*0.4, self.tendencyChart.frame.size.height/5);
        res.attributedText = resultMuStr;
        res.adjustsFontSizeToFitWidth = YES;
        y += res.frame.size.height;
        [self.tendencyChart addSubview:res];
        [res d3_fadeIn];
        UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"竖线"]];
        line.frame = CGRectMake(res.frame.origin.x-self.tendencyChart.frame.size.width*0.05-5, res.frame.origin.y, 5, self.tendencyChart.frame.size.height/5);
        [self.tendencyChart addSubview:line];
        [line d3_fadeIn];
    }
    self.tendencyChart.contentSize = CGSizeMake(0, y+self.tendencyChart.frame.size.height/5);
    if (y > self.tendencyChart.frame.size.height) {
        self.tendencyChart.contentOffset = CGPointMake(0, y-self.tendencyChart.frame.size.height);
    }
}

- (void)saveToPlistWithScoreArr:(NSArray *)scoreArr {
    // 获取路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"scoreList.plist"];
    NSFileManager *fileM = [NSFileManager defaultManager];
    // 判断文件是否存在，不存在则直接创建，存在则直接取出文件中的内容
    if (![fileM fileExistsAtPath:filePath]) {
        [fileM createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSMutableArray *scoreListArr = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if ((scoreListArr.count == 0)) {
        scoreListArr = [NSMutableArray arrayWithCapacity:1];
    }
    // 归档
    [scoreListArr addObject:scoreArr];
    BOOL didSucceed = [NSKeyedArchiver archiveRootObject:scoreListArr toFile:filePath];
    if (!didSucceed) {
        NSLog(@"error");
    }
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    /*
     这是正常的保存和取出数组内容到文件
     存
     [chatLogArray writeToFile:filePath atomically:YES];
     取
     NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:filePath];
     */
    
    
    //    注意 数组中保存的是自定义模型，要想把数组保存在文件中，应该用下面的方法
    //    存
    //    取
//
    NSLog(@"array:%@",array);
}

//比分判断
- (void) isNextTurn {
    if (turns < 5) {
        if (abs(scoreTeamA-scoreTeamB)>=2 && (scoreTeamA>=25||scoreTeamB>=25)) {
            #warning 待完成
            if (turns == 1) {
                gameOne = [NSArray arrayWithArray:self.playerDetailArray];
            }else if(turns == 2){
                
            }
            turns++;
            if (scoreTeamA>scoreTeamB) {
                bigScoreA++;
            }else{
                bigScoreB++;
            }
            scoreTeamA = 0;
            scoreTeamB = 0;
            if (bigScoreA == 3 || bigScoreB == 3) {
                [self.playerDetailArray addObject:duiLoss];
                [self saveToPlistWithScoreArr:self.playerDetailArray];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                NSLog(@"比赛结束");
            }else{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                UIViewController *terminalVC = [sb instantiateViewControllerWithIdentifier:@"tcVC"];
                TerminalChangVC *tcVC = (TerminalChangVC*)terminalVC;
                tcVC.isClickChangeBtn = NO;
                tcVC.receivePlayersArray = self.receivePlayersArray;
                tcVC.positionArray = self.positionArray;
                [self presentViewController:terminalVC animated:YES completion:nil];
            }
        }
    }
    if (turns == 5) {
        if (abs(scoreTeamA-scoreTeamB)>=2 && (scoreTeamA>=15||scoreTeamB>=15)) {
            if (scoreTeamA>scoreTeamB) {
                bigScoreA++;
            }else{
                bigScoreB++;
            }
            scoreTeamA = 0;
            scoreTeamB = 0;
            [self.playerDetailArray addObject:duiLoss];
            [self saveToPlistWithScoreArr:self.playerDetailArray];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            NSLog(@"比赛结束");
        }
    }
}

- (void) addToScore:(UIButton*)sender detail:(NSString*)doneProcess{
    long tagPlayer = (sender.tag-sender.tag%10)/10;
    int tagDetail = 0;
    int tagResult = -1;
    Players *player = [[Players alloc]init];
    PlayerModel *playerDetail = [[PlayerModel alloc]init];
    if (sender.tag != 0) {
        player = [self.view viewWithTag:tagPlayer];
        for (int i = 0 ; i < 14; i++) {
            PlayerModel *playerModel = self.playerDetailArray[i];
            if ([player.number.text isEqualToString:playerModel.number]) {
                playerDetail = playerModel;
                tagDetail = i;
                break;
            }
        }
    }
    if ([doneProcess containsString:@"发球"]) {
        playerDetail.start++;
    }
    if ([doneProcess containsString:@"一传"]) {
        playerDetail.first++;
    }
    if ([doneProcess containsString:@"一攻扣"]) {
        playerDetail.firstKou++;
    }
    if ([doneProcess containsString:@"拦网"]) {
        playerDetail.lan++;
    }
    if ([doneProcess containsString:@"防守"]) {
        playerDetail.fang++;
    }
    if ([doneProcess containsString:@"反击扣"]) {
        playerDetail.fanKou++;
    }
    if ([doneProcess containsString:@"二传及其他"]) {
        playerDetail.second++;
    }
    if ([doneProcess containsString:@"对方"]) {
        duiLoss.duiLoss++;
    }
    NSArray *detail = @[@"发球得分",@"拦网得分",@"一攻扣得分",@"反击扣得分",@"拦网拦失",@"拦网犯规",@"防守失误",@"一攻扣被拦死",@"反击扣被拦死",@"一传失误",@"发球失误",@"一攻扣扣失",@"反击扣扣失",@"其他失分",@"发球失分",@"一传到位",@"防守能攻",@"一攻扣得分",@"反击扣得分",@"对方扣失",@"对方发失",@"对方犯规",@"对方其他失",@"其他得分"];
    for (int i = 0; i < detail.count; i++) {
        if ([doneProcess isEqualToString:detail[i]]) {
            tagResult = i;
            break;
        }
    }
    switch (tagResult) {
        case 0:
            playerDetail.startGet++;
            break;
        case 1:
            playerDetail.lanGet++;
            break;
        case 2:
            playerDetail.firstKouGet++;
            break;
        case 3:
            playerDetail.fanKouGet++;
            break;
        case 4:
            playerDetail.lanShi++;
            break;
        case 5:
            playerDetail.lanGui++;
            break;
        case 6:
            playerDetail.fangShi++;
            break;
        case 7:
            playerDetail.firstKouBeiLanSi++;
            break;
        case 8:
            playerDetail.fanKouBeiLanSi++;
            break;
        case 9:
            playerDetail.firstLoss++;
            break;
        case 10:
            playerDetail.startLoss++;
            break;
        case 11:
            playerDetail.firstKouLoss++;
            break;
        case 12:
            playerDetail.fanKouLoss++;
            break;
        case 13:
            playerDetail.secondLoss++;
            break;
        case 14:
            playerDetail.startLoss++;
            break;
        case 15:
            playerDetail.firstDao++;
            break;
        case 16:
            playerDetail.fangNeng++;
            break;
        case 17:
            playerDetail.firstKouGet++;
            break;
        case 18:
            playerDetail.fanKouGet++;
            break;
        case 19:
            duiLoss.duiKouLoss++;
            break;
        case 20:
            duiLoss.duiStartLoss++;
            break;
        case 21:
            duiLoss.duiGui++;
            break;
        case 22:
            duiLoss.duiElseLoss++;
            break;
        case 23:
            playerDetail.secondGet++;
            break;
        default:
            break;
    }
    [self.playerDetailArray replaceObjectAtIndex:tagDetail withObject:playerDetail];
}
@end
