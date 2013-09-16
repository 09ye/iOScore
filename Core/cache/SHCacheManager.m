//
//  SHCacheManager.m
//  Core
//
//  Created by sheely on 13-9-16.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHCacheManager.h"
#import "DatabaseOperation.h"
static  NSString * SQL_CREATETABLE = @"CREATE TABLE cache (id integer  NOT NULL  PRIMARY KEY AUTOINCREMENT DEFAULT 0,url Varchar(500),content Binary DEFAULT NULL,encryption Boolean DEFAULT false,time Timestamp DEFAULT CURRENT_TIMESTAMP,type integer DEFAULT 0,size integer DEFAULT 0)";

@interface SHCacheManager ()
{
    DatabaseOperation * mDo;
}

@end
static SHCacheManager* mCache;

@implementation SHCacheManager

+ (SHCacheManager*)instance
{
    if(mCache == nil){
        mCache = [[SHCacheManager alloc]init];
    }
    return mCache;
}

- (SHCacheManager*)init
{
    if(self = [super init]){
        mDo = [[DatabaseOperation alloc]initWithDbName:@"cache.db"];
        [mDo createTable:SQL_CREATETABLE];
    }
    return self;
}

- (BOOL)push:(NSData *)data forKey:(NSString *)url
{
   return [mDo push:data forKey:url];
}
- (NSArray * )querryTable:(NSString*) url
{
    NSArray * array = [mDo querryTable:url];
    return array;
}
@end
