//
//  ntironment.h
//  Core
//
//  Created by sheely on 13-9-12.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHVersion.h"

@interface Entironment : NSObject
{
}
@property (nonatomic,strong) NSString* loginName;
@property (nonatomic,strong) NSString* password;
@property (nonatomic,strong) NSString* userId;
@property (nonatomic,strong) NSString* deviceid;
@property (nonatomic,strong) NSString* sessionid;
@property (nonatomic,readonly) SHVersion * version;
+ (Entironment* )instance;
@end
