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
    NSString* msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",msg);
    NSError * error ;
    NSDictionary * netreutrn = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)NSJSONWritingPrettyPrinted error:&error];
    
    int code = [[netreutrn objectForKey:@"code"] integerValue];
    //NSLog("%@",netreutrn);
    NSString * message = [netreutrn objectForKey:@"message"];
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
        if( [netreutrn objectForKey:@"data"] && code >= 0){
            p (task,resData, obj);
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
}

@end
