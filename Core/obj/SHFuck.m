//
//  SHFuck.m
//  Core
//
//  Created by sheely on 13-10-15.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHFuck.h"

@implementation SHFuck

+ (NSString*) stringForKey:(NSString *)key  result :(NSDictionary * )dic extra:(NSDictionary*) ext;
{
    NSDictionary * meta = [ext valueForKey:key];
    NSObject * value = [dic valueForKey:key];
    if([[meta valueForKey:@"type"]isEqualToString:@"selection"]){
        NSArray * array = [meta valueForKey:@"selection"];
        for (NSArray * ary in array) {
            if([[ary objectAtIndex:0] isEqualToString:(NSString*)value])
            {
                return [ary objectAtIndex:1];
            }
        }
        
    }else if([[meta valueForKey:@"type"]isEqualToString:@"many2one"]){
        if([[value class]isSubclassOfClass:[NSArray class]]){
            return [((NSArray *)value) objectAtIndex:1 ];
        }
    }
    return @"";
}

@end
