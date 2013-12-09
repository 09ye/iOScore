//
//  PrivateAPI.h
//  Core
//
//  Created by sheely on 13-12-9.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import <Foundation/Foundation.h>
struct CTResult

{
    int flag;
    int a;
};
@interface SHPrivateAPI : NSObject
//imei

+ (NSString *) imei;

@end
