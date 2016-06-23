//
//  SCLXAxis.h
//  StockCodeLine
//
//  Created by hh on 16/6/12.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SCLXAxis : NSObject
@property(nonatomic,assign)float scale;
@property(nonatomic,strong)NSArray *mDate;

@property(nonatomic,strong)UIColor *mLineColor;
@property(nonatomic,assign)float mLineThick;
@property(nonatomic,assign)UIEdgeInsets mInset;
@property(nonatomic,assign)float mLineLongth;
@end
