//
//  UIAplication.m
//  siemens.bussiness.partner.CRM.tool
//
//  Created by WSheely on 14-3-5.
//  Copyright (c) 2014年 MobilityChina. All rights reserved.
//

#import "UIApplicationAddtion.h"

@implementation UIApplication(sheely)

- (void) openURL:(NSString *)url
{
   // [self openURL:(NSURL *)]
}

- (void) open:(SHIntent *)intent
{
    [SHIntentManager open:intent];
}
@end
