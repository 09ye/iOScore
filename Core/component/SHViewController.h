//
//  SHViewController.h
//  Core
//
//  Created by zywang on 13-9-3.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHSkin.h"
@interface SHViewController : UIViewController<ISHSkin>
{
}

-(void)showWaitDialog:(NSString*)title state:(NSString*)state;
@end
