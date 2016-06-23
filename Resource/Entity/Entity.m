//
//  Entity.m
//  StockCodeLine
//
//  Created by hh on 16/6/12.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import "Entity.h"

@implementation Entity
- (id)initWithInfos:(NSDictionary *)infos{
    if (self = [super init]) {
        self.infos = [NSDictionary dictionaryWithDictionary:infos];
    }
    return self;
}
@end

@implementation StockCodeLineDatasEntity

- (id)initWithInfos:(NSDictionary *)infos{
    if (self = [super initWithInfos:infos]) {
        NSArray *tmp = [infos objectForKey:@"data"];
        NSMutableArray *tmp2 = [NSMutableArray array];
        for (int i = 0; i < tmp.count; i++) {
            StockCodeLineSingleDataEntity *s = [StockCodeLineSingleDataEntity StockCodeLineSingleDataWithInfos:[tmp objectAtIndex:i]];
            [tmp2 addObject:s];
        }
        self.mDDatas = tmp2;;
    }
    return self;
}

+ (id)StockCodeLineDatasWithInfos:(NSDictionary *)infos{
    return [[StockCodeLineDatasEntity alloc] initWithInfos:infos];
}

@end

@implementation StockCodeLineSingleDataEntity

+ (id)StockCodeLineSingleDataWithInfos:(NSDictionary *)infos{
    return [[StockCodeLineSingleDataEntity alloc] initWithInfos:infos];
}

- (NSString *)getMData{
    return [self.infos objectForKey:@"data"];
}

//以月日为标准
- (NSString *)getMDate{
    return [self.infos objectForKey:@"date"];
    
}

@end
