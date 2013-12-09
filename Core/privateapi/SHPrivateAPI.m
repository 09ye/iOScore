//
//  PrivateAPI.m
//  Core
//
//  Created by sheely on 13-12-9.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHPrivateAPI.h"

@implementation SHPrivateAPI

+ (NSString *) imei;
{
   
//    const char *cconcat = [concat UTF8String];
//    
//    unsigned char result[20];
//    CC_SHA1(cconcat,strlen(cconcat),result);
//    
//    NSMutableString *hash = [NSMutableString string];
//    int i;
//    for (i=0; i < 20; i++)
//    {
//        [hash appendFormat:@"%02x",result[i]];
//    }
//    
//    return [hash lowercaseString];

}

extern NSString* CTSettingCopyMyPhoneNumber();
+ (NSString *) phoneNum
{
    NSString *phone = CTSettingCopyMyPhoneNumber();
    return phone;
}
@end
