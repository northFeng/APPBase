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

/**
 创建一个label

 @param text 文字
 @param font 字号
 @param fontName 字体
 @param color 颜色
 @param alignment 对齐方式
 @return label
 */
+ (UILabel *)view_createLabelWith:(NSString *)text font:(CGFloat)font fontName:(NSString *)fontName textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment;

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


@end

NS_ASSUME_NONNULL_END
