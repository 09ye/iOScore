//
//  Task.m
//  Core
//
//  Created by zywang on 13-8-17.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHTask.h"

@interface SHTask()
{
  
};
@end


@implementation SHTask

@synthesize result = _result;
@synthesize delegate = _delegate;
@synthesize URL = _URL;
@synthesize cachetype;
@synthesize isCache;
@synthesize respinfo = _respinfo;
@synthesize extra = _extra;
@synthesize tag = _tag;
@synthesize isworking = _isworking;

static const NSMutableDictionary * urlReplace;


- (void)setURL:(NSString *)URL
{
    _URL = URL;
    _realURL = URL;
    for (NSString * url in urlReplace.keyEnumerator) {
        NSRange substr=[_URL rangeOfString:url];
        if (substr.location != NSNotFound) {
            _realURL = [_URL stringByReplacingCharactersInRange:substr withString:[urlReplace valueForKey:url]];
        }
    }
}

+ (void)pull:(NSString*)url newUrl:(NSString*)newurl
{
    if(urlReplace == Nil){
        urlReplace = [[NSMutableDictionary alloc] init];
    }
    if([newurl isEqualToString:url] ){
        [urlReplace removeObjectForKey:url];
    }else{
        [urlReplace setValue:newurl forKey:url];

    }
}

- (void)setRespinfo:(Respinfo *)respinfo
{
    _respinfo = respinfo;
}

- (void)setExtra:(NSDictionary *)extra
{
    _extra = extra;
}

- (void)setResult:(NSObject *)result
{
    _result = result;
}

- (void)start
{
    _isworking = YES;
}

- (void)start:(void(^)(SHTask *))taskfinished taskWillTry : (void(^)(SHTask *))tasktry  taskDidFailed : (void(^)(SHTask *))taskFailed
{
    __taskdidfinished = taskfinished;
    __taskdidtaskFailed = taskFailed;
    [self start];
}
- (void)cancel
{
    _isworking = NO;
}

-(NSString*)description
{
    return [self.result description];
}
@end
