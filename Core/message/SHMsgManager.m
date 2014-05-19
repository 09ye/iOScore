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
        //mSocket.delegate = self;
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
    [SHTools intToBytes:(int)[msg data].length byte:bytes start:8];
    [date appendBytes:&bytes length:TCP_PACKET_HEAD_LENGTH_POS];
    [date appendData:[msg data]];
    [mSocket writeData:date withTimeout:-1 tag:0];
    [mSocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [sock readDataWithTimeout:-1 tag:0];
}

- (void) processMsg :(int) type : n
{
    
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if(data && data.length > TCP_PACKET_HEAD_LENGTH_POS){
        NSMutableData *mdate = [[NSMutableData alloc]init];
        Byte p;
        Byte bytes[data.length];
        NSUInteger sum = data.length;
        [data getBytes:bytes length:data.length];
        int j = 0;
        int start = 0;
        for (int i = 0; i < sum; i++) {
            p = bytes[i];
            if(p  == 0xff){
                if(j== 4){
                    j = 0;
                    start = 0;
                    NSString *newMessage = [[NSString alloc] initWithData:mdate encoding:NSUTF8StringEncoding];
                    NSLog(@"%@",newMessage);
                }
                j++;
                if (j == 4) {//tou
                    [mdate setData:nil];
                    start = i;
                }
                continue;
            }
            if(j == 4 && i - start > 12){//起始标示
                
                [mdate appendBytes:&p length:1];
            }
        }
        NSString *newMessage = [[NSString alloc] initWithData:mdate encoding:NSUTF8StringEncoding];
        NSLog(@"%@",newMessage);
        
    }
    [sock readDataWithTimeout:-1 tag:0];
}

//- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
//    
//    [sock readDataWithTimeout:-1 tag:0];
//    
//}

- (void)socket:(GCDAsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    
    NSLog(@"Error");
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock

{
    //NSString *msg = @"Sorry this connect is failure";
}



/**
 * This method is called immediately prior to socket:didAcceptNewSocket:.
 * It optionally allows a listening socket to specify the socketQueue for a new accepted socket.
 * If this method is not implemented, or returns NULL, the new accepted socket will create its own default queue.
 *
 * Since you cannot autorelease a dispatch_queue,
 * this method uses the "new" prefix in its name to specify that the returned queue has been retained.
 *
 * Thus you could do something like this in the implementation:
 * return dispatch_queue_create("MyQueue", NULL);
 *
 * If you are placing multiple sockets on the same queue,
 * then care should be taken to increment the retain count each time this method is invoked.
 *
 * For example, your implementation might look something like this:
 * dispatch_retain(myExistingQueue);
 * return myExistingQueue;
 **/


/**
 * Called when a socket accepts a connection.
 * Another socket is automatically spawned to handle it.
 *
 * You must retain the newSocket if you wish to handle the connection.
 * Otherwise the newSocket instance will be released and the spawned connection will be closed.
 *
 * By default the new socket will have the same delegate and delegateQueue.
 * You may, of course, change this at any time.
 **/
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{}



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
 * Called if a read operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the read's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the read will timeout as usual.
 *
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been read so far for the read operation.
 *
 * Note that this method may be called multiple times for a single read if you return positive numbers.
 **/


/**
 * Called if a write operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the write's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the write will timeout as usual.
 *
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been written so far for the write operation.
 *
 * Note that this method may be called multiple times for a single write if you return positive numbers.
 **/


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
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{}

/**
 * Called after the socket has successfully completed SSL/TLS negotiation.
 * This method is not called unless you use the provided startTLS method.
 *
 * If a SSL/TLS negotiation fails (invalid certificate, etc) then the socket will immediately close,
 * and the socketDidDisconnect:withError: delegate method will be called with the specific SSL error code.
 **/
- (void)socketDidSecure:(GCDAsyncSocket *)sock{}
@end
