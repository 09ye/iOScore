//
//  SHAnalyzeFactory.m
//  Core
//
//  Created by sheely on 13-10-15.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHAnalyzeFactory.h"
#import "Respinfo.h"

@implementation SHAnalyzeFactoryExtension 
-(BOOL) analyzeDate:(SHTask *) task Data:(NSData*)data
{
    return NO; 
}

@end

@implementation SHAnalyzeFactory

static SHAnalyzeFactoryExtension* deleagte;

+ (void) setAnalyExtension:(SHAnalyzeFactoryExtension *) delegate_
{
    deleagte = delegate_;
}

+ (void) analyze:(SHTask*) task Data:(NSData*)data
{
    @try {
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
            //返回结果无法转换成json
            if (deleagte && [deleagte respondsToSelector:@selector(analyzeDate:Data:)]) {
                if ([deleagte analyzeDate: task Data:data]) {
                    //流程结束
                    return;
                }else{
                    code = CORE_NET_ERROR;
                    message = [error localizedDescription];
                }
            }
        }else{
            
            if([[netreutrn allKeys] containsObject:@"code"]){
                code = [[netreutrn objectForKey:@"code"] intValue];
            }else{
                //特异流程
                if (deleagte && [deleagte respondsToSelector:@selector(analyzeDate:Data:)]) {
                    if ([deleagte analyzeDate: task Data:data]) {
                        //流程结束
                        return;
                    }
                }else{
                    code = CORE_NET_FORMAT_ERROR;
                    
                }
            }
#ifdef DEBUG
            NSLog(@"%@",netreutrn);
#endif
            if([netreutrn valueForKey:@"msg"]){
                message = [netreutrn  objectForKey:@"msg"];
                
            }else{
                message = [netreutrn objectForKey:@"message"];
                
            }
            
            Respinfo* res  = [[Respinfo alloc]initWithCode:(int)code message:message];
            SEL resSel = @selector(setRespinfo:);
            if([task respondsToSelector:resSel] && res){
                IMP p = [task methodForSelector:resSel];
                //p (task,resSel,res);
                [task setRespinfo:res];
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
                        SHEntironment.instance.sessionid = [d valueForKey:@"session_id"];
                    }
                }
                
                if( [netreutrn objectForKey:@"data"] && code >= 0){
                    if([obj isKindOfClass:[NSNumber class]]){
                        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
                        [dic setValue: obj forKey:@"number"];
                        //p (task,resData, dic);
                        [task setResult:dic];
                    }
                    else if([obj isKindOfClass:[NSNull class]]){
//                        p (task,resData, [[NSObject alloc]init]);
                        [task setResult:[[NSObject alloc]init]];
                    }
                    else{
                        //p (task,resData, obj);
                        [task setResult:obj];
                    }
                    
                }else{
                    //p (task,resData,[[NSObject alloc]init]);
                    [task setResult:[[NSObject alloc]init]];
                }
            }
            NSDictionary * mete = [netreutrn valueForKey:@"meta"];
            if(mete){
                //NSDictionary * dc
                SEL resExtra = @selector(setExtra:);
                IMP p = [task methodForSelector:resExtra];
                //p (task,resExtra, mete);
                [task setExtra:mete];
            }
            if(code == CODE_RELOGIN){//重新登录消息
                [[NSNotificationCenter defaultCenter] postNotificationName:CORE_NOTIFICATION_LOGIN_RELOGIN object:nil];
            }
            
            
        }
        
    }
    @catch (NSException *exception) {
        
        Respinfo* res  = [[Respinfo alloc]initWithCode:CORE_NET_ANALYZE_ERROR message:exception.reason];
        SEL resSel = @selector(setRespinfo:);
        if([task respondsToSelector:resSel] && res){
            IMP p = [task methodForSelector:resSel];
            p (task,resSel,res);
        }
        SEL resData = @selector(setResult:);
        if([task respondsToSelector:resData]){
            IMP p = [task methodForSelector:resData];
            p (task,resData,[[NSObject alloc]init]);
            
        }
    }
    @finally {
        
    }
    
}

@end
