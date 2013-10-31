//
//  ntironment.m
//  Core
//
//  Created by sheely on 13-9-12.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "Entironment.h"

static Entironment * _instance;
@implementation Entironment
@synthesize deviceInfo = _deviceInfo;
@synthesize loginName;
@synthesize password;
@synthesize userId;
@synthesize deviceid = _deviceid;
@synthesize sessionid;
@synthesize version = _version;

- (SHVersion*)version
{
    if(_version == nil){
        NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
        NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
        _version = [[SHVersion alloc]initWithString:versionNum];
    }
    return _version;
}

- (NSString*) deviceInfo
{
    if(_deviceInfo == nil){
        NSString *systemVersion   =   [[UIDevice currentDevice] systemVersion];//系统版本
        NSString *systemModel    =   [[UIDevice currentDevice] model];//是iphone 还是 ipad
        _deviceInfo = [NSString stringWithFormat:@"systemVersion:%@;systemModel:%@",systemVersion,systemModel];
    }
    return _deviceInfo == nil ? @"" : _deviceInfo;
}
+ (Entironment* )instance
{
    if(_instance == nil){
        _instance = [[Entironment alloc]init];
    }
    return _instance;
}
- (NSString * )deviceid
{
    if(!_deviceid){
        return @"";
    }
    return _deviceid;
}
@end
