//
//  SHConfigManager.m
//  CoreTest
//
//  Created by sheely.paean.Nightshade on 10/7/13.
//  Copyright (c) 2013 sheely.paean.coretest. All rights reserved.
//

#import "SHConfigManager.h"

@implementation SHConfigManager

@synthesize URL = _url;
@synthesize update;


- (void)setURL:(NSString *)url_
{
    _url = url_;
    if(_url){
        [self refresh];
    }
}

- (void)refresh
{
    SHPostTaskM * task = [[SHPostTaskM alloc]init];
    task.cachetype = CacheTypeKey;
    task.URL= self.URL;
    //demo
    NSString * json = @"{\"root\":{\"update\":{\"newVersion\":\"1.1.0\",\"content\":\"重大版本更新\",\"minVersion\":\"1.0.0\",\"updateDate\":\"2012-11-30\",\"updateURL\":{\"url1\":\"http://img.yingyonghuiss.com/apk/7171/com.aide.ui.1348731562275.apk\",\"url2\":\"http://img.yingyonghui.com/apk/7171/com.aide.ui.1348731562275.apk\",\"url3\":\"http://img.yingyonghui.com/apk/7171/com.aide.ui.1348731562275.apk\"}}}}}";
    
}

- (void)dealUpdate:(NSDictionary*)dic
{
    self.content = [dic valueForKey:@"content"];
    self.newVersion = [[SHVersion  alloc]initWithString: [dic valueForKey:@"newVersion"]];
    self.minVersion = [[SHVersion alloc]initWithString:[dic valueForKey:@"minVersion" ]];
    
}

static SHConfigManager * __instance;

+ (SHConfigManager*)instance
{
    if(__instance == nil){
        __instance = [[SHConfigManager alloc]init];
    }
    return __instance;
}
@end
