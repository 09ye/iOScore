//
//  SHIntent.m
//  siemens.bussiness.partner.CRM.tool
//
//  Created by WSheely on 14-3-5.
//  Copyright (c) 2014年 MobilityChina. All rights reserved.
//

#import "SHIntent.h"

@implementation SHIntent

- (id)init{
    if (self = [super init]){
        self.args = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (id)init:(NSString*)target_
{
    if (self = [super init]){
        self.target = target_;
        self.args = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (id)init:(NSString*)target_ delegate:(id)delegate_ containner:(id)container_
{
    if (self = [super init]){
        self.target = target_;
        self.delegate = delegate_;
        self.container = container_;
        self.args = [[NSMutableDictionary alloc]init];
    }
    return self;
}

//参数
@synthesize args;
//委托
@synthesize delegate;
//目标
@synthesize target;

@synthesize container;

@end
