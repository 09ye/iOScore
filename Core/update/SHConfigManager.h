//
//  SHConfigManager.h
//  CoreTest
//
//  Created by sheely.paean.Nightshade on 10/7/13.
//  Copyright (c) 2013 sheely.paean.coretest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHConfigManager : NSObject

@property (nonatomic,copy) NSString * URL;
@property (nonatomic,copy) NSString * update;
@property (nonatomic,strong) SHVersion * newVersion;
@property (nonatomic,strong) SHVersion * minVersion;
@property (nonatomic,copy)   NSString * content;
@property (nonatomic,strong) NSArray* listupdateurls
@property (nonatomic,strong) NSDictionary * result;

- (void) refresh;

+ (SHConfigManager*)instance;
@end
