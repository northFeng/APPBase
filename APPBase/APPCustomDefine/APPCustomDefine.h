//
//  APPCustomDefine.h
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/26.
//  Copyright © 2018 ishansong. All rights reserved.
//

#ifndef APPCustomDefine_h
#define APPCustomDefine_h


//.h
#define SingletonIterface(class) +(instancetype) shared##class;
// .m
#define SingletonImplementation(class)         \
static class *_instance;                        \
\
+(id) allocWithZone : (struct _NSZone *) zone { \
static dispatch_once_t onceToken;           \
dispatch_once(&onceToken, ^{                \
_instance = [super allocWithZone:zone]; \
});                                         \
\
return _instance;                           \
}                                               \
\
+(instancetype) shared##class                   \
{                                           \
if (_instance == nil) {                     \
_instance = [[class alloc] init];       \
}                                           \
\
return _instance;                            \
}


#pragma mark - 常用自定义宏
//***********************************************
//**********      常用自定义宏      *************
//***********************************************

// ----------------------------- WeakSelf & StrongSelf -----------------------------
//__typeof__()和 __typeof()和 typeof() 都是 C 的扩展,且意思是相同的,标准C不包括这样的运算符
#define WeakSelf(self) __weak __typeof(self) weakSelf = self;
#define StrongSelf(weakSelf)  __strong __typeof(weakSelf) strongSelf = weakSelf;
#define WS(weakSelf)  __weak __typeof(self)weakSelf = self;


//获取屏幕 宽度、高度 APP_SCREEN_WIDTH  APP_SCREEN_HEIGHT APP_StatusBar_Height
#define APP_SCREEN_BOUNDS   ([[UIScreen mainScreen] bounds])
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define KSCALE [UIScreen mainScreen].bounds.size.width / 375.0
///y和x必须有一个为浮点型
#define kScaleHeight(y,x,width) (y)/(x)*(width)
#define kScaleW kScreenWidth/375.0
#define kScaleH kScreenHeight/667.0

//横版的比例
#define kHScaleW kScreenWidth/667.
#define kHScaleH kScreenHeight/375.


//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO)
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象或者内容为空
#define kObjectIsEmpty(_object) (_object == nil || [_object isKindOfClass:[NSNull class]] || ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) || ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))
//是否是空指针(对象)
#define kObjectIsEmptyEntity(_object) (_object == nil || [_object isKindOfClass:[NSNull class]])
//对象不为空
#define kObjectEntity(_object) (_object != nil && ![_object isKindOfClass:[NSNull class]])


#pragma mark -- 颜色RGB宏定义
//***************************************
//        颜色RGB宏定义
//***************************************

#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define RGBSA(r,a) [UIColor colorWithRed:(r)/255.0f green:(r)/255.0f blue:(r)/255.0f alpha:(a)]

#define RGBS(r) [UIColor colorWithRed:(r)/255.0f green:(r)/255.0f blue:(r)/255.0f alpha:1]

//rgb颜色转换（16进制->10进制） RGBX(oFFFFFF)
#define RGBX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#pragma mark - APP内主体常用颜色

///APP内主体黑色#41434E
#define APPColor_Black RGB(65,67,78)

///#333333
#define APPColor_BlackDeep RGBS(51)

///APP内主体深灰 999999 && 文字
#define APPColor_Gray RGBS(153)

///APP内tableView背景灰色 && cell分割间隔颜色 #F0F1F3
#define APPColor_Gray_tableView RGB(240,241,243)

///app内cell分割线颜色 #F1F1F1
#define APPColor_CellLine RGBS(241)

///蓝色 #20A8FF
#define APPColor_Blue RGB(32,168,255)

///白色
#define APPColor_White RGBS(255)


#pragma mark - 字体宏定义(账号信息中可存储字体信息，字体赋值通过宏定义方法)
//系统字体
#define kFontOfSystem(font) [UIFont systemFontOfSize:font]
//非系统字体
#define kFontOfCustom(name,font) [UIFont fontWithName:name size:font]

///标准字体
#define kRegularFont @"PingFangSC-Regular"
///中等字体
#define kMediumFont @"PingFangSC-Medium"
///半黑体
#define kSemiboldFont @"PingFangSC-Semibold"


#endif /* APPCustomDefine_h */
