//
//  SHTool.h
//  Core
//
//  Created by sheely on 13-11-1.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHTools : NSObject
//是不是本周
+ (BOOL)isCurrentWeek:(NSString*) string;
//是不是本月
+ (BOOL) isCurrentMonth:(NSString*) string;
//是不是本季度
+ (BOOL) isCurrentQuarter:(NSString*)  string;

+ (BOOL) isCurrentMonthByNSDate:(NSDate *) date;
//随机数
+ (int) randomNumber:(int)from to:(int)to;
@end
