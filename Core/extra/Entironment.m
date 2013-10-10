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
        _version = [[SHVersion alloc]initWithString:versionNum];
    }
    return _version;
}

+ (Entironment* )instance
{
    if(_instance == nil){
        _instance = [[Entironment alloc]init];
    }
    return _instance;
}
@end
