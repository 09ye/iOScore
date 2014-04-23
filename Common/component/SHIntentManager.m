//
//  SHIntentManager.m
//  siemens.bussiness.partner.CRM.tool
//
//  Created by WSheely on 14-3-5.
//  Copyright (c) 2014年 MobilityChina. All rights reserved.
//

#import "SHIntentManager.h"

@implementation SHIntentManager

+ (void)open:(SHIntent *)intent
{
    if(intent.target){
        Class  class =  NSClassFromString(intent.target);
        NSObject * obj = Nil;
        if(class){
            obj = [[class alloc]init];
        }
        if([obj isKindOfClass:[SHViewController class]]){
            SHViewController * controller = (SHViewController*)obj;
            controller.intent = intent;
            NSString * error;
            BOOL bo = [controller checkIntent:error];
            if(bo){
                controller.delegate = intent.delegate;//delegate;
                if (intent.container){
                    if([intent.container isKindOfClass:[UINavigationController class]]){
                        UINavigationController * naviController = (UINavigationController*)intent.container;
                        [naviController pushViewController:controller animated:YES];
                    }
                }else{
                    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:controller.view];
                }
            }else{
                SHContentViewController * errorController = [[SHContentViewController alloc]init];
                errorController.title = @"错误页面";
                if(error == nil){
                    errorController.content = @"参数错误";
                }else{
                    errorController.content = error;
                }
                if (intent.container){
                    if([intent.container isKindOfClass:[UINavigationController class]]){
                        UINavigationController * naviController = (UINavigationController*)intent.container;
                        [naviController pushViewController:errorController animated:YES];
                    }
                }else{
                    [[UIApplication sharedApplication].keyWindow.rootViewController addChildViewController:errorController];
                    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:errorController.view];
                }

            }
        }else {
            NSString * error;
            SHContentViewController * errorController = [[SHContentViewController alloc]init];
            errorController.title = @"错误页面";
            if(error == nil){
                errorController.content = @"不存在该页面";
            }else{
                errorController.content = error;
            }

            if (intent.container){
                if([intent.container isKindOfClass:[UINavigationController class]]){
                    UINavigationController * naviController = (UINavigationController*)intent.container;
                    [naviController pushViewController:errorController animated:YES];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow.rootViewController addChildViewController:errorController];
                [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:errorController.view];
            }

        }
    }
}
@end
