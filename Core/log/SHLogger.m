//
//  SHLogger.m
//  Core
//
//  Created by sheely.paean.Nightshade on 12/11/13.
//  Copyright (c) 2013 zywang. All rights reserved.
//



#import "SHLogger.h"


//void SHLogger(NSString *format, ...)
//{
//    va_list argp = NULL;
//    va_start(argp, format);
//    //NSString * msg = [[NSString alloc]initWithFormat:format,argp];
//    va_end(argp);
//}

@implementation SHLogger
+ (void) Log:(NSString*)log;
{
#ifdef DEBUG
    NSLog(@"%@",log);
#endif
    //SHLog(@"a", @"d");
  //  [NVDebugPanelController.instance addLog:log];
    [[NSNotificationCenter defaultCenter] postNotificationName:LOG_RECORD object:log ];
}
@end