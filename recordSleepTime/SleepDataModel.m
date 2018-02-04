//
//  sleepDataModel.m
//  recordSleepTime
//
//  Created by 李书通 on 2017/11/30.
//  Copyright © 2017年 李书通. All rights reserved.
//

#import "SleepDataModel.h"

@implementation SleepDataModel

+(NSMutableArray *)modelArrWithDataArr:(NSArray *)array {
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        SleepDataModel *model = [[SleepDataModel alloc] init];
        model.startTime = dic[@"startTime"];
        model.endTime = dic[@"endTime"];
        model.hour = dic[@"hour"];
        model.quantity = dic[@"quantity"];
        [modelArray addObject:model];
    }
    return modelArray;
}
@end
