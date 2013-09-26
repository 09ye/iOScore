//
//  NVSkin.h
//  Aroundme
//
//  Created by W Sheely on 12-7-30.
//  Copyright (c) 2012年 dianping.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RECT_RIGHTSHOW CGRectMake(87, 23, 930, 730)
#define RECT_RIGHTNAVIGATION CGRectMake(0, 0, 930, 44)
#define RECT_RIGHTLIST CGRectMake(0, 44, 240, 678)
#define RECT_RIGHTCONTENT CGRectMake(240, 0, 690  , 730)
#define CELL_GENERAL_HEIGHT 72
#define CELL_GENERAL_HEIGHT2 62
#define CELL_GENERAL_HEIGHT3 44
#define CELL_SECTION_HEADER_GENERAL_HEIGHT 38
#define RECT_MAIN_LANDSCAPE_RIGHT CGRectMake(-20, 0, 768, 1004)
#define RECT_MAIN_LANDSCAPE_LEFT CGRectMake(20, 0, 768, 1004)

@protocol NVSkinloading <NSObject>

- (void)loadSkin;

@end

typedef  enum
{
    TypeExternImage,
    TypeExternStretchableImage,
    TypeExternString
}TypeExtern;


typedef  enum
{
    FontScaleSmall,
    FontScaleMid,
    FontScaleLarge
}FontScale;

//typedef  enum
//{
//    ColorStyleMilkWhite,
//    ColorStyleDark,//深色
//    ColorStyleLight,//浅色
//    ColorStyleBigTitle,
//    ColorStyleCellBackGround,
//    ColorStyleCellSelected,
//    ColorStyleCellLightGry
//}ColorStyle;

@interface NVSkin : NSObject
{
    @private
    NSString*  _postfix;
    NSMutableDictionary * _colorDic;
    NSMutableDictionary * _fontDic;
    NSMutableDictionary * _stringDic;
    NSMutableDictionary * _styleDic;
}
@property (readonly,nonatomic) NSMutableDictionary* styleDic;
//@property (readonly)NVSkin* instance;
//图片
- (UIImage*)image:(NSString*)imageName;
//获取图片 
- (UIImage*)stretchImage:(NSString*)imageName;
//获取字体
- (UIFont*)systemFontOfSize:(FontScale) sacle;
//字体
- (UIFont*)boldSystemFontOfSize:(FontScale) sacle;
//颜色样式
-(UIColor*)colorOfStyle:(NSString*)syle;
//实例
-(UIFont*)fontOfStyle:(NSString*)style;

+(NVSkin*)instance;
//
- (id)resource: (NSString*)type  key:(NSString *) key;
-(NSString *)resourceString:(NSString*)key;
- (void)accommodate:(UIView*) view:(NSString*) key;
@end
 