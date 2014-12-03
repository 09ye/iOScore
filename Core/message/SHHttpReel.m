 //
//  SHHttpReel.m
//  Core
//
//  Created by sheely.paean.Nightshade on 11/23/14.
//  Copyright (c) 2014 zywang. All rights reserved.
//

#import "SHHttpReel.h"

@implementation SHHttpReel

@synthesize URL;

- (void)doRequest:(SHMsgM *)msg
{
    [self performSelectorOnMainThread:@selector(request:) withObject:msg waitUntilDone:YES];
}

- (void)request:(SHMsgM *)msg
{
    SHPostTaskM * post = [[SHPostTaskM alloc]init];
    post.URL = self.URL;
    [post.postArgs setValue:msg.target forKey:@"type"];
    [post.postArgs setValuesForKeysWithDictionary:msg.args];
    [post start:^(SHTask *t) {
        for (NSDictionary * dic  in [t.result valueForKey:@"notifications"]) {
            SHResMsgM * msg = [[SHResMsgM alloc]init];
            msg.guid = [dic valueForKey:@"guid"];
            msg.response = [dic valueForKey:@"responsetype"];
            msg.result = [dic valueForKey:@"responsedata"];
            if(self.delegate && [self.delegate respondsToSelector:@selector(processMsg:)]){
                [self.delegate processMsg:msg];
            }
        }
    } taskWillTry:^(SHTask *t) {
        
    } taskDidFailed:^(SHTask *t) {
        
    }];

}

@end
