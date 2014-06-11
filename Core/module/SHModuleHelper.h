//
//  SHModuleHelper.h
//  crowdfunding-arcturus
//
//  Created by sheely.paean.Nightshade on 14-4-23.
//  Copyright (c) 2014年 WSheely. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHModuleHelper : NSObject

- (NSString * )targetByModule:(NSString*) modulename;

- (NSString * )targeByPreAction:(NSString*) action;

+ (SHModuleHelper*) instance;
@end
