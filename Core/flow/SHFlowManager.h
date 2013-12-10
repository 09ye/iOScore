//
//  SHFlowManager.h
//  Core
//
//  Created by sheely on 13-12-10.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SHFLOW_PUSH_UPDATE  @"shflow_push_update"

typedef enum
{
    SHWayDown,
    SHWayUp,
} SHWay;

@interface SHFlowManager : NSObject
{
    long long mUp;
    long long mDown;
}

@property (nonatomic,assign,readonly) SHWay lastway;
@property (nonatomic,assign,readonly) long long  lastpackage;
@property (nonatomic,assign,readonly) long long  downFlow;
@property (nonatomic,assign,readonly) long long  upFlow;
+ (SHFlowManager*)instance;

-  (void)push:(long ) kb  way: (SHWay) way;



@end
