//
//  SHPostTask.m
//  Core
//
//  Created by zywang on 13-8-17.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHPostTask.h"

@implementation SHPostTask
@synthesize postData;

-(void)start
{
    [self doRequest];
}

-(void)doRequest
{
    NSString *postLength = [NSString stringWithFormat:@"%d", [self.postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:_realURL]];
#ifdef DEBUG
      [request setTimeoutInterval:120];
#else
      [request setTimeoutInterval:30];
#endif
  
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"URL:%@",_realURL);
    if (conn)
    {
        NSLog(@"Connection success");
        //[conn start];
    }
}
@end

