//
//  StockCodeLineScrollView.h
//  StockCodeLine
//
//  Created by hh on 16/6/14.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    isMax,
    isMin,
    notReminder
}ZoomReminder;

@interface StockCodeLineScrollView : UIScrollView<UIGestureRecognizerDelegate>
@property(nonatomic,assign)CGFloat lastScale;
@property(nonatomic,assign)CGFloat PointSpaceX;
@property(nonatomic,assign)ZoomReminder reminder;
- (void)clearAllPoint;
- (CGPoint)searchTouchNearPoint:(CGPoint)touchPoint;
@end
