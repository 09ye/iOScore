//
//  SHTCPReel.m
//  Core
//
//  Created by sheely.paean.Nightshade on 11/23/14.
//  Copyright (c) 2014 zywang. All rights reserved.
//

#import "SHTCPReel.h"

@implementation SHTCPReel

@synthesize isWorking;

- (id)init
{
    if(self = [super init]){
        mSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

    }
    return self;
}
- (void) processMsg :(int) type  data :(NSData*)data
{
    if(type == 1){
        NSError * error ;
        int code = 0;
        NSString * message = @"";
        NSString * guid;
        NSString * target;
        NSDictionary * netreutrn =  [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)NSJSONWritingPrettyPrinted error:&error];
        if(netreutrn == nil){
            code = CORE_NET_ERROR;
            message = @"服务器没有返回信息";
        }else{
            if([[netreutrn allKeys] containsObject:@"code"]){
                code = [[netreutrn objectForKey:@"code"] intValue];
            }else{
                code = CORE_NET_FORMAT_ERROR;
            }
            guid = [netreutrn objectForKey:@"id"];
            //NSLog("%@",netreutrn);
            message = [netreutrn objectForKey:@"message"];
            target = [netreutrn objectForKey:@"response"];
            
        }
        Respinfo* res  = [[Respinfo alloc]initWithCode:(int)code message:message];
        SHResMsgM* msg = [[SHResMsgM alloc]init];
        msg.guid = guid;
        msg.respinfo = res;
        msg.result = [netreutrn valueForKey:@"data"];
        msg.response = target;
        if(self.delegate && [self.delegate respondsToSelector:@selector(processMsg:)]){
            [self.delegate processMsg:msg];
        }
    }
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [sock readDataWithTimeout:-1 tag:0];
    self.isWorking = YES;
}

- (void)connect
{
    NSError *err = [[NSError alloc]init];
    if(![mSocket connectToHost:self.ipAddress onPort:self.port error:&err]){
        
    }else{
        NSLog(@"ok");
    }
    
}

- (void)connect : (NSString*) address port:(int) port
{
    self.port = port;
    self.ipAddress = address;
    [self connect];
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    if(data && data.length > 16){
        NSMutableData *mdate = [[NSMutableData alloc]init];
        int version = 0;
        Byte p;
        //Byte bytes[data.length];
        NSRange  rang ;
        rang.length = 1;
        NSUInteger sum = data.length;
        int j = 0;
        int start = 0;
        for (int i = 0; i < sum; i++) {
            rang.location = i;
            [data getBytes:&p range:rang];
            if(p == 0xff){
                if(j== 4){
                    j = 0;
                    start = 0;
                    [self processMsg:version data:mdate];
                }
                j++;
                if (j == 4) {//tou
                    [mdate setData:nil];//清空
                    start = i;
                    Byte bversion [4];
                    NSRange rversion;
                    rversion.length = 4;
                    rversion.location = start+1;
                    [data getBytes:bversion range:rversion];
                    version = [SHTools bytesToInt:bversion offser:0];
                }
                continue;
            }
            
            else if(j == 4 && i - start > 12){//起始标示
                
                [mdate appendBytes:&p length:1];
            }
        }
        [self processMsg:version data:mdate];
    }
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)doRequest:(SHMsg*)msg
{
    NSMutableData * date = [[NSMutableData alloc]init];
    Byte bytes[TCP_PACKET_HEAD_LENGTH_POS];
    bytes[0] = 0xff;
    bytes[1] = 0xff;
    bytes[2] = 0xff;
    bytes[3] = 0xff;//flag
    
    bytes[4] = 0;
    bytes[5] = 0;
    bytes[6] = 0;
    bytes[7] = 0;//version
    
    bytes[8] = 0;
    bytes[9] = 0;
    bytes[10]= 0;
    bytes[11]= 0;//count
    
    bytes[12] = 0;
    bytes[13] = 0;
    bytes[14] = 0;
    bytes[15] = 0;//backup
    [SHTools intToBytes:1 byte:bytes start:4];//版本号
    [SHTools intToBytes:(int)[msg data].length byte:bytes start:8];
    [date appendBytes:&bytes length:TCP_PACKET_HEAD_LENGTH_POS];
    [date appendData:[msg data]];
    [mSocket writeData:date withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"Error");
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock
{
    self.isWorking = NO;
    //NSString *msg = @"Sorry this connect is failure";
}


/**
 * Called when a socket has read in data, but has not yet completed the read.
 * This would occur if using readToData: or readToLength: methods.
 * It may be used to for things such as updating progress bars.
 **/
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{}

/**
 * Called when a socket has written some data, but has not yet completed the entire write.
 * It may be used to for things such as updating progress bars.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag;{}


/**
 * Conditionally called if the read stream closes, but the write stream may still be writeable.
 *
 * This delegate method is only called if autoDisconnectOnClosedReadStream has been set to NO.
 * See the discussion on the autoDisconnectOnClosedReadStream method for more information.
 **/
- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock{}

/**
 * Called when a socket disconnects with or without error.
 *
 * If you call the disconnect method, and the socket wasn't already disconnected,
 * this delegate method will be called before the disconnect method returns.
 **/
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    self.isWorking = NO;
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reconnect:) userInfo:nil repeats:NO];
    
}

- (void)reconnect:(NSObject*)sender
{
    [self connect];
}
/**
 * Called after the socket has successfully completed SSL/TLS negotiation.
 * This method is not called unless you use the provided startTLS method.
 *
 * If a SSL/TLS negotiation fails (invalid certificate, etc) then the socket will immediately close,
 * and the socketDidDisconnect:withError: delegate method will be called with the specific SSL error code.
 **/
- (void)socketDidSecure:(GCDAsyncSocket *)sock{}
@end
