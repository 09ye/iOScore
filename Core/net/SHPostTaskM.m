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

@implementation SHPostTaskM

@synthesize postArgs;
@synthesize respinfo = _respinfo;

- (void)start
{
    NSMutableDictionary * data = [[NSMutableDictionary alloc]init];

    if(self.postArgs.count > 0){
        [data setObject:self.postArgs forKey:@"data"];
    }
    NSMutableDictionary * identication = [[NSMutableDictionary alloc]init];
    [identication setObject:@"basic" forKey:@"type"];
    [identication setObject:Entironment.instance.loginName forKey:@"name"];
    [identication setObject:Entironment.instance.password forKey:@"password"];
    [data setObject:identication forKey:@"identication"];
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
    [self processData:data];
}

- (void)processData:(NSData *)data
{
    NSDictionary * netreutrn = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)NSJSONWritingPrettyPrinted error:nil];
    int code = [[netreutrn objectForKey:@"code"] integerValue];
    NSString * message = [netreutrn objectForKey:@"message"];
    _respinfo = [[Respinfo alloc]initWithCode:(int)code message:message];
    if(code == 0){
        if(self.isCache == NO){//不是缓存模式时添加缓存
            if(self.cachetype == CacheTypeKey ){//缓存
                 NSString * args = [[NSString alloc]initWithData:self.postData encoding:(NSStringEncoding)NSUTF8StringEncoding];
                [SHCacheManager.instance push:data forKey:[NSString stringWithFormat:@"%@/%@",_realURL,args]];
            }
        }
        self.result  = [netreutrn objectForKey:@"data"];
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
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(self.cachetype == CacheTypeKey){
        NSString * args = [[NSString alloc]initWithData:self.postData encoding:(NSStringEncoding)NSUTF8StringEncoding];
        NSData * data = [SHCacheManager.instance fetch: [NSString stringWithFormat:@"%@/%@",_realURL,args]];
        if(data){//缓存存在
            self.isCache = YES;
            [self processData:data];
            return;
        }
    }
    _respinfo = [[Respinfo alloc]initWithCode:-1 message:@"网络连接失败."];
    if(self.delegate && [self.delegate respondsToSelector:@selector(taskDidFailed:)]){
        [self.delegate taskDidFailed:self];
    }
}
@end
