//
//  UITableViewAddtion.h
//  Zambon
//
//  Created by sheely on 13-11-20.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableView(Addition)

- (SHTableViewGeneralCell *)dequeueReusableGeneralCell;

- (SHTableViewGeneralCell*)dequeueReusableTitleContentCell;

- (SHTableViewTitleImageCell*)dequeueReusableTitleImageCell;

- (SHTableViewGeneralCell*)dequeueReusableTitleCustomCell:(NSString*)nibName identifier:(NSString*)identifier;

- (SHTableViewTitleContentBottomCell*)dequeueReusableTitleContentBottomCell;

- (SHTableViewUnReadNumberCell*) dequeueReusableunReadNumberCell;

- (SHNoneViewCell*)dequeueReusableNoneViewCell;

@end
