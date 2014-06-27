//
//  SHViewController.m
//  Core
//
//  Created by zywang on 13-9-3.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHViewController.h"

#import "MMProgressHUD.h"
@interface SHViewController ()<UIAlertViewDelegate>
{
    BOOL mIsShowKeyboard;
}
@end

@implementation SHViewController

@synthesize keybordView = _keybordView;

@synthesize keybordheight;

@synthesize delegate;

@synthesize intent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)checkIntent:(NSString*)error

{
    if(self.intent){
        return YES;
    }else{
        return NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"NaviBack"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//   // [self.navigationItem.backBarButtonItem setBackButtonBackgroundImage:nil forState:(UIControlState)UIControlStateNormal barMetrics:(UIBarMetrics)UIBarMetricsDefault];
	//initWithImage:[UIImage imageNamed:@"NaviBack"] target:self action:@selector(btnBack:)// Do any additional setup after loading the view.
    if(self.navigationController.viewControllers.count > 1){
        UIBarButtonItem * barbutton = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = barbutton;
    }
    [self loadSkin];
    
   
    
    //NVSkin * skin = [[NVSkin alloc]init];
}

- (void)btnBack:(NSObject*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setKeybordView:(UIView* )view
{
    _keybordView = view;
    mRectkeybordview = _keybordView.frame;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSkin
{
    self.view.backgroundColor = [NVSkin.instance colorOfStyle:@"ColorBaseBackGround"];
}

- (void)showAlertDialog:(NSString*)content
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:content delegate: self cancelButtonTitle:(NSString *) @"确认"  otherButtonTitles: nil];
    alert.delegate = self;
    [alert show];
}


- (void)showAlertDialogForCancel:(NSString*)content
{
     [self showAlertDialog:content button:@"确定" otherButton:@"取消"];
}

- (void)showAlertDialog:(NSString*)content otherButton:(NSString*)button
{
    [self showAlertDialog:content button:@"确定" otherButton:button];
}

- (void)showAlertDialog:(NSString*)content button:(NSString*)button otherButton:(NSString*)otherbutton
{
    [self showAlertDialog:content button:button otherButton:otherbutton tag:0];
}


- (void)showAlertDialog:(NSString*)content button:(NSString*)button otherButton:(NSString*)otherbutton tag:(int)tag
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle: otherbutton otherButtonTitles :button, nil];
    alert.delegate = self;
    alert.tag = tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self alertViewCancelOnClick];
    }else if (buttonIndex == 1){
        [self alertViewEnSureOnClick];
    }
}

- (void)alertViewCancelOnClick
{
}

- (void)alertViewEnSureOnClick
{
    
}

-(void)showWaitDialog:(NSString*)title state:(NSString*)state
{
    [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleNone];
    [MMProgressHUD showWithTitle:title status:state];
}
-(void)showWaitDialogForNetWork
{
//    dispatch_async(dispatch_get_main_queue(), ^{
        [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleNone];
        [MMProgressHUD showWithTitle:@"请求数据..." status:@"请稍候..."];

//    });
   
    //[self performSelector:@selector(showWaitDialogForWait) withObject:nil afterDelay:0.001];
}
//- (void)showWaitDialogForWait
//{
//    
//    [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleNone];
//    [MMProgressHUD showWithTitle:@"请求数据..." status:@"请稍候..."];
//
//}
-(void)showWaitDialogForNetWorkDismissBySelf
{
    [self showWaitDialogForNetWork];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self dismissWaitDialog];
    });

}

-(void)dismissWaitDialog:(NSString*)msg
{
    [MMProgressHUD dismissWithSuccess:msg];

}

-(void)dismissWaitDialog
{

    [MMProgressHUD dismiss];

}
-(void)dismissWaitDialogSuccess
{
    [MMProgressHUD dismissWithSuccess:@"完成"];
    
}

-(void)dismissWaitDialogSuccess:(NSString*) title
{
    [MMProgressHUD dismissWithSuccess:title];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
    
}

//- (void) __subview :(UIView*) view
//{
//    if( view.subviews.count > 0){
//        for (UIView * v  in view.subviews) {
//            [self __subview:v];
//        }
//    }else if ([view isKindOfClass:[UITextView class]] && [view respondsToSelector:@selector(resignFirstResponder)]){
//        //NSLog(@"%@",[[view class] description]);
//        [view resignFirstResponder];
//    }
//}

- (void)resignKeyBoardInView:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyBoardInView:v];
        }
        
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
}


-(void)viewDidDisappear:(BOOL)animated
{
    [self unregisterForKeyboardNotifications];
    [self resignKeyBoardInView:self.view];
}

- (void)registerForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShown:)
												 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardDidShown:(NSNotification*)ns
{
    if(!_keybordView){
        return;
    }
    if(!mIsShowKeyboard){
        mRectkeybordview = _keybordView.frame;
    }
    mIsShowKeyboard = YES;
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:0.3];
    //动画的内容
    
    //动画结束
   
    CGRect rect;
    [[[ns userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&rect];
    _keybordView.frame = CGRectMake(mRectkeybordview.origin.x,
                                    mRectkeybordview.origin.y - (self.keybordheight != 0? self.keybordheight: rect.size.height),
                                    mRectkeybordview.size.width,
                                    mRectkeybordview.size.height);
     [UIView commitAnimations];
}

- (void)unregisterForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardDidShowNotification
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardDidHideNotification
												  object:nil];
}

- (void)keyboardDidHidden:(NSNotification*)ns
{
    if(!_keybordView){
        return;
    }
    mIsShowKeyboard = NO;
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:0.3];
    _keybordView.frame = mRectkeybordview;
    [UIView commitAnimations];
}

- (void)dismiss
{
    [self.view setHidden:YES];
    [self.view removeFromSuperview];
}
@end
