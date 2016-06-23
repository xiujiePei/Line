//
//  NSDate+PXJDate.h
//  StockCodeLine
//
//  Created by hh on 16/6/14.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PXJDate)
- (NSUInteger)getDateYear;
- (NSUInteger)getDateMonth;
- (NSUInteger)getDateDay;

- (int)toDateSpace:(NSDate *)date;
@end
