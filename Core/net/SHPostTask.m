//
//  SHPostTask.m
//  Core
//
//  Created by zywang on 13-8-17.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHPostTask.h"

@implementation SHPostTask
@synthesize postData;

-(void)start
{
    [self doRequest];
}
- (void)start:(void(^)(SHTask *))taskfinished taskWillTry : (void(^)(SHTask *))tasktry  taskDidFailed : (void(^)(SHTask *))taskFailed
{
    [super start:taskfinished taskWillTry:tasktry taskDidFailed:taskFailed];
}
-(void)doRequest
{
    NSString *postLength = [NSString stringWithFormat:@"%d", [self.postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:_realURL]];
#ifdef DEBUG
      [request setTimeoutInterval:120];
#else
      [request setTimeoutInterval:30];
#endif
  
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    [SHFlowManager.instance push:postData.length way:SHWayUp];
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    SHLog(@"URL:%@",_realURL);
    if (conn){
        NSLog(@"Connection success");
        //[conn start];
    }
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    BOOL bo = [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    return bo;
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] ==0){
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    }else{
        [[challenge sender]cancelAuthenticationChallenge:challenge];
    }
}
@end

