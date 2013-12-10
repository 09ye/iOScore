//
//  SHFlowManager.m
//  Core
//
//  Created by sheely on 13-12-10.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHFlowManager.h"
#import "SHPrivateAPI.h"
#import "Reachability.h"

@interface SHFlowManager (private)
{
    
}

@end

@implementation SHFlowManager
@synthesize lastway = _lastway;
@synthesize lastpackage = _lastpackage;
@synthesize upFlow = mUp;
@synthesize downFlow = mDown;
@synthesize lastdate = _lastdate;
@synthesize URL = _URL;

static SHFlowManager * __instance;

+ (SHFlowManager*)instance
{
    if(__instance == nil){
        __instance = [[SHFlowManager alloc]init];
    }
    return __instance;
}

- (id) init
{
    if(self = [super init]){
        @try {
            NSString* base64 = [SHPrivateAPI getPasswordForUsername:@"flow_core" andServiceName:[SHPrivateAPI guid] error:nil];
            if(base64.length > 0){
                NSData * data = [Base64 decode:base64];
                NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
                NSDictionary *myDictionary = [unarchiver decodeObjectForKey:@"flow_core"];
                [unarchiver finishDecoding];
                mUp = ((NSNumber*)[myDictionary valueForKey:@"up"]).longLongValue;
                mDown = ((NSNumber*)[myDictionary valueForKey:@"down"]).longLongValue;
                _lastdate = [myDictionary valueForKey:@"date"];
                
            }else{
                mDown = 0;
                mUp = 0;
                _lastdate = [NSDate date];
            }
        }
        @catch (NSException *exception) {
        }
        @finally {
            
        }
    }
    return self;
}


- (void)setURL:(NSString *)URL_
{
    _URL = URL_;
}

- (void)reFresh
{
    SHPostTaskM* task = [[SHPostTaskM alloc]init];
    if(_URL.length > 0){
        task.URL = _URL;
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setValue:[[NSNumber alloc]initWithLongLong:mUp] forKey:@"up"];
        [params setValue:[[NSNumber alloc]initWithLongLong:mDown] forKey:@"down"];
        [params setValue:_lastdate forKey:@"date"];
        [task.postArgs setValue:params forKey:@"data"];
        task.delegate = self;
        [task start];
    }
   
}

- (void)taskDidFinished:(SHTask*) task
{
    NSDictionary * dic = (NSDictionary*)task.result;
    if([dic.allKeys containsObject:@"up"]){
        mUp += ((NSNumber*)[dic valueForKey:@"up"]).longLongValue;
        mDown += ((NSNumber*)[dic valueForKey:@"down"]).longLongValue;
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _lastdate = [formatter dateFromString:[dic valueForKey:@"date"]];
        [self save];
    }
}

- (void) clear
{
    mUp = 0;
    mDown = 0;
    _lastdate = [NSDate date];
    [self save];
}

- (void) save
{
    @try {
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setValue:[[NSNumber alloc]initWithLongLong:mUp] forKey:@"up"];
        [params setValue:[[NSNumber alloc]initWithLongLong:mDown] forKey:@"down"];
        [params setValue:_lastdate forKey:@"date"];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:params forKey:@"flow_core"];
        [archiver finishEncoding];
        NSString* base64 = [Base64 encode:data];
        [SHPrivateAPI storeUsername:@"flow_core" andPassword:base64 forServiceName:[SHPrivateAPI guid] updateExisting:YES error:nil];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)push:(long ) byte  way: (SHWay) way
{
    _lastpackage = byte;
    _lastway = way;
    @synchronized (__instance)
    {
        if(way == SHWayDown){
            mDown += byte;
        }else{
            mUp += byte;
        }
    }
    if(_lastdate == nil){
        _lastdate = [NSDate date];
        [self save];
    }
    NSDate * date = [NSDate date];
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN){
    int timer = [date timeIntervalSinceDate:_lastdate];
    if(timer > 120){
        _lastdate = date;
        if([SHTools isCurrentMonthByNSDate:_lastdate ]){
            [self clear];
        }
        
        [self save];
    }
//    if (timer > 10){//5小时刷新
//        [self reFresh];
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SHFLOW_PUSH_UPDATE object:nil];
    }
}


@end
