//
//  Task.h
//  Core
//
//  Created by zywang on 13-8-17.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHObject.h"
#import "Respinfo.h"



typedef enum 
{
    CacheTypeNone,
    CacheTypeKey,
    CacheTimes//时间缓存
    
}CacheType;

@class SHTask;

@protocol SHTaskDelegate <NSObject>

@required
- (void)taskDidFinished:(SHTask*) task;
@optional
- (void)taskDidFailed:(SHTask*) task;
- (void)taskWillTry:(SHTask*) task;

@end

@interface SHTask : NSObject
{
    @protected NSString * _realURL;
@protected Respinfo * _respinfo;
}

@property (nonatomic,strong,readonly) Respinfo * respinfo;
@property (nonatomic,strong) NSObject* result;
@property (nonatomic,assign) id<SHTaskDelegate>delegate;
@property (nonatomic,strong) NSString* URL;
@property (nonatomic,assign) CacheType cachetype;
@property (nonatomic,assign) BOOL  isCache;

- (void)start;
- (void)cancel;

+ (void)pull:(NSString*)url newUrl:(NSString*)newurl;
@end
