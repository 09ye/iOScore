//
//  SHPostTask.m
//  Core
//
//  Created by zywang on 13-8-17.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHPostTask.h"

@implementation SHPostTask
{
    NSMutableData *__data;
}
@synthesize postData;

@synthesize postHeader = _postHeader;

-(NSMutableDictionary*)postHeader
{
    if(_postHeader == nil){
        _postHeader = [[NSMutableDictionary alloc]init];
    }
    return _postHeader;
}
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
    if (self.postHeader) {
        NSArray * keys  =[self.postHeader allKeys];
        for (int i= 0;i<self.postHeader.count;i++) {
            NSString * key  = [keys objectAtIndex:i];
            [request setValue:[self.postHeader objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(__data == nil){
        __data = [[NSMutableData alloc]init];
    }
    [SHFlowManager.instance  push:data.length way:SHWayDown];
    [__data appendData:data];
    
}

typedef id (*IMP2) (id,SEL,...);

- (void)processData
{
    if(!self.result){
        NSError * error ;
        NSDictionary * netreutrn = nil;
        if(__data != nil){
            
            netreutrn  = [NSJSONSerialization JSONObjectWithData:__data options:(NSJSONReadingOptions)NSJSONWritingPrettyPrinted error:&error];
        }
        
        SEL resData = @selector(setResult:);
        if([self respondsToSelector:resData]){
            IMP2 p = [self methodForSelector:resData];
            //p (self,resData, netreutrn);
//            
//            [self setre]
            [self setResult:netreutrn];
        }
    }
    if(self.respinfo.code == 0){
        
        if(self.isCache == NO){//不是缓存模式时添加缓存
            
            if(__data){
                [SHCacheManager.instance push:__data forKey:[NSString stringWithFormat:@"%@",_realURL]];
            }
            
        }
        //_result  = [netreutrn objectForKey:@"data"];
        //NSLog(@"data:%@",[self.result description]);
        if(self.delegate && [self.delegate respondsToSelector:@selector(taskDidFinished:)]){
            _isworking = NO;
            [self.delegate taskDidFinished:self];
        }else if (__taskdidfinished){
            __taskdidfinished(self);
        }
    }else{
        if(self.delegate && [self.delegate respondsToSelector:@selector(taskDidFailed:)]){
            _isworking = NO;
            [self.delegate taskDidFailed:self];
        }else if (__taskdidtaskFailed){
            __taskdidtaskFailed(self);
        }
    }
    //SHLog(@"%@",[self.result description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(self.cachetype == CacheTypeTimes){
        if(self.respinfo.code == 0){
            // if(self.result){
            [self processData];
            //     }
            //     else{
            //                NSData * cache = [SHCacheManager.instance fetch:[NSString stringWithFormat:@"%@",_realURL]];
            //                __data = [cache mutableCopy];
            //                [self processData];
        }
        //   }
    }else{
        [self processData];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    if(self.cachetype == CacheTypeKey){
        NSData * cachedata;
        //if([NSJSONSerialization isValidJSONObject:self.postArgs] == YES){
        cachedata = [SHCacheManager.instance fetch: [NSString stringWithFormat:@"%@",_realURL]];
        //}
        if(cachedata){//缓存存在
            self.isCache = YES;
            __data = [cachedata mutableCopy];
            [self processData];
            return;
        }
    }
    _respinfo = [[Respinfo alloc]initWithCode:CORE_HTTP_ERROR message:CORE_HTTP_ERROR_MESSAGE];
    if(self.delegate && [self.delegate respondsToSelector:@selector(taskDidFailed:)]){
        _isworking = NO;
        [self.delegate taskDidFailed:self];
    }else if (__taskdidtaskFailed){
        __taskdidtaskFailed(self);
    }
}


@end

