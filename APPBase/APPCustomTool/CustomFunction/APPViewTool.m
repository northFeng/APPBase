//
//  APPViewTool.m
//  APPBase
//
//  Created by 峰 on 2019/10/12.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPViewTool.h"

@implementation APPViewTool

///文字比例适配
+ (CGFloat)iPhoneAndIpadTextAdapter {
    
    if (kIsiPhone) {
        return 1.;
    }else{
        return 1.5;
    }
}

#pragma mark - ************************* 创建视图 *************************

///创建view
+ (UIView *)view_createViewWithColor:(UIColor *)color {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    return view;
}

///创建imgView
+ (UIImageView *)view_createImageViewWithImageName:(NSString *)imgName {
    
    UIImageView *imgView = [[UIImageView alloc] init];
    if (imgName) {
        imgView.image = [UIImage imageNamed:imgName];
    }
    
    return imgView;
}

///创建label
+ (UILabel *)view_createLabelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.textAlignment = alignment;
    
    return label;
}


///创建文字按钮
+ (UIButton *)view_createButtonTitle:(NSString *)title textColor:(UIColor *)textColor textFont:(UIFont *)font bgColor:(UIColor *)bgColor {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button gf_addTitle:title textFont:font textColor:textColor forState:UIControlStateNormal];
    
    if (bgColor) {
        button.backgroundColor = bgColor;
    }
    
    return button;
}

///创建普通 文字 & 选中文字  按钮
+ (UIButton *)view_createButtonTitleNormal:(NSString *)normalTitle normalTextColor:(UIColor *)normalColor selectTitle:(NSString *)selectTtitle selectTextColor:(UIColor *)selectColor textFont:(UIFont *)font bgColor:(UIColor *)bgColor {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (normalTitle) {
        [button gf_addTitle:normalTitle textFont:font textColor:normalColor forState:UIControlStateNormal];
    }
    if (selectTtitle) {
        [button gf_addTitle:selectTtitle textFont:font textColor:selectColor forState:UIControlStateSelected];
    }
    
    if (bgColor) {
        button.backgroundColor = bgColor;
    }
    
    return button;
}

///创建普通图片按钮
+ (UIButton *)view_createButtonImage:(NSString *)imageName {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    return button;
}

///创建普通图片按钮
+ (UIButton *)view_createButtonImageNormalImg:(NSString *)imgName_n selectImg:(NSString *)imgName_s {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (imgName_n) {
        [button setImage:[UIImage imageNamed:imgName_n] forState:UIControlStateNormal];
    }
    
    if (imgName_s) {
        [button setImage:[UIImage imageNamed:imgName_s] forState:UIControlStateSelected];
        button.selected = NO;
    }
    
    return button;
}

///创建一个图文按钮
+ (GFTextImageButton *)view_createButtonWithBtnType:(ButtonType)btnType title:(NSString *)title titleSize:(CGSize)titleSize titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor
                             imgName:(NSString *)imgName imgSize:(CGSize)imgSize spacing:(CGFloat)spacing{
    
    GFTextImageButton *btn = [GFTextImageButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title labelSize:titleSize labelFont:titleFont textColor:titleColor imageName:imgName imgSize:imgSize viewDirection:btnType spacing:spacing];
    
    return btn;
}

#pragma mark - ************************* view的边角、阴影 *************************

///一：普通四角圆角
+ (void)view_addRoundedCornersOnView:(UIView *)view cornersWidth:(CGFloat)widthCorner masksToBounds:(BOOL)bounds {
    
    view.layer.cornerRadius = widthCorner;
    view.layer.masksToBounds = bounds;
}

///添加指定位置的圆角
+ (void)view_addRoundedCornersOnView:(UIView *)view cornersPosition:(UIRectCorner)corners cornersWidth:(CGFloat)widthCorner{
    
    //设置所需的圆角位置以及大小
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(widthCorner, widthCorner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

///添加指定位置的圆角2
+ (void)view_addRoundedCornersOnView:(UIView *)view viewFrame:(CGRect)frame cornersPosition:(UIRectCorner)corners cornersWidth:(CGFloat)widthCorner{
    
    //设置所需的圆角位置以及大小
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:corners cornerRadii:CGSizeMake(widthCorner, widthCorner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}


///设置视图的圆角和边框线
+ (void)view_addBorderOnView:(UIView *)view borderWidth:(CGFloat)width borderColor:(UIColor *)color cornerRadius:(CGFloat)radius{
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
}


///添加阴影
+ (void)view_addShadowOnView:(UIView *)view shadowOffset:(CGSize)offsetSize shadowColor:(UIColor *)shadowColor shadowAlpha:(CGFloat)shadowAlpha{
    view.layer.shadowOffset = offsetSize;
    view.layer.shadowColor = shadowColor.CGColor;
    view.layer.shadowOpacity = shadowAlpha;
}

///父视图主动移除所有的子视图
+ (void)view_removeAllChildsViewFormSubView:(UIView *)subView{
    
    [subView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


///添加横向的混合颜色
+ (void)view_addHybridBackgroundColorWithColorOne:(UIColor *)colorOne andColorTwo:(UIColor *)colorTwo showOnView:(UIView *)onView{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)colorOne.CGColor, (__bridge id)colorTwo.CGColor];
    gradientLayer.locations = @[@0.4, @0.7, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1.0, 1);
    gradientLayer.frame = CGRectMake(0, 0, onView.frame.size.width, onView.frame.size.height);
    
    [onView.layer addSublayer:gradientLayer];
}

@end
