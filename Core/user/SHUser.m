//
//  User.m
//  Core
//
//  Created by sheely on 13-10-29.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHUser.h"

@implementation SHUser

@synthesize userId;

static SHUser* __instance;

+ (SHUser *)instance
{
    if(__instance == nil){
        __instance = [[SHUser alloc]init];
    }
    return __instance;
}
@end
