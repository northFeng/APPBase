//
//  APPViewTool.h
//  APPBase
//  view的工厂工具
//  Created by 峰 on 2019/10/12.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GFTextImageButton.h"//图文按钮

NS_ASSUME_NONNULL_BEGIN

@interface APPViewTool : NSObject

///创建view
+ (UIView *)view_createViewWithColor:(UIColor *)color;

/**
 创建一个label

 @param text 文字
 @param font 字号
 @param color 颜色
 @param alignment 对齐方式
 @return label
 */
+ (UILabel *)view_createLabelWith:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment;

/**
 创建一个图文按钮button

 @param btnType btn上图文的排列类型
 @param title btn文字
 @param titleSize btn文字Size
 @param titleFont btn文字字体
 @param titleColor btn文字颜色
 @param imgName btn图片name
 @param imgSize btn图片Size
 @param spacing btn上图文之间间距
 @return GFTextImageButton
 */
+ (GFTextImageButton *)view_createButtonWithBtnType:(ButtonType)btnType title:(NSString *)title titleSize:(CGSize)titleSize titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor
                                   imgName:(NSString *)imgName imgSize:(CGSize)imgSize spacing:(CGFloat)spacing;

/**
 添加边框

 @param view view
 @param width 边框宽度
 @param color 边框颜色
 @param radius 边框圆角
 */
+ (void)view_addBorderOnView:(UIView *)view borderWidth:(CGFloat)width borderColor:(UIColor *)color cornerRadius:(CGFloat)radius;


///添加指定位置的圆角(使用前必须先设置frame)
+ (void)view_addRoundedCornersOnView:(UIView *)view cornersPosition:(UIRectCorner)corners cornersWidth:(CGFloat)widthCorner;

///添加指定位置的圆角（参数frame为CGRectMake(0, 0, weidth, height)）宽和高必须是视图显示后的尺寸！！
+ (void)view_addRoundedCornersOnView:(UIView *)view viewFrame:(CGRect)frame cornersPosition:(UIRectCorner)corners cornersWidth:(CGFloat)widthCorner;

///添加阴影 offsetSize:阴影的偏移量  shadowColor:阴影的颜色  shadowAlpha:阴影透明度
+ (void)view_addShadowOnView:(UIView *)view shadowOffset:(CGSize)offsetSize shadowColor:(UIColor *)shadowColor shadowAlpha:(CGFloat)shadowAlpha;

///父视图主动移除所有的子视图
+ (void)view_removeAllChildsViewFormSubView:(UIView *)subView;

///添加横向的混合颜色
+ (void)view_addHybridBackgroundColorWithColorOne:(UIColor *)colorOne andColorTwo:(UIColor *)colorTwo showOnView:(UIView *)onView;


@end

NS_ASSUME_NONNULL_END
