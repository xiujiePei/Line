//
//  Entity.h
//  StockCodeLine
//
//  Created by hh on 16/6/12.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entity : NSObject
@property(nonatomic,strong)NSDictionary *infos;
- (id)initWithInfos:(NSDictionary *)infos;
@end

@interface StockCodeLineDatasEntity : Entity

@property(nonatomic,strong)NSArray *mDDatas;
+ (id)StockCodeLineDatasWithInfos:(NSDictionary *)infos;
@end


@interface StockCodeLineSingleDataEntity : Entity

@property(nonatomic,strong,readonly,getter=getMData)NSString *mData;
@property(nonatomic,strong,readonly,getter=getMDate)NSString *mDate;

+ (id)StockCodeLineSingleDataWithInfos:(NSDictionary *)infos;
@end
