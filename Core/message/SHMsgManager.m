//
//  SHMessageManager.m
//  Core
//
//  Created by WSheely on 14-5-15.
//  Copyright (c) 2014年 zywang. All rights reserved.
//

#import "SHMsgManager.h"

@implementation SHMsgManager
static SHMsgManager *__instance = nil;


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
        mSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        //socket.delegate = self;
        NSError *err = [[NSError alloc]init];
        if(![mSocket connectToHost:@"192.168.1.144" onPort:54321 error:&err])
        {
        }else{
            NSLog(@"ok");
        }

        return self;
    }
    return nil;
}


- (void)addMsg:(SHMsg *)msg
{
   
  //  [mSocket writeData:[[msg json] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [sock readDataWithTimeout:-1 tag:0];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //[socket readDataWithTimeout:-1 tag:0];
}


@end
