//
//  APPColorFunction.h
//  APPBase
//  颜色功能类
//  Created by 峰 on 2019/10/10.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPColorFunction : NSObject

/**
 颜色值转换为Color

 @param stringToConvert 16进制的值比如：0x646364
 @param alpha 透明度
 @return 返回UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;

///动态颜色
+ (UIColor *)dynamicColorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;


#pragma mark - ************************* layer的CGColor赋值 *************************
///赋值layer 边框颜色
+ (void)layerSupView:(UIView *)supview layer:(CALayer *)layer dynamicBorderColor:(UIColor *)borderColor;

///赋值layer 阴影颜色
+ (void)layerSupView:(UIView *)supview layer:(CALayer *)layer dynamicShadowColor:(UIColor *)shadowColor;

///赋值layer 背景颜色
+ (void)layerSupView:(UIView *)supview layer:(CALayer *)layer dynamicBackgrounColor:(UIColor *)backgrounColor;


#pragma mark - ************************* 获取颜色 *************************
///基础黑色
+ (UIColor *)blackColor;

///基础白色颜色
+ (UIColor *)whiteColor;

///系统白亮文字颜色
+ (UIColor *)lightTextColor;;

///系统黑暗文字颜色
+ (UIColor *)drakTextColor;


///APP内黑色文字颜色384A74
+ (UIColor *)textBlackColor;

///APP内灰色C0C0C0
+ (UIColor *)textGrayColor;

///文字蓝色65BAFF
+ (UIColor *)textBlueColor;

///输入框背景颜色
+ (UIColor *)textFieldBgColor;



@end

NS_ASSUME_NONNULL_END
