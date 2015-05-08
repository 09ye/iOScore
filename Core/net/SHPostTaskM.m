//
//  SHPostTaskM.m
//  Core
//
//  Created by sheely on 13-9-12.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHPostTaskM.h"
#import "SHEntironment.h"
#import "SHCacheManager.h"
#import "Identication.h"
#import "SHAnalyzeFactory.h"

@interface SHPostTaskM ()
{
    NSMutableData *__data;
}
@end

@implementation SHPostTaskM

@synthesize postArgs = _postArgs;

-(NSMutableDictionary*)postArgs
{
    if(_postArgs == nil){
        _postArgs = [[NSMutableDictionary alloc]init];
    }
    return _postArgs;
}

- (void)start:(void(^)(SHTask *))taskfinished taskWillTry : (void(^)(SHTask *))tasktry  taskDidFailed : (void(^)(SHTask *))taskFailed
{
    [super start:taskfinished taskWillTry:tasktry taskDidFailed:taskFailed];
}

- (void)start
{
    NSDictionary * identication = Identication.identication;
    NSMutableDictionary * data = [[NSMutableDictionary alloc]init];
    NSMutableDictionary * pargs = [self.postArgs mutableCopy];
    if(!pargs || self.postArgs.count == 0){
        pargs = [[NSMutableDictionary alloc]init];
    }
    [pargs setObject:identication forKey:@"identication"];
    [data setObject:pargs forKey:@"data"];
    
//    [data setObject:identication forKey:@"identication"];
    if(self.cachetype == CacheTypeTimes){//时间类型缓存
        if([NSJSONSerialization isValidJSONObject:self.postArgs] == YES){
            NSArray * array = [SHCacheManager.instance fetchOdTime: [NSString stringWithFormat:@"%@/%@",_realURL,[self.postArgs description]]];
            if([array count]>1){
                NSString * cachetime = [array objectAtIndex:1];
                [pargs setValue:cachetime forKey:@"cachetime"];//缓存时间
                //cache
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *date=[formatter dateFromString:cachetime];
                NSDate * currentdate = [NSDate date];
                NSTimeInterval times = [currentdate timeIntervalSinceDate:date];
                if(times < 60 * 60 * 24){
                    self.isCache = YES;
                    __data = [array objectAtIndex:0];
                    [self performSelector:@selector(processData) withObject:nil afterDelay:0.1];
                    return;
                }
            }
        }
    }
    SHLog(@"%@",[data description]);
    if(!self.postData && [NSJSONSerialization isValidJSONObject:data] == YES){
        self.postData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    }
    [super start];
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
        [SHAnalyzeFactory analyze:self Data:__data];
    }
    if(self.respinfo.code == 0){
        if(self.isCache == NO){//不是缓存模式时添加缓存
                if([NSJSONSerialization isValidJSONObject:self.postArgs] == YES){
                    [SHCacheManager.instance push:__data forKey:[NSString stringWithFormat:@"%@/%@",_realURL,[self.postArgs description]]];
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
        }else if (__taskdidtaskFailed) {
            __taskdidtaskFailed(self);
        }
    }
    SHLog(@"%@",[self.result description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [SHAnalyzeFactory analyze:self Data:__data];
    if(self.cachetype == CacheTypeTimes){
        //NSDictionary * netreutrn = [NSJSONSerialization JSONObjectWithData:__data options:(NSJSONReadingOptions)NSJSONWritingPrettyPrinted error:nil];
        //int code = [[netreutrn objectForKey:@"code"] integerValue];
        //NSDictionary * dicdata = [netreutrn objectForKey:@"data"];
        if(self.respinfo.code == 0){
            if(self.result){
                [self processData];
            }
            else{
                NSData * cache = [SHCacheManager.instance fetch:[NSString stringWithFormat:@"%@/%@",_realURL,[self.postArgs description]]];
                __data = [cache mutableCopy];
                [self processData];
            }
        }
    }else{
        [self processData];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    if(self.cachetype == CacheTypeKey){
        NSData * cachedata;
        if([NSJSONSerialization isValidJSONObject:self.postArgs] == YES){
            cachedata = [SHCacheManager.instance fetch: [NSString stringWithFormat:@"%@/%@",_realURL,[self.postArgs description]]];
        }
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
    }else{
        __taskdidtaskFailed(self);
    }
}


@end
