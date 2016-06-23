//
//  NSString+PXJString.h
//  StockCodeLine
//
//  Created by hh on 16/6/14.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PXJString)

- (NSDate *)transformStringToDate;
- (int)ToDateStringSpace:(NSString *)dateString;
- (NSString *)addOneDay;
@end
