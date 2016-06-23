//
//  SCLXAxis.m
//  StockCodeLine
//
//  Created by hh on 16/6/12.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import "SCLXAxis.h"

@implementation SCLXAxis

- (id)init{
    if (self = [super init]) {
        self.mLineColor = [UIColor blackColor];
        self.mLineThick = 0.5;
        self.mInset = UIEdgeInsetsMake(0, 30, 10, 30);
    }
    return self;
}

- (void)dealloc{
}

@end
