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

+ (Entironment* )instance
{
    if(_instance == nil){
        _instance = [[Entironment alloc]init];
    }
    return _instance;
}
@end
