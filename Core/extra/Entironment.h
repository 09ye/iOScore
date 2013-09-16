//
//  ntironment.h
//  Core
//
//  Created by sheely on 13-9-12.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entironment : NSObject
{
}
@property (nonatomic,strong) NSString* loginName;
@property (nonatomic,strong) NSString* password;

+ (Entironment* )instance;
@end
