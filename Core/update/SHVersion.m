//
//  SHVersion.m
//  Core
//
//  Created by sheely.paean.Nightshade on 10/6/13.
//  Copyright (c) 2013 zywang. All rights reserved.
//

#import "SHVersion.h"
#import <Foundation/NSObjCRuntime.h>

#define MAX_VERSION_COUNT 4
#define MAX_SINGLE_VERSION_VALUE 1000

@interface SHVersion ()
{
   
}

@end

@implementation SHVersion

@synthesize listver = _listver;

- (id)initWithString:(NSString*) str
{
    if(self = [self init]){
        NSArray *firstSplit = [str componentsSeparatedByString:@"."];
        if(firstSplit.count){
            NSMutableArray * array = [[NSMutableArray alloc]init];
            for (NSString * num in firstSplit) {
                [array addObject:[NSNumber numberWithLong:num.integerValue] ];
            }
            _listver = [array copy];
            return self;
        }else{
            return nil;
        }
    }
    return nil;
}

- (NSComparisonResult) compare :(SHVersion*)version
{
    long selfValue = [SHVersion longValue:self];
    long versValue = [SHVersion longValue:version];
    return  ( selfValue == versValue ? NSOrderedSame :( selfValue >versValue ? NSOrderedDescending :NSOrderedAscending ));
}

+ (long) longValue:(SHVersion*)version
{
    long selfValue = 0;
    for (int i = 0; i < version.listver.count; i++) {
        NSNumber * ver = [version.listver objectAtIndex:i];
        long value = 1;
        for (int j = 0 ; j< MAX_VERSION_COUNT - i -1; j++) {
            value *= MAX_SINGLE_VERSION_VALUE;
        }
        selfValue += value*ver.intValue;
    }
    return selfValue;
}

- (NSString*)description
{
    NSMutableString * des = [NSMutableString stringWithString:@""];
    for (int i = 0 ; i < self.listver.count ; i++) {
        if( i == self.listver.count -1){
            [des appendFormat:@"%d",((NSNumber*)[self.listver objectAtIndex:i]).intValue];
        }else{
            [des appendFormat:@"%d.",((NSNumber*)[self.listver objectAtIndex:i]).intValue];
        }
    }
    return des;
}

@end
