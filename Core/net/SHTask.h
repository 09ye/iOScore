//
//  Task.h
//  Core
//
//  Created by zywang on 13-8-17.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHObject.h"
@class SHTask;

@protocol SHTaskDelegate <NSObject>

- (void)taskDidFinished:(SHTask*) task;
- (void)taskDidFailed:(SHTask*) task;
- (void)taskWillTry:(SHTask*) task ;
@end

@interface SHTask : NSObject

@property (nonatomic,strong) SHObject* result;
@property (nonatomic,assign) id<SHTaskDelegate>delegate;

@end
