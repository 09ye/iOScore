//
//  SHFlowManager.m
//  Core
//
//  Created by sheely on 13-12-10.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHFlowManager.h"

@interface SHFlowManager (private)
{

}

@end

@implementation SHFlowManager
@synthesize lastway = _lastway;
@synthesize lastpackage = _lastpackage;
@synthesize upFlow = mUp;
@synthesize downFlow = mDown;

static SHFlowManager * __instance;

+ (SHFlowManager*)instance
{
    if(__instance == nil){
        __instance = [[SHFlowManager alloc]init];
        
    }
    return __instance;
}

-  (void)push:(long ) byte  way: (SHWay) way
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
    [[NSNotificationCenter defaultCenter] postNotificationName:SHFLOW_PUSH_UPDATE object:nil];
}


@end
