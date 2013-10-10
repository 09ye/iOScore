//
//  SHConfigManager.m
//  CoreTest
//
//  Created by sheely.paean.Nightshade on 10/7/13.
//  Copyright (c) 2013 sheely.paean.coretest. All rights reserved.
//

#import "SHConfigManager.h"

static SHConfigManager * __instance;

@implementation SHConfigManager

@synthesize URL = _url;
@synthesize updateDate = _updateDate;
@synthesize newversion = _newversion;
@synthesize minversion = _minversion;
@synthesize content = _content;
@synthesize listupdateurls = _listupdateurls;
@synthesize result = _result;
@synthesize status = _status;
- (void)setURL:(NSString *)url_
{
    
    _url = url_;
    if(_url){
        [self refresh];
    }
}

- (void)refresh
{
    SHPostTaskM * task = [[SHPostTaskM alloc]init];
    task.cachetype = CacheTypeKey;
    task.URL= self.URL;
    task.delegate = self;
    [task start];
    //demo

    
}

- (void)dealUpdate:(NSDictionary*)dic
{
    _content = [dic valueForKey:@"content"];
    _newversion = [[SHVersion  alloc]initWithString: [dic valueForKey:@"newVersion"]];
    _minversion = [[SHVersion alloc]initWithString:[dic valueForKey:@"minVersion" ]];
    _updateDate = [dic valueForKey:@"updateDate"];
    _isMaintenanceMode = ((NSNumber*)[dic valueForKey:@"isMaintenanceMode"]).boolValue;
    _hasPushNotice = ((NSNumber*)[dic valueForKey:@"hasPushNotice"]).boolValue;
    _pushNotice = [dic valueForKey:@"pushNotice"];
}

- (void)taskDidFinished:(SHTask*) task
{
    _result = (NSDictionary*)task.result;
    [self dealUpdate :[self.result valueForKey:@"update"]];
    _status = SHConfigStatusSuccess;
     [[NSNotificationCenter defaultCenter]postNotificationName:CORE_NOTIFICATION_CONFIG_STATUS_CHANGED object:self];
}

- (void)taskDidFailed:(SHTask *)task
{
    _status = SHConfigStatusFaile;
    [[NSNotificationCenter defaultCenter]postNotificationName:CORE_NOTIFICATION_CONFIG_STATUS_CHANGED object:self];
}

+ (SHConfigManager*)instance
{
    if(__instance == nil){
        __instance = [[SHConfigManager alloc]init];
    }
    return __instance;
}

@end
