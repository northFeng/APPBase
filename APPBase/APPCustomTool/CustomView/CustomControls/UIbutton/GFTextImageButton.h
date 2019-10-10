//
//  GFTextImageButton.h
//  APPBase
//  自定义图文按钮
//  Created by 峰 on 2019/10/10.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  按钮布局类型
 */
typedef NS_ENUM(NSInteger,ButtonType) {
    /**
     * 文字和图片是水平方向(左边文字，右边图片)
     */
    ButtonType_Horizontal_TextImg = 0,
    /**
     * 文字和图片是水平方向(左边图片，右边文字)
     */
    ButtonType_Horizontal_ImgText,
    /**
     * 文字和图片是竖直方向(上边文字，下边图片)
     */
    ButtonType_Vertical_TextImg,
    /**
     * 文字和图片是竖直方向(上边图片，下边文字)
     */
    ButtonType_Vertical_ImgText,
};

@interface GFTextImageButton : UIButton

///默认文字颜色
@property (nonatomic,strong) UIColor *defaultColor;

///选中颜色
@property (nonatomic,strong) UIColor *selectColor;

///默认图片
@property (nonatomic,strong) UIImage *defaultImage;

///选中图片
@property (nonatomic,strong) UIImage *selectImage;


/**
 *  @brief 创建图文按钮
 *
 *  @param title 按钮文字
 *  @param labelSize 文字label显示尺寸大小
 *  @param textFont  字体大小
 *  @param textColor 文字颜色
 *
 *  @param imgStr 图片文字
 *  @param imgSize 图片显示尺寸大小
 *
 *  @param buttonType 按钮类型
 *  @param spacing 文字和图片之间的间隔
 */
- (void)setTitle:(NSString *)title
       labelSize:(CGSize)labelSize
       labelFont:(UIFont *)textFont
       textColor:(UIColor *)textColor
       imageName:(NSString *)imgStr
         imgSize:(CGSize)imgSize
   viewDirection:(ButtonType)buttonType
         spacing:(CGFloat)spacing;


///更新文字
- (void)setNewTitle:(NSString *)title;

//更新图片
- (void)setNewImage:(NSString *)imgStr;


///更新文字和图片
- (void)setNewTitle:(NSString *)title newImg:(NSString *)imgStr;


///更新文字颜色和图片
- (void)setTextColor:(UIColor *)textColor newImg:(NSString *)imgStr;


///更新文字和图片
- (void)setNewTitle:(NSString *)title textColor:(UIColor *)textColor newImg:(NSString *)imgStr;


///设置默认
- (void)setDefaultStyle;

///设置选中
- (void)setSelectStyle;

@end

NS_ASSUME_NONNULL_END
