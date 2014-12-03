//
//  NVSkin.m
//  Aroundme
//
//  Created by W Sheely on 12-7-30.
//  Copyright (c) 2012年 dianping.com. All rights reserved.
//

#import "SHSkin.h"
#import "GDataXMLNode.h"

#import <objc/runtime.h>


@implementation NVSkinValue

NSString * __color = @"color";
+ (void)setColor:(NSString *)color
{
    __color = color;
}

+ (NSString*) color
{
    return __color;
}

@end


@implementation SHSkin

static SHSkin* _instance = nil;

+(SHSkin*)instance{
    if(_instance == nil){
        _instance = [[SHSkin alloc]init];
    }
    return _instance;
}

- (id)init{
    if(self = [super init]){
        [self initColor];
        [self initString];
        [self initFont];
        [self initStyle];
    }
    return self;
}

- (GDataXMLDocument* )docForStyle:(NSString*)name{
    NSError* error = nil;
    NSData * data = nil;
    data = [[NSData alloc]initWithContentsOfFile: [[NSBundle mainBundle]pathForResource:name ofType:@"xml"] ];
    NSString *documentStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    GDataXMLDocument *_parserColor = [[GDataXMLDocument alloc] initWithXMLString:documentStr options:0 error:&error];
    [data release];
    [documentStr release];
    return _parserColor;

}
//
- (NSMutableDictionary*)styleDic{
    return _styleDic;
}
- (void) initColor{
 
    GDataXMLDocument* doc = [self docForStyle:NVSkinValue.color];
    NSArray * array = ((GDataXMLNode*)[[doc nodesForXPath:[NSString stringWithFormat:@"//Color"] error:nil] objectAtIndex:0]).children;
  

    _colorDic = [[NSMutableDictionary alloc ]init];
    for (GDataXMLElement* ele in array) {
        NSString * name = [ele attributeForName:@"name"].stringValue;
        double r = [ele attributeForName:@"R"].stringValue.doubleValue;
        double g = [ele attributeForName:@"G"].stringValue.doubleValue;
        double b = [ele attributeForName:@"B"].stringValue.doubleValue;
        double a = [ele attributeForName:@"A"].stringValue.doubleValue;
        [_colorDic setValue:[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a] forKey:name];
    }
    //[doc release];
}

- (void) initString{
   
    GDataXMLDocument* doc = [self docForStyle:@"string"];
    NSArray * array = ((GDataXMLNode*)[[doc nodesForXPath:[NSString stringWithFormat:@"//String"] error:nil] objectAtIndex:0]).children;
    _stringDic = [[NSMutableDictionary alloc ]init];
    for (GDataXMLElement* ele in array) {
        NSString * name = [ele attributeForName:@"name"].stringValue;
        NSString* r = [ele attributeForName:@"value"].stringValue;
        [_stringDic setValue:r forKey:name];
    }
    //[doc release];
}


- (void) initFont{
    GDataXMLDocument* doc = [self docForStyle:@"font"];
    NSArray * array = ((GDataXMLNode*)[[doc nodesForXPath:[NSString stringWithFormat:@"//Font"] error:nil] objectAtIndex:0]).children;
    _fontDic = [[NSMutableDictionary alloc ]init];
    for (GDataXMLElement* ele in array) {
        NSString * name = [ele attributeForName:@"name"].stringValue;
        int r = [ele attributeForName:@"size"].stringValue.integerValue;
        [_fontDic setValue:[UIFont systemFontOfSize:r] forKey:name];
    }
    //[doc release];
}

- (void) initStyle{
    
    GDataXMLDocument* doc = [self docForStyle:@"style"];
    NSArray * styles = ((GDataXMLNode*)[[doc nodesForXPath:[NSString stringWithFormat:@"//Style"] error:nil] objectAtIndex:0]).children;
    _styleDic = [[NSMutableDictionary alloc]init];
    for (GDataXMLNode* node in styles) {
        [_styleDic setValue:[node retain] forKey:node.name];
    }

}
- (UIImage* )image:(NSString*)imageName
{
    return [UIImage imageNamed:imageName];
}
//获取图片
- (UIImage* )stretchImage:(NSString*)imageName
{
    UIImage* image = [self image:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}
//获取字体
- (UIFont*)systemFontOfSize:(FontScale) sacle
{
    switch (sacle) {
        case FontScaleSmall:
            return [UIFont systemFontOfSize:14];
            break;
        case FontScaleMid:
            return [UIFont systemFontOfSize:16];
            break;
        case FontScaleLarge:
            return [UIFont systemFontOfSize:18];
            break;
        default:
            break;
    }
}
//字体
- (UIFont*)boldSystemFontOfSize:(FontScale) sacle
{
    switch (sacle) {
        case FontScaleSmall:
            return [UIFont boldSystemFontOfSize:13];
            break;
        case FontScaleMid:
            return [UIFont boldSystemFontOfSize:15];
            break;
        case FontScaleLarge:
            return [UIFont boldSystemFontOfSize:17];
            break;
        
        default:
            break;
    }

}
-(UIColor*)fontOfStyle:(NSString*)style
{
    return [self resource:@"UIFont" key:style];
}
-(UIColor*)colorOfStyle:(NSString*)style
{
     return [self resource:@"UIColor" key:style];
}
//-(UIColor*)colorOfStyle:(ColorStyle)syle
//{
//    switch (syle) {
//        case ColorStyleDark:
//        
//            return [self resource:@"UIColor" key:@"ColorStyleDark"];
//            break;
//        case ColorStyleLight:
//            return [self resource:@"UIColor" key:@"ColorStyleLight"];
//            break;
//        case ColorStyleBigTitle:
//            return [self resource:@"UIColor" key:@"ColorStyleBigTitle"];
//            break;
//        case ColorStyleCellBackGround:
//            return [self resource:@"UIColor" key:@"ColorStyleCellBackGround"];
//            break;
//        case ColorStyleCellSelected:
//            return [self resource:@"UIColor" key:@"ColorStyleCellSelected"];
//        case ColorStyleMilkWhite:
//            return [self resource:@"UIColor" key:@"ColorStyleMilkWhite"];
//        case ColorStyleCellLightGry:
//            return [self resource:@"UIColor" key:@"ColorStyleCellLightGry"];
//            
//        default:
//            return [self resource:@"UIColor" key:@"ColorStyleDark"];
//          
//    }
//}
//
- (void)accommodate:(UIView*) view:(NSString*) key{
    GDataXMLNode* keynode = [_styleDic valueForKey:key];
    //继承
    if ([keynode isKindOfClass:[GDataXMLElement class]]) {
        GDataXMLNode *parent = [(GDataXMLElement*)keynode attributeForName:@"parent"];
        //继承
        if(parent != nil && parent.stringValue != nil){
            [self accommodate:view :parent.stringValue];
        }
    }
   //read
    for (GDataXMLElement* elme in keynode.children) {
        GDataXMLNode *name = [elme attributeForName:@"name"];
        GDataXMLNode *type = [elme attributeForName:@"type"];
        GDataXMLNode *value = [elme attributeForName:@"value"];
        GDataXMLNode *externType = [elme attributeForName:@"externType"];
        GDataXMLNode *externValue = [elme attributeForName:@"extern"];
        
        NSString* head = [name.stringValue substringToIndex:1];
        NSString* content = [name.stringValue substringFromIndex:1];
        NSString* selName = [NSString stringWithFormat:@"set%@%@:",[head capitalizedString],content];
        SEL sel = NSSelectorFromString(selName);
        if([view respondsToSelector:sel]){//
            id resouce = [self resource:type.stringValue key:value.stringValue];
            if(resouce != nil){
                NSArray* args = nil;
                NSArray* types = nil;
                if(externType.stringValue.length > 0 && externValue.stringValue.length > 0 ){
                    types =[NSArray arrayWithObject:externType.stringValue];
                    args = [NSArray arrayWithObject:externValue.stringValue];
                }
                [self sendMsg:sel object:view arg:resouce types:types args: args];
            }
        }
    }
   
}
- (void) sendMsg :(SEL)sel object:(NSObject*) obj arg:(id)arg types:(NSArray*)types args:(NSArray*)args{
    IMP p = [obj methodForSelector:sel];
//    Method m = class_getInstanceMethod([obj class], sel);
//    method_getNumberOfArguments(m);
    if( arg == nil){
        p(obj,sel);
    }else if (args.count == 0){
        if([arg isKindOfClass: [NSNumber class]] == YES){
            p(obj,sel,((NSNumber*)arg).integerValue);
        }else{
            p(obj,sel,arg);
        }
    }else if(args.count == 1){
        
        if([[types objectAtIndex:0 ] caseInsensitiveCompare:@"int" ] == NSOrderedSame){
            int perId = ((NSString*)[args objectAtIndex:0]).integerValue;
            p(obj,sel,arg,perId);
        }else{
            p(obj,sel,arg, [args objectAtIndex:0]);
        }
    }else if (args.count == 2){
        p(obj,sel,[args objectAtIndex:0],[args objectAtIndex:1]);
    }
   
}

-(id)resource: (NSString*) type  key:(NSString *) key{
    id resource;
    if ([type caseInsensitiveCompare:@"UIColor"] == NSOrderedSame){
        resource = [_colorDic valueForKey:key];
    }else if ([type caseInsensitiveCompare:@"UIFont"] == NSOrderedSame){
        resource = [_fontDic valueForKey:key];
    }else if ([type caseInsensitiveCompare:@"UIImage.Stretchable"] == NSOrderedSame){
        resource = [self stretchImage:key];
    }else if ([type caseInsensitiveCompare:@"UIImage"] == NSOrderedSame){
        resource = [self image:key];
    }else if ([type caseInsensitiveCompare:@"NSString"] == NSOrderedSame){
        resource = [_stringDic valueForKey:key] ;
    }else if ([type caseInsensitiveCompare:@"int"] == NSOrderedSame){
         resource = [[NSNumber alloc] initWithInt:[key integerValue]];
    }else{
        resource = nil;
    }
    return resource;
}
-(NSString *)resourceString:(NSString*)key{
    return [self resource:@"NSString" key:key];
}
- (void)dealloc
{
    [_colorDic release];
    [_fontDic release];
    [_stringDic release];
    [_styleDic release];
    [super dealloc];
}
@end
