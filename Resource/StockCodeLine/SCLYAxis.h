//
//  SCLYAxis.h
//  StockCodeLine
//
//  Created by hh on 16/6/12.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SCLYAxis : NSObject
@property(nonatomic,strong)NSArray *mValue;
@property(nonatomic,assign,readonly,getter=getMaxNumber)float maxNumber;
@property(nonatomic,assign,readonly,getter=getMinNumber)float minNumber;

@property(nonatomic,strong)UIColor *mLineColor;
@property(nonatomic,assign)float mLineThick;
@property(nonatomic,assign)UIEdgeInsets mInset;
@property(nonatomic,assign)float mLineLongth;

@end

//缩放因子有很大的作用1~2之间
/**
 *  1.可用于确定X轴的时间范围
 *  2.可用于确定Y轴的最大值与最小值
 */
