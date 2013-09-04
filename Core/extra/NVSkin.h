//
//  NVSkin.h
//  Aroundme
//
//  Created by W Sheely on 12-7-30.
//  Copyright (c) 2012年 dianping.com. All rights reserved.
//

#import <UIKit/UIKit.h>


#define  CELL_DEFAULT_HEIGHT 44
#define  CELL_HEIGHT 72
#define  CELL_HEIGHT2 51

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
+(NVSkin*)instance;
//
- (id)resource: (NSString*)type  key:(NSString *) key;
-(NSString *)resourceString:(NSString*)key;
- (void)accommodate:(UIView*) view:(NSString*) key;
@end
 