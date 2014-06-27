//
//  SHViewController.h
//  Core
//
//  Created by zywang on 13-9-3.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHSkin.h"
#import "SHIntent.h"

@interface SHViewController : UIViewController<ISHSkin>
{
    CGRect mRectkeybordview;
}

@property (nonatomic,strong) UIView * keybordView;

@property (nonatomic,assign) int keybordheight;

@property (nonatomic,assign) id delegate;

@property (nonatomic,strong) SHIntent * intent;

- (BOOL)checkIntent:(NSString*)error;

- (void)showWaitDialog:(NSString*)title state:(NSString*)state;

- (void)dismissWaitDialog;

- (void)dismissWaitDialog:(NSString*)msg;

- (void)dismissWaitDialogSuccess;

- (void)showWaitDialogForNetWork;

- (void)showWaitDialogForNetWorkDismissBySelf;

- (void)dismissWaitDialogSuccess:(NSString*) title;

- (void)alertViewCancelOnClick;

- (void)alertViewEnSureOnClick;

- (void)showAlertDialog:(NSString*)content;

- (void)showAlertDialogForCancel:(NSString*)content;

- (void)showAlertDialog:(NSString*)content otherButton:(NSString*)button;

- (void)showAlertDialog:(NSString*)content button:(NSString*)button otherButton:(NSString*)otherbutton;

- (void)showAlertDialog:(NSString*)content button:(NSString*)button otherButton:(NSString*)otherbutton tag:(int)tag;

- (void)dismiss;

- (void)btnBack:(NSObject*)sender;
@end
