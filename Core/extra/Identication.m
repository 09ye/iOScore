//
//  Identication.m
//  Core
//
//  Created by sheely on 13-9-24.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "Identication.h"
#import "Entironment.h"

@implementation Identication

+(NSDictionary * )identication
{
    NSMutableDictionary * identication = [[NSMutableDictionary alloc]init];
    if(Entironment.instance.sessionid.length > 0){
        [identication setObject:@"session" forKey:@"type"];
        if(Entironment.instance.sessionid){
            [identication setObject:Entironment.instance.sessionid forKey:@"session_id"];
        }
    }else{
        [identication setObject:@"basic" forKey:@"type"];
        if(Entironment.instance.loginName && Entironment.instance.password){
            [identication setObject:Entironment.instance.loginName forKey:@"username"];
            [identication setObject:Entironment.instance.password forKey:@"password"];
        }
#if DEBUG
        if(Entironment.instance.deviceid.length == 0){
            [identication setObject:@"111111" forKey:@"imei"];
        }else{
            [identication setObject:Entironment.instance.deviceid forKey:@"imei"];
        }
       
#else
        [identication setObject:Entironment.instance.deviceid forKey:@"imei"];
#endif
    }
//    if ( Entironment.instance.userId) {
//        [identication setObject:Entironment.instance.userId forKey:@"shop"];
//    }
    [identication setObject:Entironment.instance.deviceInfo forKey:@"info"];
    [identication setObject:Entironment.instance.version.description forKey:@"version"];
    return identication;
}
@end
