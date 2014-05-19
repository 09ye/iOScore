//
//  SHMsgM.m
//  Core
//
//  Created by WSheely on 14-5-15.
//  Copyright (c) 2014年 zywang. All rights reserved.
//

#import "SHMsgM.h"

@implementation SHMsgM

@synthesize args;

- (void)start
{
    [SHMsgManager.instance addMsg:self];
}

- (NSData*) data
{
    return  [@"a1" dataUsingEncoding:4];
}

@end
