//
//  StockCodeLineView.h
//  StockCodeLine
//
//  Created by hh on 16/6/12.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StockCodeLineDatasEntity;
@interface StockCodeLineView : UIView

@property(nonatomic,strong,setter=setSCLData:)StockCodeLineDatasEntity *SCLData;
@end

#define lblTag 70001
@interface PXJLinePoint : UIView
@property(nonatomic,strong)UIColor *pointColor;
@property(nonatomic,assign)BOOL isHollow;//是否空心
/*
 显示数值区设置
 */
@property(nonatomic,assign)BOOL isShowNumber;
@property(nonatomic,strong)UIColor *numberColor;
@property(nonatomic,strong)UIFont *numberFont;
@property(nonatomic,strong)NSString *number;

@end


