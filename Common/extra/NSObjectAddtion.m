//
//  NSObjectAddtion.m
//  crowdfunding-arcturus
//
//  Created by sheely.paean.Nightshade on 14-4-23.
//  Copyright (c) 2014年 WSheely. All rights reserved.
//

#import "NSObjectAddtion.h"

@interface SHJump:NSObject
{
@public
    NSString * notification;
    SEL selector;
    id target;
}
@end

@implementation SHJump

- (void)dealloc
{
    [super dealloc];
}
@end

const static  NSMutableDictionary * __DIC;

@implementation NSObject(sheely)

- (void)performSelector:(SEL)aSelector afterNotification:(NSString*) notification
{
    if(__DIC == NULL){
        __DIC = [[NSMutableDictionary alloc ]init];
    }
    
    NSString * clazz = [SHModuleHelper.instance targeByPreAction:notification];
    if(clazz != nil){
        Class clacc = NSClassFromString(clazz);
        SEL sel = @selector(__GET_PRE_ACTION_STATE:);
        IMP imp =  [clacc methodForSelector:sel];
        if(imp > 0){
            NSError * error = [[[NSError alloc]init] autorelease];
            BOOL result = (BOOL)imp( clacc,  sel, error);
            if (result ) {
                [self methodForSelector:aSelector](self,aSelector);
            }else {
                SHJump * jump = [[[SHJump alloc]init] autorelease];
                jump->target = self;
                jump->selector = aSelector;
                jump->notification = notification;
                [__DIC setValue:jump forKey:notification];
                [[NSNotificationCenter defaultCenter ] addObserver:NSClassFromString(@"NSObject") selector: @selector( notifationReceiver:) name:jump->notification object:nil];
                SHIntent * intent = [[[SHIntent alloc]init] autorelease];
                intent.target = clazz;
                [[UIApplication sharedApplication]open:intent];
            }
        }
    }
}

+ (void)notifationReceiver:(NSNotification* )ns
{
  
    [SHIntentManager clear];
    SHJump * jp = [__DIC valueForKey:ns.name];
    [[NSNotificationCenter defaultCenter ]removeObserver:self name:ns.name object:nil];
    [jp->target methodForSelector:jp->selector](jp->target,jp->selector);
    [__DIC removeObjectForKey:ns.name];
}
@end
