//
//  APPViewTool.m
//  APPBase
//
//  Created by 峰 on 2019/10/12.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPViewTool.h"

@implementation APPViewTool

#pragma mark - ************************* 创建视图 *************************

///创建label
+ (UILabel *)view_createLabelWith:(NSString *)text font:(CGFloat)font fontName:(NSString *)fontName textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont fontWithName:fontName size:font];
    label.textColor = color;
    label.textAlignment = alignment;
    
    return label;
}

///创建一个图文按钮
+ (GFTextImageButton *)view_createButtonWithBtnType:(ButtonType)btnType title:(NSString *)title titleSize:(CGSize)titleSize titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor
                             imgName:(NSString *)imgName imgSize:(CGSize)imgSize spacing:(CGFloat)spacing{
    
    GFTextImageButton *btn = [GFTextImageButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title labelSize:titleSize labelFont:titleFont textColor:titleColor imageName:imgName imgSize:imgSize viewDirection:btnType spacing:spacing];
    
    return btn;
}

///设置视图的圆角和边框线
+ (void)view_addBorderOnView:(UIView *)view borderWidth:(CGFloat)width borderColor:(UIColor *)color cornerRadius:(CGFloat)radius{
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
}


@end
