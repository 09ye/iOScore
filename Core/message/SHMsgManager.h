//
//  SHMessageManager.h
//  Core
//
//  Created by WSheely on 14-5-15.
//  Copyright (c) 2014年 zywang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMsgManager : NSObject
{
    GCDAsyncSocket * mSocket;
}

+ (SHMsgManager*)instance;

- (void) addMsg : (SHMsg*) msg;

@end
