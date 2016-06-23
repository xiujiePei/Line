//
//  StockCodeLineScrollView.m
//  StockCodeLine
//
//  Created by hh on 16/6/14.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import "StockCodeLineScrollView.h"
#import "StockCodeLineView.h"
#import "MBProgressHUD.h"


@interface StockCodeLineScrollView()<UIScrollViewDelegate>
{
    //十字线
    CAShapeLayer *verticalLine;
    CAShapeLayer *horizontalLine;
    
    //缩放手势
    UIPinchGestureRecognizer *_pin;
    
    //触碰最近点
    PXJLinePoint *searchPoint;
}
@end
@implementation StockCodeLineScrollView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //[self addObserverToKeyPath];
        verticalLine = [CAShapeLayer layer];
        verticalLine.lineCap = kCALineCapSquare;
        verticalLine.fillColor = [[UIColor clearColor] CGColor];
        verticalLine.lineWidth = 0.5;
        verticalLine.strokeEnd = 0.0f;
        verticalLine.strokeColor = [[UIColor greenColor] CGColor];
        //[self.layer addSublayer:verticalLine];
        
        horizontalLine = [CAShapeLayer layer];
        horizontalLine.lineCap = kCALineCapSquare;
        horizontalLine.fillColor = [[UIColor clearColor] CGColor];
        horizontalLine.lineWidth = 0.5;
        horizontalLine.strokeEnd = 0.0f;
        horizontalLine.strokeColor = [[UIColor greenColor] CGColor];
        //[self.layer addSublayer:horizontalLine];
        
        self.lastScale = 1;
        
        self.delegate = self;
        
        //缩放手势
        _pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureSelector:)];
        //_pin.delegate = self;
        [self addGestureRecognizer:_pin];
        
    }
    return self;
}

- (void)dealloc{
    
}

#pragma mark - public
- (void)clearAllPoint{
    NSArray *arr = [self subviews];
    for (UIView *v in arr) {
        if ([v isKindOfClass:[PXJLinePoint class]]) {
            [v removeFromSuperview];
        }
    }
}

- (CGPoint)searchTouchNearPoint:(CGPoint)touchPoint{
    NSArray *arr = [self subviews];
    CGPoint nearPoint ;
    CGFloat nearSpace = MAXFLOAT;
    for (UIView *v in arr) {
        if ([v isKindOfClass:[PXJLinePoint class]]) {
            //当然只在
            CGPoint point = v.center;
            CGFloat space = (touchPoint.x-point.x)*(touchPoint.x-point.x)+(touchPoint.y-point.y)*(touchPoint.y-point.y);
            if (nearSpace > space) {
                nearSpace = space;
                nearPoint = point;
                searchPoint = (PXJLinePoint *)v;
                if (nearSpace <= (self.PointSpaceX/2)*(self.PointSpaceX/2)) {
                    break;
                }
            }
        }
    }
    return nearPoint;
}

#pragma mark - UIPinchGestureRecognizer响应
- (void)pinchGestureSelector:(UIPinchGestureRecognizer *)pinchGesture{
    if ([pinchGesture.view isKindOfClass:[StockCodeLineScrollView class]]) {
        if (pinchGesture.scale > 2) {
            //回调提示最大
            //定义一个block
            self.reminder = isMax;
            self.lastScale = 2;
        }else if(pinchGesture.scale < 0.5){
            //回调提示最小
            self.reminder = isMin;
            self.lastScale = 0.5;
        }else{
            self.lastScale = pinchGesture.scale;
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeCrossCurve];
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    [self addCrossCurve:touch];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeCrossCurve];
    UITouch *touch = [touches anyObject];
    [self addCrossCurve:touch];
    [self removeCrossCurve];
}

- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self removeCrossCurve];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeCrossCurve];
}


#pragma mark - 十字线的添加与移除

- (void)addCrossCurve:(UITouch *)touch{
    //添加到固定位置
    CGPoint point = [touch locationInView:self];
    
    CGFloat X = [self searchTouchNearPoint:point].x;
    CGFloat Y = [self searchTouchNearPoint:point].y;
    //添加横线
    UIBezierPath *horizontalPath = [UIBezierPath bezierPath];
    [horizontalPath setLineWidth:self.frame.size.width];
    [horizontalPath setLineCapStyle:kCGLineCapSquare];
    [horizontalPath moveToPoint:CGPointMake(X, 0)];
    [horizontalPath addLineToPoint:CGPointMake(X, self.contentSize.height)];
    
    horizontalLine.strokeEnd = 1.0;
    horizontalLine.path = horizontalPath.CGPath;
    [self.layer addSublayer:horizontalLine];
    //添加竖线
    UIBezierPath *verticalPath = [UIBezierPath bezierPath];
    [verticalPath setLineWidth:self.frame.size.width];
    [verticalPath setLineCapStyle:kCGLineCapSquare];
    [verticalPath moveToPoint:CGPointMake(0, Y)];
    [verticalPath addLineToPoint:CGPointMake(self.contentSize.width, Y)];
    
    
    verticalLine.strokeEnd = 1.0;
    verticalLine.path = verticalPath.CGPath;
    [self.layer addSublayer:verticalLine];
    searchPoint.isShowNumber = YES;
}

- (void)removeCrossCurve{
    [horizontalLine removeFromSuperlayer];
    [verticalLine removeFromSuperlayer];
    
    searchPoint.isShowNumber = NO;
}
@end
