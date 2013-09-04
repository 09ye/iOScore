//
//  SHViewController.m
//  Core
//
//  Created by zywang on 13-9-3.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHViewController.h"
#import "NVSkin.h"
#import "MMProgressHUD.h"
@interface SHViewController ()

@end

@implementation SHViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadSkin];
    //NVSkin * skin = [[NVSkin alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSkin
{
    
}

-(void)showWaitDialog:(NSString*)title state:(NSString*)state
{
    //MMProgressHUD* d = [[MMProgressHUD alloc]init];
    [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
    [MMProgressHUD showWithTitle:@"Plain" status:@"No Border"];
}
@end
