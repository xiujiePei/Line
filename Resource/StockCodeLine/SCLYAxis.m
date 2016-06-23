//
//  SCLYAxis.m
//  StockCodeLine
//
//  Created by hh on 16/6/12.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import "SCLYAxis.h"

@implementation SCLYAxis

- (id)init{
    if (self = [super init]) {
        self.mLineColor = [UIColor blackColor];
        self.mLineThick = 0.5;
        self.mInset = UIEdgeInsetsMake(10, 30, 10, 0);
        
    }
    return self;
}
- (void)dealloc{
}

- (float)getMaxNumber{
    return [[self.mValue valueForKeyPath:@"@max.floatValue"] floatValue];
}

- (float)getMinNumber{
    return [[self.mValue valueForKeyPath:@"@min.floatValue"] floatValue];
}

@end
