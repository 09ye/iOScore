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

@synthesize result;
@synthesize delegate = _delegate;
@synthesize URL = _URL;
@synthesize cachetype;
@synthesize isCache;

static const NSMutableDictionary * urlReplace;

- (void)setURL:(NSString *)URL
{
    _URL = URL;
    _realURL = URL;
    for (NSString * url in urlReplace.keyEnumerator) {
        
        NSRange substr=[_URL rangeOfString:url];
        
        if (substr.location!=NSNotFound) {
            _realURL = [_URL stringByReplacingCharactersInRange:substr withString:[urlReplace valueForKey:url]];
        }
    }
}

+ (void)pull:(NSString*)url newUrl:(NSString*)newurl
{
    if(urlReplace == Nil){
        urlReplace = [[NSMutableDictionary alloc] init];
    }
    [urlReplace setValue:newurl forKey:url];
}

- (void)start
{
    
}

- (void)cancel
{
    
}

@end
