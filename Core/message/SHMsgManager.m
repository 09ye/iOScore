//
//  SHMessageManager.m
//  Core
//
//  Created by WSheely on 14-5-15.
//  Copyright (c) 2014年 zywang. All rights reserved.
//

#import "SHMsgManager.h"

@implementation SHMsgManager

@synthesize reel = _reel;

static SHMsgManager *__instance = nil;

- (void)setReel:(SHNetReel *)reel
{
    _reel = reel;
    _reel.delegate = self;
}

+ (SHMsgManager*)instance
{
    if(__instance == nil){
        __instance = [[SHMsgManager alloc]init];
    }
    return __instance;
}



- (SHMsgManager*)init
{
    if(self = [super init]){
       
        mStorage = [[NSMutableDictionary alloc]init];
        mSenderThread = [[NSThread alloc]initWithTarget:self selector:@selector(senderThread:) object:nil];
        [mSenderThread start];
        mSenderList = [[NSMutableArray  alloc]init];
        msgHeart = [[SHMsgM alloc]init];
        msgHeart.target = @"heart";
        return self;
    }
    return nil;
}



- (void)senderThread:(NSObject*)object
{
    while (true) {
        if(mSenderList.count > 0){
            mHeartTime = 0;
            SHMsg * msg = [mSenderList objectAtIndex:0];
            [mSenderList removeObjectAtIndex:0];
            [_reel doRequest:msg];
            
            
            [NSThread sleepForTimeInterval:0.1];
        }else{
            [NSThread sleepForTimeInterval:1];
            mHeartTime++;
            if(mHeartTime == 10){
                [self addMsg:msgHeart taskDidFinished:nil taskWillTry:nil taskDidFailed:nil];
            }
        }
    }
}
//0xffffffff 0x0000 0x0000 0x0000{guid:name}
- (void) addMsg : (SHMsg*) msg taskDidFinished :(void(^)(SHResMsgM *))taskfinished taskWillTry : (void(^)(SHResMsgM *))tasktry  taskDidFailed : (void(^)(SHResMsgM *))taskFailed
{
    [mSenderList addObject:msg];
    if(msg.guid.length > 0){
        [mStorage setValue:taskfinished forKey:msg.guid];
    }
//    [mSocket readDataWithTimeout:-1 tag:0];
}



- (void) processMsg :(SHResMsgM*)msg
{
    if(msg.respinfo.code == 0){
        void(^ __taskdidfinished)(SHResMsgM *) = [mStorage valueForKey:msg.guid] ;
        if (__taskdidfinished) {
            __taskdidfinished(msg);
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:msg.response object:msg];
        }
        
    }else{
        void(^ __taskDidFailed)(SHResMsgM *) = [mStorage valueForKey:msg.guid] ;
        if (__taskDidFailed) {
            __taskDidFailed(msg);
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:msg.response object:msg];
        }
        
    }
}



@end
