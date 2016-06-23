//
//  NSDate+PXJDate.m
//  StockCodeLine
//
//  Created by hh on 16/6/14.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import "NSDate+PXJDate.h"

@implementation NSDate (PXJDate)

- (NSUInteger)getDateYear{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *component = [calendar components:unitFlags fromDate:self];
    NSInteger year = [component year];
    return year;
}

- (NSUInteger)getDateMonth{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *component = [calendar components:unitFlags fromDate:self];
    NSInteger month = [component month];
    return month;
}

- (NSUInteger)getDateDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *component = [calendar components:unitFlags fromDate:self];
    NSInteger day = [component day];
    return day;
}

- (int)toDateSpace:(NSDate *)date{
    NSTimeInterval late = [date timeIntervalSince1970]*1;
    NSTimeInterval before = [self timeIntervalSince1970];
    
    NSTimeInterval space = late - before;
    
    if (space/86400 > 1 || space/86400 < -1) {
        NSString *timeString = [NSString stringWithFormat:@"%f",space/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        return [timeString intValue];
    }
    return -1;
}

@end
