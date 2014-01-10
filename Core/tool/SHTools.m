//
//  SHTool.m
//  Core
//
//  Created by sheely on 13-11-1.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHTools.h"

@implementation SHTools

+ (BOOL)isJailbroken {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}

//是不是本周
+ (BOOL)isCurrentWeek:(NSString*) string
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date_= [dateFormatter dateFromString:string];
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    NSDate *today=[NSDate date];
    BOOL success= [cal rangeOfUnit:NSWeekCalendarUnit startDate:&start
                          interval:&extends forDate:today];
    if(!success)
        return NO;
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    if(dateInSecs >= dayStartInSecs && dateInSecs <= (dayStartInSecs + extends)){
        return YES;
    }
    else{
        return NO;
    }
}
//是不是本月
+ (BOOL) isCurrentMonthByNSDate:(NSDate *) date_
{
  
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    NSDate *today=[NSDate date];
    BOOL success= [cal rangeOfUnit:NSMonthCalendarUnit startDate:&start
                          interval:&extends forDate:today];
    if(!success)
        return NO;
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    if(dateInSecs >= dayStartInSecs && dateInSecs <= (dayStartInSecs + extends)){
        return YES;
    }else{
        return NO;
    }

}

+ (BOOL) isCurrentMonth:(NSString*) string
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date_= [dateFormatter dateFromString:string];
    return [self isCurrentMonthByNSDate:date_];
}
//是不是本季度
+ (BOOL) isCurrentQuarter:(NSString*)  string
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date_= [dateFormatter dateFromString:string];
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    NSDate *today=[NSDate date];
    BOOL success= [cal rangeOfUnit:NSQuarterCalendarUnit startDate:&start
                          interval:&extends forDate:today];
    if(!success)
        return NO;
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    if(dateInSecs >= dayStartInSecs && dateInSecs <= (dayStartInSecs + extends)){
        return YES;
    }else{
        return NO;
    }
}

+ (int)randomNumber:(int)from to:(int)to

{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

/*车牌号验证 MODIFIED BY HELENSONG*/
+ (BOOL) validateCarNo:(NSString *) carNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}
@end
