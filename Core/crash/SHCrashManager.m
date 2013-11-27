//
//  SHCrashManager.m
//  Core
//
//  Created by sheely on 13-9-25.
//  Copyright (c) 2013年 zywang. All rights reserved.
//
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "SHCrashManager.h"
#import "FileManager.h"

static const NSString * UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
static const NSString * SingalExceptionHandlerAddressesKey = @"SingalExceptionHandlerAddressesKey";
static const NSString * ExceptionHandlerAddressesKey = @"ExceptionHandlerAddressesKey";

@implementation SHCrashManager

static SHCrashManager * mInstance;
void signalHandler(int signal);
// 异常截获处理方法
void exceptionHandler(NSException *exception);
const int32_t _uncaughtExceptionMaximum = 10;
static int  count = 0;
+ (SHCrashManager*) instance
{
    if(mInstance == nil){
        mInstance = [[SHCrashManager alloc]init];
        NSSetUncaughtExceptionHandler(&exceptionHandler);
        signal(SIGHUP, signalHandler);
        signal(SIGINT, signalHandler);
        signal(SIGQUIT, signalHandler);
        
        signal(SIGABRT, signalHandler);
        signal(SIGILL, signalHandler);
        signal(SIGSEGV, signalHandler);
        signal(SIGFPE, signalHandler);
        signal(SIGBUS, signalHandler);
        signal(SIGPIPE, signalHandler);
    }
    return mInstance;
}

//- (void) postToService : (SHTask * )task
//{
//    NSString * data = [FileManager readFile:@"crash.txt"];
//    task.
//}

- (void)setURL:(NSString *)URL_
{
    SHPostTaskM* task = [[SHPostTaskM alloc]init];
    task.URL = URL_;
    NSString* data = [FileManager readFile:@"crash.txt"];
    if(data.length > 0){
        [task.postArgs setValue:@"" forKey:@"crash"];
        task.delegate = self;
        [task start];
    }
}

- (void)taskDidFinish:(SHTask* )task
{
    [FileManager deleteFile:@"crash.txt"];
}

- (void)taskDidFailed:(SHTask *)task
{
    //[FileManager deleteFile:@"crash.txt"];
}

void signalHandler(int signal)
{
    if(count >0){
        return;
    }
    count++;
    volatile int32_t _uncaughtExceptionCount = 0;
    int32_t exceptionCount = OSAtomicIncrement32(&_uncaughtExceptionCount);
    if (exceptionCount > _uncaughtExceptionMaximum) // 如果太多不用处理
    {
        return;
    }
    
    // 获取信息
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    
    NSArray *callStack = [SHCrashManager backtrace];
    [userInfo  setObject:callStack  forKey:SingalExceptionHandlerAddressesKey];
    [FileManager writeFile:@"crash.txt" data:[[[SHCrashManager backtraceStr] stringByAppendingFormat:@"%d",signal] dataUsingEncoding:NSUTF8StringEncoding]];
    // 现在就可以保存信息到本地［］
}

void exceptionHandler(NSException *exception)
{
    volatile int32_t _uncaughtExceptionCount = 0;
    int32_t exceptionCount = OSAtomicIncrement32(&_uncaughtExceptionCount);
    if (exceptionCount > _uncaughtExceptionMaximum) // 如果太多不用处理
    {
        return;
    }
    
    NSArray *callStack = [SHCrashManager backtrace];
    NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:ExceptionHandlerAddressesKey];
    [FileManager writeFile:@"crash.txt" data:[[NSString stringWithFormat:@"\n%@--------\n%@\n%@\n",[[NSDate date] description],[exception reason],[[exception callStackSymbols] description]]dataUsingEncoding:NSUTF8StringEncoding]];

    // 现在就可以保存信息到本地［］
}

+ (NSString*)backtraceStr
{
    NSMutableString * crash = [[NSMutableString alloc]init];
    NSArray * array = [SHCrashManager backtrace];
    for (NSString * str in array) {
        [crash appendFormat:@"%@\n",str];
    }
    return crash;
}
//获取调用堆栈
+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack,frames);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i=0;i<frames;i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    [backtrace insertObject:[NSString stringWithFormat: @"---------------------------------"] atIndex:0];
    return backtrace;
}

@end
