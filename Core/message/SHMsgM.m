//
//  SHMsgM.m
//  Core
//
//  Created by WSheely on 14-5-15.
//  Copyright (c) 2014年 zywang. All rights reserved.
//

#import "SHMsgM.h"

@implementation SHMsgM

@synthesize args = _args;
@synthesize guid = _guid;
@synthesize target;

- (NSMutableDictionary * )args
{
    if(_args == nil){
        _args = [[NSMutableDictionary alloc]init];
    }
    return _args;
}

- (id) init
{
    if(self = [super init]){
        CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
        _guid = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    }
    return self;
}

- (void)start:(void(^)(SHResMsgM *))taskfinished taskWillTry : (void(^)(SHResMsgM *))tasktry  taskDidFailed : (void(^)(SHResMsgM *))taskFailed
{
    [SHMsgManager.instance addMsg:self taskDidFinished:taskfinished taskWillTry:tasktry taskDidFailed:taskFailed];
}

- (NSData*) data
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue: self.guid  forKey: @"id" ];
    [dic setValue: self.args  forKey: @"args"];
    [dic setValue: self.target forKey:@"target"];
    
    return  [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
}

@end
