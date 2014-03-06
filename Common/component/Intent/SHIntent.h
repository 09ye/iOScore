//
//  SHIntent.h
//  siemens.bussiness.partner.CRM.tool
//
//  Created by WSheely on 14-3-5.
//  Copyright (c) 2014年 MobilityChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHIntent:NSObject

@property (nonatomic) NSDictionary * args;

@property (nonatomic) NSString * target;

@property (nonatomic, assign) id delegate;

@property (nonatomic, strong) UIViewController * container;

- (id)init:(NSString*)target_ delegate:(id)delegate_ containner:(id)container_;

- (id)init:(NSString*)target_;
@end
