//
//  UIButton+GFExtension.h
//  APPBase
//
//  Created by 峰 on 2019/10/10.
//  Copyright © 2019 ishansong. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (GFExtension)

/**
 给按钮添加富文本

 @param title 标题
 @param font 字号
 @param color 颜色
 @param state 状态
 */
- (void)gf_addTitle:(NSString *)title textFont:(UIFont *)font textColor:(UIColor *)color forState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
