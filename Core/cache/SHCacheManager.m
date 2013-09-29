//
//  SHCacheManager.m
//  Core
//
//  Created by sheely on 13-9-16.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHCacheManager.h"
#import "DatabaseOperation.h"

static  NSString * SQL_CREATETABLE = @" CREATE TABLE cache (id integer  NOT NULL  PRIMARY KEY AUTOINCREMENT DEFAULT 0,url Varchar(500),content Binary DEFAULT NULL,encryption Boolean DEFAULT false,time Timestamp DEFAULT CURRENT_TIMESTAMP,type integer DEFAULT 0,size integer DEFAULT 0)";
static NSString * SQL_DELETETABLE = @"DROP TABLE cache;";

static NSString * SQL_INDEX = @"CREATE  UNIQUE INDEX index11 ON cache (url);";

static int version = 4;
static NSString * cacheversion = @"cacheversion";

@interface SHCacheManager ()
{
    DatabaseOperation * mDo;
    NSUserDefaults * userdef;

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
        userdef = [NSUserDefaults standardUserDefaults];
        int  temp = [userdef integerForKey:cacheversion];
        if(temp < version){
            [mDo exec:SQL_DELETETABLE];
            if([mDo createTable:SQL_CREATETABLE] && [mDo exec:SQL_INDEX]){
                
                [userdef setInteger:version forKey:cacheversion];
            }
            
        }
    }
    return self;
}

- (BOOL)push:(NSData *)data forKey:(NSString *)url
{
    NSString * sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (url, content, size) VALUES(?, ?, ?);", @"cache"];
    NSMutableArray * args  = [[NSMutableArray alloc]init];
    [args addObject:url];
    [args addObject:data];
    [args addObject:[[NSNumber alloc ] initWithDouble:data.length]];

    return [mDo oprationTableByStms:sql args:args];

}

- (NSData * )fetch:(NSString*)url
{
    NSString * sql = [NSString stringWithFormat:@"SELECT CONTENT FROM  %@  WHERE  (url = ?) ", @"cache"];
    NSArray * args = [NSArray arrayWithObject:url];
    NSArray * array = [NSArray arrayWithObject:[NSData class]];
    NSArray * result = [mDo fetchRowByStms:sql whereargs:args selectargs:array];
    if(result.count > 0 ){
        return [result objectAtIndex:0];
    }
    return nil;
}
- (NSArray * )fetchOdTime:(NSString*)url
{
    NSString * sql = [NSString stringWithFormat:@"SELECT CONTENT,TIME FROM  %@  WHERE  (url = ?) ", @"cache"];
    NSArray * args = [NSArray arrayWithObject:url];
    NSArray * array = [NSArray arrayWithObjects:[NSData class],[NSString class],nil];
    NSArray * result = [mDo fetchRowByStms:sql whereargs:args selectargs:array];
    return result;
}
//- (NSArray * )querryTable:(NSString*) url
//{
//    NSArray * array = [mDo querryTable:url];
//    return array;
//}
@end
