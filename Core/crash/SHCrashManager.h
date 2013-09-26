//
//  SHCrashManager.h
//  Core
//
//  Created by sheely on 13-9-25.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHCrashManager : NSObject

+ (SHCrashManager*)instance;
+(void)writeFile:(NSString *)file;
@end
