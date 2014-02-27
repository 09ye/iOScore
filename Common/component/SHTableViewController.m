//
//  SHTableViewController.m
//  Core
//
//  Created by zywang on 13-9-3.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHTableViewController.h"
#import "SHTableViewGeneralCell.h"
#import "SHTableViewTitleImageCell.h"

@interface SHTableViewController ()

@end

@implementation SHTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 44)];
    label.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    label.userstyle = @"labmidmilk";
    label.backgroundColor = [NVSkin.instance colorOfStyle:@"ColorBackGround"];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view.
}

- (void)loadNext
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (SHTableViewGeneralCell*)dequeueReusableGeneralCell
{
    
    return [self.tableView dequeueReusableGeneralCell];
}

- (SHTableViewGeneralCell*)dequeueReusableTitleContentCell
{
    
    return [self.tableView dequeueReusableTitleContentCell];
}

- (SHTableViewGeneralCell*)dequeueReusableTitleCustomCell:(NSString*)nibName identifier:(NSString*)identifier
{
    
    return [self.tableView dequeueReusableTitleCustomCell:(NSString*)nibName identifier:(NSString*)identifier];
}

- (SHTableViewTitleImageCell*)dequeueReusableTitleImageCell
{
    
    return [self.tableView dequeueReusableTitleImageCell];
}

- (SHTableViewTitleContentBottomCell*)dequeueReusableTitleContentBottomCell
{
    
    return [self.tableView dequeueReusableTitleContentBottomCell];
}

- (SHTableViewUnReadNumberCell*)dequeueReusableunReadNumberCell
{
    
    return [self.tableView dequeueReusableunReadNumberCell];
}

- (SHNoneViewCell*)dequeueReusableNoneViewCell
{
    
    return [self.tableView dequeueReusableNoneViewCell];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >= mList.count && mList.count == 0 ){
        SHNoneViewCell * cell;
        if(mIsEnd){
             cell = [self dequeueReusableNoneViewCell];
             cell.labContent.text = @"暂无相关讯息...";
        }else{
             cell = [self dequeueReusableNoneViewCell];
             cell.labContent.text = @"正在加载数据...";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}



@end
