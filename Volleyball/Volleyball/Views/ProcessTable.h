//
//  ProcessTable.h
//  Volleyball
//
//  Created by 张文轩 on 2018/4/23.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessTable : UIView
/**
 * 过程表
 * 显示各种事件下的分支，如发球->得分、破攻、能攻、到位、失误
 * 提供行间距gap、行高height、事件内容processArray
 */
@property (copy) NSString *clickedBtn;
- (void)creatTable:(float)gap Height:(float)height Process:(NSArray*)processArray;
@end
