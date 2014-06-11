//
//  SHAnalyzeFactory.m
//  Core
//
//  Created by sheely on 13-10-15.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHAnalyzeFactory.h"
#import "Respinfo.h"

@implementation SHAnalyzeFactory

+ (void) analyze:(SHTask*) task Data:(NSData*)data
{
    //NSString* msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",msg);
    NSError * error ;
    NSDictionary * netreutrn = nil;
    if(data != nil){
        netreutrn  = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)NSJSONWritingPrettyPrinted error:&error];
    }
    int code = 0;
    NSString * message;
    if(netreutrn == nil){
        code = CORE_NET_ERROR;
        message = @"服务器没有返回信息";
    }else{
        if([[netreutrn allKeys] containsObject:@"code"]){
            code = [[netreutrn objectForKey:@"code"] intValue];
        }else{
            code = CORE_NET_FORMAT_ERROR;
        }
        //NSLog("%@",netreutrn);
        message = [netreutrn objectForKey:@"message"];

    }

    Respinfo* res  = [[Respinfo alloc]initWithCode:(int)code message:message];
    SEL resSel = @selector(setRespinfo:);
    if([task respondsToSelector:resSel] && res){
        IMP p = [task methodForSelector:resSel];
        p (task,resSel,res);
    }
    SEL resData = @selector(setResult:);
    if([task respondsToSelector:resData]){
        IMP p = [task methodForSelector:resData];
        NSObject * obj = [netreutrn valueForKey:@"data"];
//        if([obj containsObject:@"session_id"]){
//            Entironment.instance.sessionid = [netreutrn valueForKey:@"session_id"];
//        }
        if([obj isKindOfClass:[NSDictionary class]]){
            NSDictionary * d = (NSDictionary*)obj;
            if([[d allKeys] containsObject:@"session_id"]){
                Entironment.instance.sessionid = [d valueForKey:@"session_id"];
            }
        }
        
        if( [netreutrn objectForKey:@"data"] && code >= 0){
            if([obj isKindOfClass:[NSNumber class]]){
                NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
                [dic setValue: obj forKey:@"number"];
                p (task,resData, dic);
            }else{
                p (task,resData, obj);
            }
            
        }else{
            p (task,resData,[[NSObject alloc]init]);
        }
    }
    NSDictionary * mete = [netreutrn valueForKey:@"meta"];
    if(mete){
        //NSDictionary * dc
           SEL resExtra = @selector(setExtra:);
        IMP p = [task methodForSelector:resExtra];
        p (task,resExtra, mete);
    }
    if(code == CODE_RELOGIN){//重新登录消息
        [[NSNotificationCenter defaultCenter] postNotificationName:CORE_NOTIFICATION_LOGIN_RELOGIN object:nil];
    }
    
}

@end
