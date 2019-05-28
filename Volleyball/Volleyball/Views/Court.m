//
//  Court.m
//  Volleyball
//
//  Created by 张文轩 on 2018/3/21.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import "Court.h"
#import "Players.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@implementation Court

- (void) courtInit:(NSMutableArray*)positionPlayers{
    //小图
    UIImageView *court = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    UIImage *courtImg = [UIImage imageNamed:@"沙盘"];
    court.image = courtImg;
    [self addSubview:court];
    NSArray *position = [NSArray arrayWithArray:positionPlayers];
    if (positionPlayers != nil) {
        //站位球员
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 3; j++) {
                Players *player = position[i*3+j];
                Players *changePlayer = [[Players alloc]init];
                changePlayer.frame = CGRectMake(self.frame.size.width*0.4-i*self.frame.size.width*0.2, self.frame.size.height*0.25+j*self.frame.size.height*0.2, 50.0/(SCREEN_HEIGHT*0.8)*self.frame.size.height, 50.0/(SCREEN_HEIGHT*0.8)*self.frame.size.height);
                [changePlayer setPlayerNumber:player.number.text playername:player.name.text playerposition:player.number.backgroundColor];
                [self addSubview:changePlayer];
            }
        }
    }
}
@end
