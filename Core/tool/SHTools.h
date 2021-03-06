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
//手机号码验证
+ (BOOL) isValidateMobile:(NSString *)mobile;
//邮箱验证
+ (BOOL)isValidateEmail:(NSString *)email;

+ (NSString *)filterHTML:(NSString *)html;
//低位在前
+ (void) intToBytes:(int) value  byte:(Byte[])src start:(int)start;
//高位在前
+ (Byte*) intToBytes2:(int) value;
/** byte数组中取int数值，本方法适用于(低位在前，高位在后)的顺序，和和intToBytes（）配套使用
 *
 * @param src
 *            byte数组
 * @param offset
 *            从数组的第offset位开始
 * @return int数值
 */
+ (int) bytesToInt: (Byte[]) src offser :(int) offset ;

/**
 * byte数组中取int数值，本方法适用于(低位在后，高位在前)的顺序。和intToBytes2（）配套使用
 */
+ (int) bytesToInt2: (Byte[]) src offser :(int) offset ;
@end
