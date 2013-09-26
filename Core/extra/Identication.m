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
    if(Entironment.instance.sessionid){
        [identication setObject:@"session" forKey:@"type"];
        [identication setObject:Entironment.instance.sessionid forKey:@"session_id"];
    }else{
        [identication setObject:@"basic" forKey:@"type"];
        [identication setObject:Entironment.instance.loginName forKey:@"username"];
        [identication setObject:Entironment.instance.password forKey:@"password"];
        [identication setObject:@"111111" forKey:@"imei"];
    }
    
    return identication;
}
@end
