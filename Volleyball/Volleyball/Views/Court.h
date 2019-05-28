//
//  Court.h
//  Volleyball
//
//  Created by 张文轩 on 2018/3/21.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Court : UIView
/**
 * 球场
 */
//@property (nonatomic,strong) UIImageView *smallCourt;
//@property (nonatomic,strong) UIImageView *bigCourt;
//@property (nonatomic,strong) UIView *bigView;
- (void) courtInit:(NSMutableArray*)positionPlayers;
@end
