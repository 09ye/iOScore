//
//  NSData+AES.h
//  Smile
//
//  Created by 周 敏 on 12-11-24.
//  Copyright (c) 2012年 BOX. All rights reserved.
//

#import "NSData+AES.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key {//加密
    return [SHTools AES256EncryptWithKey:self key:key];
}


- (NSData *)AES256DecryptWithKey:(NSString *)key {//解密
    return [SHTools AES256DecryptWithKey:self key:key];
}

@end
