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
    NSDictionary * netreutrn = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)NSJSONWritingPrettyPrinted error:nil];
    int code = [[netreutrn objectForKey:@"code"] integerValue];
    NSString * message = [netreutrn objectForKey:@"message"];
    _respinfo = [[Respinfo alloc]initWithCode:(int)code message:message];

    if(code == 0){
        self.result  = [netreutrn objectForKey:@"data"];
        if(self.delegate && [self.delegate respondsToSelector:@selector(taskDidFinished:)]){
            [self.delegate taskDidFinished:self];
        }
    }else{
        if(self.delegate && [self.delegate respondsToSelector:@selector(taskDidFailed:)]){
            [self.delegate taskDidFailed:self];
        }
    }
    SHCacheManager * manager = SHCacheManager.instance;
    [manager push:[@"NSString" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"http://aaa"];
    NSArray * array = [manager querryTable:@"select * from cache"];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(taskDidFailed:)]){
        [self.delegate taskDidFailed:self];
    }
}
@end
