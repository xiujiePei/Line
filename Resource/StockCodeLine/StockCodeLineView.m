//
//  StockCodeLineView.m
//  StockCodeLine
//
//  Created by hh on 16/6/12.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import "StockCodeLineView.h"
#import "SCLXAxis.h"
#import "SCLYAxis.h"
#import "SCLXYValues.h"
#import "Entity.h"
#import "NSDate+PXJDate.h"
#import "NSString+PXJString.h"

#import "StockCodeLineScrollView.h"
#import "MBProgressHUD.h"
#define leftMargin 30
#define rightMargin 30
#define topMargin 10
#define bottomMargin 10

#define ScrollViewLeftMargin 10
#define ScrollViewRightMargin 10

#define ScaleMax 2
#define ScaleInitValue 1
#define ScaleMin 0.5
@interface StockCodeLineView(){
    //x,y等相关
    SCLXAxis *xAxis;
    SCLYAxis *yAxis;
    SCLXYValues *xyValues;
    
    //最大最小值显示
    UILabel *maxLabel;
    UILabel *minLabel;
    //
    StockCodeLineScrollView *_scrollView;//折线图区域
    CAShapeLayer *_lineChartLine;//折线
    //
    float _scale;//缩放因子，初始值为1，变化范围0.5~2
    CGFloat widthX;//根据缩放因子获得的点间距
    //
    StockCodeLineDatasEntity *_SCLData;//数据源
    
    MBProgressHUD *progressView;
}

- (void)showProgressViewWithMessageContent:(NSString *)MessageContent;
@end
@implementation StockCodeLineView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _scale = ScaleInitValue;
        
        _scrollView = [[StockCodeLineScrollView alloc] initWithFrame:CGRectMake(leftMargin, 0, frame.size.width-leftMargin-rightMargin, frame.size.height)];
        _scrollView.contentSize = _scrollView.frame.size;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        
        //利用KVO&KVC观察缩放因子的改变
        [_scrollView addObserver:self forKeyPath:@"lastScale" options:NSKeyValueObservingOptionNew context:nil];
        [_scrollView addObserver:self forKeyPath:@"reminder" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)dealloc{
    [self removeObserver:_scrollView forKeyPath:@"lastScale"];
    [self removeObserver:_scrollView forKeyPath:@"reminder"];
}

- (void)setSCLData:(StockCodeLineDatasEntity *)SCLData{
    //设置X轴
    _SCLData = SCLData;
    {
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (int i = 0; i < _SCLData.mDDatas.count; i++) {
            StockCodeLineSingleDataEntity *SCLLSData = [_SCLData.mDDatas objectAtIndex:i];
            [tmpArr addObject:SCLLSData.mDate];
        }
        xAxis = [[SCLXAxis alloc] init];
        xAxis.mDate = tmpArr;
        xAxis.mLineLongth = self.frame.size.width - xAxis.mInset.left - xAxis.mInset.right;
    }
    
    //设置Y轴
    {
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (int i = 0; i < _SCLData.mDDatas.count; i++) {
            StockCodeLineSingleDataEntity *SCLLSData = [_SCLData.mDDatas objectAtIndex:i];
            [tmpArr addObject:SCLLSData.mData];
        }
        yAxis = [[SCLYAxis alloc] init];
        yAxis.mValue = tmpArr;
        yAxis.mLineLongth = self.frame.size.height - yAxis.mInset.top - yAxis.mInset.bottom;
    }
    //设置
    {
        NSMutableArray *tmpArr = [NSMutableArray array];
        StockCodeLineSingleDataEntity *pre = _SCLData.mDDatas.firstObject;
        [tmpArr addObject:pre];
        for (int i = 1; i < _SCLData.mDDatas.count; i++) {
            StockCodeLineSingleDataEntity *SCLS = [_SCLData.mDDatas objectAtIndex:i];
            int spaceDate = [pre.mDate ToDateStringSpace:SCLS.mDate];
            float spaceData = [SCLS.mData floatValue] - [pre.mData floatValue];
            float spaceData2 ;
            
            if (spaceDate == -1 || spaceDate == 0) {
                //continue;
            }else{
                spaceData2 = spaceData/spaceDate;
                
                for (int i = 0; i < spaceDate -1 ; i++) {
                    
                    NSString *date = [pre.mDate addOneDay];
                    
                    NSString *data = [NSString stringWithFormat:@"%.2f",[pre.mData floatValue]+ spaceData2];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:data,@"data",date,@"date", nil];
                    StockCodeLineSingleDataEntity *s = [StockCodeLineSingleDataEntity StockCodeLineSingleDataWithInfos:dic];
                    [tmpArr addObject:s];
                    pre = s;
                }
            }
            
            [tmpArr addObject:SCLS];
            pre = SCLS;
            
        }
        
        xyValues = [[SCLXYValues alloc] init];
        xyValues.mXYValue = tmpArr;
    }
    
}

- (void)drawRect:(CGRect)rect{
    [self drawYAxis];
    [self drawXAxis];
    [self drawXYValue];
}

- (void)drawXAxis{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, yAxis.mLineColor.CGColor);
    CGContextSetLineWidth(context, yAxis.mLineThick);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextMoveToPoint(context, yAxis.mInset.left, yAxis.mInset.top + yAxis.mLineLongth);
    CGContextAddLineToPoint(context, yAxis.mInset.left + xAxis.mLineLongth,yAxis.mInset.top + yAxis.mLineLongth);
    CGContextStrokePath(context);
}

- (void)drawYAxis{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, yAxis.mLineColor.CGColor);
    CGContextSetLineWidth(context, yAxis.mLineThick);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextMoveToPoint(context, yAxis.mInset.left, 0);
    CGContextAddLineToPoint(context, yAxis.mInset.left,yAxis.mInset.top + yAxis.mLineLongth+yAxis.mInset.bottom);
    CGContextStrokePath(context);
    //显示最高最低价
    if (maxLabel == nil) {
        maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, yAxis.mInset.top-5, yAxis.mInset.left-2, 10)];
        //maxLabel.backgroundColor = [UIColor redColor];
        maxLabel.font = [UIFont systemFontOfSize:13.0];
        maxLabel.adjustsFontSizeToFitWidth = YES;
        maxLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:maxLabel];
    }
    maxLabel.text = [NSString stringWithFormat:@"%.2f",yAxis.maxNumber];
    if (minLabel == nil) {
        minLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, yAxis.mInset.top + yAxis.mLineLongth - 5, yAxis.mInset.left-2, 10)];
        //minLabel.backgroundColor = [UIColor redColor];
        minLabel.font = [UIFont systemFontOfSize:13.0];
        minLabel.adjustsFontSizeToFitWidth = YES;
        minLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:minLabel];
    }
    minLabel.text = [NSString stringWithFormat:@"%0.2f",yAxis.minNumber];
}

- (void)drawXYValue{
    [_scrollView clearAllPoint];
    
    CGFloat c = 20 / _scale;//根据缩放因子计算可显示的最大天数
    CGFloat width = (xyValues.mXYValue.count/c)*(_scrollView.frame.size.width-ScrollViewLeftMargin);
    _scrollView.contentSize = CGSizeMake(width+ScrollViewLeftMargin+ScrollViewRightMargin, _scrollView.frame.size.height);
    
    //根据缩放因子计算点中间的间隔
    widthX = width / (xyValues.mXYValue.count-1);
    _scrollView.PointSpaceX = widthX;
    if (_lineChartLine == nil) {
        _lineChartLine = [CAShapeLayer layer];
        _lineChartLine.lineCap = kCALineCapButt;
        _lineChartLine.fillColor = [[UIColor clearColor] CGColor];
        _lineChartLine.lineWidth = xyValues.lineWidth;
        _lineChartLine.strokeEnd = 0.0f;
        [_scrollView.layer addSublayer:_lineChartLine];
    }
    _lineChartLine.strokeColor = [xyValues.lineColor CGColor];
    
    UIBezierPath *_lineChartPath = [UIBezierPath bezierPath];
    [_lineChartPath setLineWidth:_scrollView.frame.size.width];
    [_lineChartPath setLineCapStyle:kCGLineCapSquare];
    
    CGFloat value = yAxis.mLineLongth / (yAxis.maxNumber - yAxis.minNumber);
    StockCodeLineSingleDataEntity *s = [xyValues.mXYValue objectAtIndex:0];
    CGFloat StartY = topMargin + value * (yAxis.maxNumber - s.mData.floatValue);
    CGFloat StartX = ScrollViewLeftMargin;
    [_lineChartPath moveToPoint:CGPointMake(StartX, StartY)];
    
    PXJLinePoint *point = [[PXJLinePoint alloc] initWithFrame:CGRectMake(2, 2, 6, 6)];
    point.center = CGPointMake(StartX, StartY);
    point.isShowNumber = YES;
    point.pointColor = xyValues.lineColor;
    point.number = [self getShowString:s];
    [_scrollView addSubview:point];
    for (int i = 1; i < xyValues.mXYValue.count; i++) {
        StockCodeLineSingleDataEntity *s = [xyValues.mXYValue objectAtIndex:i];
        CGFloat X = ScrollViewLeftMargin + widthX*i;
        CGFloat Y = topMargin + value * (yAxis.maxNumber - s.mData.floatValue);
        [_lineChartPath addLineToPoint:CGPointMake(X, Y)];
        PXJLinePoint *point = [[PXJLinePoint alloc] initWithFrame:CGRectMake(2, 2, 6, 6)];
        point.isShowNumber = YES;
        point.center = CGPointMake(X,Y);
        point.number = [self getShowString:s];
        point.pointColor = xyValues.lineColor;
        [_scrollView addSubview:point];
    }
    _lineChartLine.strokeEnd = 1.0;
    _lineChartLine.path = _lineChartPath.CGPath;
}

#pragma mark - private

- (NSString *)getShowString:(StockCodeLineSingleDataEntity *)s{
    NSDate *date = [s.mDate transformStringToDate];
    NSUInteger month = [date getDateMonth];
    NSUInteger day = [date getDateDay];
    NSString *showString = [NSString stringWithFormat:@"(%lu月%lu日 %@)",(unsigned long)month,(unsigned long)day,s.mData];
    return showString;
}

- (UIBezierPath *)getCircleBezierPathWithR:(CGFloat)R withCenter:(CGPoint)center{
    return [UIBezierPath bezierPathWithArcCenter:center radius:R startAngle:0 endAngle:M_PI*2.0f clockwise:YES];
    
}

#pragma mark - KVO&KVC

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"lastScale"]){
        _scale = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        [self setNeedsDisplay];
    }else if ([keyPath isEqualToString:@"reminder"]){
        ZoomReminder reminder = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        if (reminder == isMax) {
            [self showProgressViewWithMessageContent:@"已经放大到最大"];
        }else if (reminder == isMin){
            [self showProgressViewWithMessageContent:@"已经缩小到最小"];
        }
    }
}

#pragma mark - 提示部分
- (void)showProgressViewWithMessageContent:(NSString *)MessageContent{
    progressView = [MBProgressHUD showHUDAddedTo:self animated:YES];
    progressView.color = [UIColor grayColor];
    progressView.mode = MBProgressHUDModeText;
    progressView.detailsLabelText = MessageContent;
    progressView.removeFromSuperViewOnHide = YES;
    [progressView hide:YES afterDelay:2];
    [self bringSubviewToFront:progressView];
}

@end

#define fontSize 8.0
#define labelHeight 15.0
@interface PXJLinePoint(){
    UILabel *lbl;
    
    CGFloat _numberWidth;
}
@end
@implementation PXJLinePoint

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = NO;
        //self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        self.layer.borderWidth = 2;
        [self setPXJLinePointDefault];
    }
    return self;
}

- (void)setPXJLinePointDefault{
    self.pointColor = [UIColor greenColor];
    self.isHollow = YES;
    
    self.numberColor = [UIColor grayColor];
    self.numberFont = [UIFont systemFontOfSize:fontSize];
    
    lbl = [[UILabel alloc] init];
    lbl.textColor = self.numberColor;
    lbl.font = self.numberFont;
    lbl.textAlignment = NSTextAlignmentCenter;
    
}

- (void)setIsHollow:(BOOL)isHollow{
    if (isHollow) {
        self.backgroundColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = self.pointColor;
    }
}

- (void)setPointColor:(UIColor *)pointColor{
    self.layer.borderColor = [pointColor CGColor];
}

- (void)setIsShowNumber:(BOOL)isShowNumber{
    if (isShowNumber) {
        [self addSubview:lbl];
        lbl.text = self.number;
        _numberWidth = [self WidthForString:self.number withLabelHeight:labelHeight];
        lbl.frame = CGRectMake(0, 0, _numberWidth+10, labelHeight+10);
        lbl.center = CGPointMake(lbl.frame.size.width/2-self.frame.size.width/2, lbl.frame.size.height/2-self.frame.size.height/2);
    }else{
        [lbl removeFromSuperview];
    }
}


- (CGFloat)WidthForString:(NSString *)aString withLabelHeight:(CGFloat)height{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:aString?aString:@""];
    [string addAttribute:NSFontAttributeName value:self.numberFont range:NSMakeRange(0, string.length)];
    [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, string.length)];
    CGRect r = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    CGFloat w = r.size.width + 10;
    return w;
}

@end
