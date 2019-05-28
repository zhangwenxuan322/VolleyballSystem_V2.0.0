//
//  ProcessTable.m
//  Volleyball
//
//  Created by 张文轩 on 2018/4/23.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import "ProcessTable.h"
#import "ScoringView.h"
@implementation ProcessTable

- (void)creatTable:(float)gap Height:(float)height Process:(NSArray*)processArray{
    float width = (self.frame.size.width-10*(processArray.count-1))/processArray.count;
    float x = 0;
    float y = 0;
    //按钮表
    for (int i = 1 ; i <= 8 ; i++) {
        for (int j = 1 ; j <= processArray.count; j++){
            UIButton *processBtn = [[UIButton alloc]init];
            processBtn.frame = CGRectMake(x, y, width, height);
            [processBtn setTitle:[[NSString alloc] initWithFormat:@"%@",processArray[j-1]] forState:UIControlStateNormal];
            [processBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
            processBtn.titleLabel.textColor = [UIColor whiteColor];
            processBtn.backgroundColor = [UIColor blueColor];
            processBtn.tag = i*10+j;
            [self addSubview:processBtn];
            x += 10 + width;
        }
        x = 0;
        y += height + gap;
    }
}

- (void)pressBtn:(UIButton*)sender{
    NSString *position = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    _clickedBtn = [position stringByAppendingString:sender.titleLabel.text];
}

@end
