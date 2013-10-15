//
//  SHAnalyzeFactory.h
//  Core
//
//  Created by sheely on 13-10-15.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHTask.h"

@interface SHAnalyzeFactory : NSObject

+ (void) analyze:(SHTask *) task Data:(NSData*)data;

@end
