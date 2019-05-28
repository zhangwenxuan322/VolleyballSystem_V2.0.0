//
//  DuiLoss.m
//  Volleyball
//
//  Created by 张文轩 on 2018/4/30.
//  Copyright © 2018年 张文轩. All rights reserved.
//

#import "DuiLoss.h"
#define DuiLoss1 @"duiLoss"
#define DuiKouLoss @"duiKouLoss"
#define DuiStartLoss @"duiStartLoss"
#define DuiGui @"duiGui"
#define DuiElseLoss @"duiElseLoss"
@implementation DuiLoss

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        self.duiLoss = [[aDecoder decodeObjectForKey:DuiLoss1] integerValue];
        self.duiKouLoss = [[aDecoder decodeObjectForKey:DuiKouLoss] integerValue];
        self.duiStartLoss = [[aDecoder decodeObjectForKey:DuiStartLoss] integerValue];
        self.duiGui = [[aDecoder decodeObjectForKey:DuiGui] integerValue];
        self.duiElseLoss = [[aDecoder decodeObjectForKey:DuiElseLoss] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithInteger:self.duiLoss] forKey:DuiLoss1];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.duiKouLoss] forKey:DuiKouLoss];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.duiStartLoss] forKey:DuiStartLoss];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.duiGui] forKey:DuiGui];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.duiElseLoss] forKey:DuiElseLoss];
}

@end
