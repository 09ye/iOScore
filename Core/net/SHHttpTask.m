//
//  SHHttpTask.m
//  Core
//
//  Created by sheely on 13-12-20.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHHttpTask.h"

@interface SHHttpTask ()
{
      NSMutableData *__data;
}
@end

@implementation SHHttpTask


- (void)start:(void(^)(SHTask *))taskfinished taskWillTry : (void(^)(SHTask *))tasktry  taskDidFailed : (void(^)(SHTask *))taskFailed
{
    [super start:taskfinished taskWillTry:tasktry taskDidFailed:taskFailed];
}

-(void)start
{
    
    if(self.cachetype == CacheTypeTimes){//时间类型缓存
        
        NSArray * array = [SHCacheManager.instance fetchOdTime: [NSString stringWithFormat:@"%@",_realURL]];
        if([array count]>1){
            NSString * cachetime = [array objectAtIndex:1];
            //cache
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date=[formatter dateFromString:cachetime];
            NSDate * currentdate = [NSDate date];
            NSTimeInterval times = [currentdate timeIntervalSinceDate:date];
            if(times < 60 * 60 * 24){
                self.isCache = YES;
                __data = [array objectAtIndex:0];
                [self processData];
                return;
            }
        }
    }
      [self doRequest];
}

-(void)doRequest
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:_realURL]];
#ifdef DEBUG
    [request setTimeoutInterval:120];
#else
    [request setTimeoutInterval:30];
#endif
    
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    SHLog(@"URL:%@",_realURL);
    if (conn){
        NSLog(@"Connection success");
        //[conn start];
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

- (void)processData
{
    if(!self.result){
        SEL resData = @selector(setResult:);
        if([self respondsToSelector:resData]){
            IMP p = [self methodForSelector:resData];
            //p (self,resData, __data);
            [self setResult:__data];
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
    _respinfo = [[Respinfo alloc]initWithCode:CORE_HTTP_ERROR message:error.description];
    if(self.delegate && [self.delegate respondsToSelector:@selector(taskDidFailed:)]){
        _isworking = NO;
        [self.delegate taskDidFailed:self];
    }else if (__taskdidtaskFailed){
        __taskdidtaskFailed(self);
    }
}

@end
