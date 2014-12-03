//
//  ntironment.m
//  Core
//
//  Created by sheely on 13-9-12.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHEntironment.h"
#import "SHPrivateAPI.h"

static SHEntironment * _instance;
@implementation SHEntironment
@synthesize deviceInfo = _deviceInfo;
@synthesize loginName;
@synthesize password;
@synthesize userId;
@synthesize deviceid;
@synthesize sessionid;
@synthesize version = _version;

- (SHVersion*)version
{
    if(_version == nil){
        NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
        NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
        if(versionNum.length == 0){
            versionNum = @"0.0.0";
        }
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
+ (SHEntironment* )instance
{
    if(_instance == nil){
        _instance = [[SHEntironment alloc]init];
    }
    return _instance;
}
- (NSString * )deviceid
{
    return [SHPrivateAPI guid];
}
@end
