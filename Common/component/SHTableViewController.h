//
//  SHTableViewController.h
//  Core
//
//  Created by zywang on 13-9-3.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "SHViewController.h"
#import "SHTableViewTitleContentBottomCell.h"
#import "SHTableViewTitleImageCell.h"
#import "SHTableViewTitleContentBottomCell.h"
#import "SHTableViewGeneralCell.h"
#import "SHTableViewUnReadNumberCell.h"
#import "SHNoneViewCell.h"

@interface SHTableViewController : SHViewController<UITableViewDelegate,UITableViewDataSource>
{
     NSMutableArray * mList;
    BOOL  mIsEnd;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (SHTableViewGeneralCell *)dequeueReusableGeneralCell;

- (SHTableViewGeneralCell*)dequeueReusableTitleContentCell;

- (SHTableViewTitleImageCell*)dequeueReusableTitleImageCell;

- (SHTableViewGeneralCell*)dequeueReusableTitleCustomCell:(NSString*)nibName identifier:(NSString*)identifier;

- (SHTableViewTitleContentBottomCell*)dequeueReusableTitleContentBottomCell;

- (SHTableViewUnReadNumberCell*) dequeueReusableunReadNumberCell;

- (SHNoneViewCell*)dequeueReusableNoneViewCell;
@end

