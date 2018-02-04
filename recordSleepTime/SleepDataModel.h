//
//  sleepDataModel.h
//  recordSleepTime
//
//  Created by 李书通 on 2017/11/30.
//  Copyright © 2017年 李书通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SleepDataModel : NSObject
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *hour;
@property (nonatomic, copy) NSString *quantity;

+(NSMutableArray *)modelArrWithDataArr:(NSArray *)array;

@end
