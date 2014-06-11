//
//  UITableViewAddtion.m
//  Zambon
//
//  Created by sheely on 13-11-20.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "UITableViewAddtion.h"

@implementation UITableView(Addition)


- (SHTableViewGeneralCell*)dequeueReusableTitleContentCell
{
    
    SHTableViewGeneralCell * cell = [self dequeueReusableCellWithIdentifier:@"table_title_content_cell"];
    if(cell == nil){
        cell = (SHTableViewGeneralCell*)[[[NSBundle mainBundle]loadNibNamed:@"SHTableViewTitleContentCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}

- (SHTableViewGeneralCell*)dequeueReusableTitleCustomCell:(NSString*)nibName identifier:(NSString*)identifier
{
    
    SHTableViewGeneralCell * cell = [self dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = (SHTableViewGeneralCell*)[[[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}

- (SHTableViewTitleImageCell*)dequeueReusableTitleImageCell
{
    
    SHTableViewTitleImageCell * cell = [self dequeueReusableCellWithIdentifier:@"tableview_cell_title_image_cell"];
    if(cell == nil){
        cell = (SHTableViewTitleImageCell*)[[[NSBundle mainBundle]loadNibNamed:@"SHTableViewTitleImageCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}

- (SHTableViewTitleContentBottomCell*)dequeueReusableTitleContentBottomCell
{
    
    SHTableViewTitleContentBottomCell * cell = [self dequeueReusableCellWithIdentifier:@"tableview_cell_title_content_bottom_cell"];
    if(cell == nil){
        cell = (SHTableViewTitleContentBottomCell*)[[[NSBundle mainBundle]loadNibNamed:@"SHTableViewTitleContentBottomCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}

- (SHTableViewUnReadNumberCell*)dequeueReusableunReadNumberCell
{
    
    SHTableViewUnReadNumberCell * cell = [self dequeueReusableCellWithIdentifier:@"tableview_unreadnumber_cell"];
    if(cell == nil){
        cell = (SHTableViewUnReadNumberCell*)[[[NSBundle mainBundle]loadNibNamed:@"SHTableViewUnReadNumberCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}

- (SHNoneViewCell*)dequeueReusableNoneViewCell
{
    
    SHNoneViewCell * cell = [self dequeueReusableCellWithIdentifier:@"none_view_cell"];
    if(cell == nil){
        cell = (SHNoneViewCell*)[[[NSBundle mainBundle]loadNibNamed:@"SHNoneViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}
- (SHTableViewGeneralCell*)dequeueReusableGeneralCell
{
    
    SHTableViewGeneralCell * cell = [self dequeueReusableCellWithIdentifier:@"shtabview_general_cell"];
    if(cell == nil){
        cell = (SHTableViewGeneralCell*)[[[NSBundle mainBundle]loadNibNamed:@"SHTableViewGeneralCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}

@end
