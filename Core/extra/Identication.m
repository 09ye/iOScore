//
//  Identication.m
//  Core
//
//  Created by sheely on 13-9-24.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "Identication.h"
#import "SHEntironment.h"

@implementation Identication

+(NSDictionary * )identication
{
    NSMutableDictionary * identication = [[NSMutableDictionary alloc]init];
    if(SHEntironment.instance.sessionid.length > 0){
        [identication setObject:@"session" forKey:@"type"];
        if(SHEntironment.instance.sessionid){
            [identication setObject:SHEntironment.instance.sessionid forKey:@"session_id"];
        }
    }else{
        [identication setObject:@"basic" forKey:@"type"];
        if(SHEntironment.instance.loginName && SHEntironment.instance.password){
            [identication setObject:SHEntironment.instance.loginName forKey:@"username"];
            [identication setObject:SHEntironment.instance.password forKey:@"password"];
        }
#if DEBUG
        if(SHEntironment.instance.deviceid.length == 0){
            [identication setObject:@"111111" forKey:@"imei"];
        }else{
            [identication setObject:SHEntironment.instance.deviceid forKey:@"imei"];
        }
       
#else
        [identication setObject:SHEntironment.instance.deviceid forKey:@"imei"];
#endif
    }
//    if ( SHEntironment.instance.userId) {
//        [identication setObject:SHEntironment.instance.userId forKey:@"shop"];
//    }
    [identication setObject:SHEntironment.instance.deviceInfo forKey:@"info"];
    [identication setObject:SHEntironment.instance.version.description forKey:@"version"];
    return identication;
}
@end
