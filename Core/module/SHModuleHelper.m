//
//  SHModuleHelper.m
//  crowdfunding-arcturus
//
//  Created by sheely.paean.Nightshade on 14-4-23.
//  Copyright (c) 2014年 WSheely. All rights reserved.
//

#import "SHModuleHelper.h"
#import "GDataXMLNode.h"

@implementation SHModule



@end

@interface SHModuleHelper()
{
    NSMutableDictionary * mDic;
    NSMutableArray * mList;
}
@end


static SHModuleHelper * __instance;

@implementation SHModuleHelper

- (SHModuleHelper*) init
{
    if(self = [super init]){
        [self initmodule];
    }
    
    return self;
}

- (void) initmodule{
    
    GDataXMLDocument* doc = [self docForStyle:@"module"];
    NSArray * array = ((GDataXMLNode*)[[doc nodesForXPath:[NSString stringWithFormat:@"//root"] error:nil] objectAtIndex:0]).children;
    
    mList = [[NSMutableArray alloc ]init];
    mDic = [[NSMutableDictionary alloc ]init];
    for (GDataXMLElement* ele in array) {
        NSString * name = [ele attributeForName:@"name"].stringValue;
        //SHModule
        SHModule* module = [[SHModule alloc ] init];
        module->name = [ele attributeForName:@"name"].stringValue;
        module->need_pre_action = [ele attributeForName:@"need_pre_action"].stringValue;
        module->pre_action = [ele attributeForName:@"pre_action"].stringValue;
        module->target = [ele attributeForName:@"target"].stringValue;
        module->type = [ele attributeForName:@"type"].stringValue;
        module->icon = [ele attributeForName:@"icon"].stringValue;
        module->title = [ele attributeForName:@"title"].stringValue;
        [mDic setObject:module forKey:name];
        [mList addObject:module];
    }
    //[doc release];
}

- (NSArray * )modulelist
{
    return mList;
}
- (NSString * )targetByModule:(NSString*) modulename
{
    SHModule* module = [mDic valueForKey:modulename];
    if(module  != nil){
        return module->target;
    }else{
        return nil;
    }
}

- (NSString * )targeByPreAction:(NSString*) action
{
    for (SHModule * module in [mDic allValues]) {
        if(module->pre_action != NULL && [module->pre_action isEqualToString:action]){
            return module->target;
        }
    }
    return nil;
}

- (GDataXMLDocument* )docForStyle:(NSString*)name{
    NSError* error = nil;
    NSData * data = nil;
    data = [[NSData alloc]initWithContentsOfFile: [[NSBundle mainBundle]pathForResource:name ofType:@"xml"] ];
    NSString *documentStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    GDataXMLDocument *_parserColor = [[GDataXMLDocument alloc] initWithXMLString:documentStr options:0 error:&error];
    [data release];
    [documentStr release];
    return _parserColor;
    
}
+ (SHModuleHelper*) instance{
    if(__instance == nil){
        __instance = [[SHModuleHelper alloc]init];
    }
    return __instance;
}


@end
