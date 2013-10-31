//
//  SHPostTaskM.m
//  Core
//
//  Created by sheely on 13-9-12.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHPostTaskM.h"
#import "Entironment.h"
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

- (void)start
{
    NSMutableDictionary * data = [[NSMutableDictionary alloc]init];
    NSMutableDictionary * pargs = [self.postArgs mutableCopy];
    if(self.postArgs.count > 0){
        [data setObject:pargs forKey:@"data"];
    }else{
        [data setObject:[[NSDictionary alloc]init] forKey:@"data"];
    }
    NSDictionary * identication = Identication.identication;
    [data setObject:identication forKey:@"identication"];
    if(self.cachetype == CacheTimes){//时间类型缓存
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
                    [self processData];
                    return;
                }
            }
        }
    }
    NSLog(@"%@",[data description]);
    if([NSJSONSerialization isValidJSONObject:data] == YES){
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
            [self.delegate taskDidFinished:self];
        }
    }else{
        if(self.delegate && [self.delegate respondsToSelector:@selector(taskDidFailed:)]){
            [self.delegate taskDidFailed:self];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [SHAnalyzeFactory analyze:self Data:__data];
    if(self.cachetype == CacheTimes){
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
    _respinfo = [[Respinfo alloc]initWithCode:-1 message:@"网络连接失败."];
    if(self.delegate && [self.delegate respondsToSelector:@selector(taskDidFailed:)]){
        [self.delegate taskDidFailed:self];
    }
}


@end
