//
//  UIBarButtonItemAddtion.m
//  Zambon
//
//  Created by sheely on 13-9-7.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "UIBarButtonItemAddtion.h"

@implementation UIBarButtonItem(UIBarButtonItem)
- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    return [self initWithImage:(UIImage *)nil title:(NSString*) title target:(id)target action:(SEL)action ];
}
- (id)initWithCancel:(id)target action:(SEL)action
{
   return [self initWithImage : nil title:@"关闭" target:target action:action];
}

- (id)initWithImage:(UIImage *)image title:(NSString*) title target:(id)target action:(SEL)action
{
    UIBarButtonItem * item =  [self init];
    UIImage * image_ = [UIImage imageNamed:@"button_item_bg"];
    if(image_){
    [item setBackgroundImage:image_ forState:(UIControlState)UIControlStateNormal barMetrics:(UIBarMetrics)UIBarMetricsDefault];
    }
    if(iOS7){
        //CGSize = [title ];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40 + 3)];
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 40, 27)];
        CGSize sz = [title sizeWithFont:btn.titleLabel.font];
        
        CGRect frame = view.frame;
        frame.size.width = sz.width + 20;
        view.frame = frame;
        
        frame = btn.frame;
        frame.size.width = sz.width + 20;
        btn.frame = frame;
        
        [btn setTitle:title forState:UIControlStateNormal];
        btn.userstyle = @"btnnavigation";
        if(image_){
            [btn setBackgroundImage:[NVSkin.instance stretchImage:@"button_item_bg"] forState:(UIControlState)UIControlStateNormal];
        }
        [view addSubview:btn];
        view.backgroundColor = [UIColor clearColor];
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        item.customView = view;
        return item;
    }else{
        item.target = target;
        item.action = action;
        item.image = image;
        item.title = title;
        return item;
    }
}
- (id)initWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIBarButtonItem * item =  [self init];
    UIImage * image_ = [UIImage imageNamed:@"button_item_bg"];
    if (image_) {
        [item setBackgroundImage:[UIImage imageNamed:@"button_item_bg"] forState:(UIControlState)UIControlStateNormal barMetrics:(UIBarMetrics)UIBarMetricsDefault];
        
    }
    if(iOS7){
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40 + 3)];
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 3, 40, 40)];
        [view addSubview:btn];
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        item.customView = view;
        return item;
    }else{
        item.target = target;
        item.action = action;
        item.image = image;
        return item;
    }
}
- (id)initWithSubmit:(id)target action:(SEL)action
{
    return[self initWithImage:nil title:@"提交" target:target action:action];
}
@end
