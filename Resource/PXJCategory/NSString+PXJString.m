//
//  NSString+PXJString.m
//  StockCodeLine
//
//  Created by hh on 16/6/14.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import "NSString+PXJString.h"
#import "NSDate+PXJDate.h"
@implementation NSString (PXJString)
- (NSDate *)transformStringToDate{
    if (self.length == 4 && [self intValue]) {
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        inputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        inputFormatter.locale =[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [inputFormatter setDateFormat:@"MMdd"];
        NSDate *date = [inputFormatter dateFromString:[NSString stringWithFormat:@"%@",self]];
        return date;
    }
    return nil;
}

- (int)ToDateStringSpace:(NSString *)dateString{
    NSDate *date1 = [self transformStringToDate];
    NSDate *date2 = [dateString transformStringToDate];
    return [date1 toDateSpace:date2];
}

- (NSString *)addOneDay{
    NSDate *date = [self transformStringToDate];
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSDate *date2 = [[NSDate alloc] initWithTimeIntervalSince1970:interval+86400];
    NSUInteger month = [date2 getDateMonth];
    NSUInteger day = [date2 getDateDay];
    NSMutableString *string = [NSMutableString string];
    (month<10)?[string appendFormat:@"0%d",month]:[string appendFormat:@"%d",month];
    (day < 10)?[string appendFormat:@"0%d",day]:[string appendFormat:@"%d",day];
    return string;
}
@end
