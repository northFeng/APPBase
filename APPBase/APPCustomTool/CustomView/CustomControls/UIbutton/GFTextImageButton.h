//
//  GFTextImageButton.h
//  APPBase
//  自定义图文按钮
//  Created by 峰 on 2019/10/10.
//  Copyright © 2019 North_feng. All rights reserved.
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

//https://github.com/mushao1990/UIButtonAdjust
//- (void) ddddd {
//    CGFloat space = 5;// 图片和文字的间距
//    NSString *titleString = [NSString stringWithFormat:@"我是测试我是测"];
//    CGFloat titleWidth = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
//    UIImage *btnImage = [UIImage imageNamed:@"home_s"];// 11*6
//    CGFloat imageWidth = btnImage.size.width;
//
//    CGFloat btnWidth = 200;// 按钮的宽度
//    if (titleWidth > btnWidth - imageWidth - space) {
//        titleWidth = btnWidth- imageWidth - space;
//    }
//
//    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, btnWidth, 40)];
//    testButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [testButton setBackgroundColor:[UIColor greenColor]];
//    [testButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [testButton setTitle:titleString forState:UIControlStateNormal];
//    [testButton setImage:btnImage forState:UIControlStateNormal];
//    [self.view addSubview:testButton];
//
//
//    //默认 图片在左，文字在右   添加间距
//    //[testButton setTitleEdgeInsets:UIEdgeInsetsMake(0, (space*0.5), 0, -(space*0.5))];
//    //[testButton setImageEdgeInsets:UIEdgeInsetsMake(0, -(space*0.5), 0, (space*0.5))];
//
//    /**
//     那么，想实现文字在左，图片在右，就需要文字向左边调整，图片向右边调整
//      1.按钮文字向左边调整，就需要按钮文字左边扩展，右边收缩   按钮文字向左边扩展，即left方向需要扩展图片的宽度+间距*0.5； 按钮文字向右边需要收缩，即right方向需要收缩图片的宽度+间距*0.5；
//      2.按钮图片向右边调整，就需要按钮图片右边扩展，左边收缩   按钮图片向右边扩展，即right方向需要扩展文字的宽度+间距*0.5； 按钮图片向左边收缩，即left方向需要搜索文字的宽度+间距*0.5
//
//      PS:扩展就是设置负值。收缩就是设置正值
//     */
//
//    //文字在左，图片在右
//    //[testButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageWidth + space*0.5), 0, (imageWidth + space*0.5))];
//    //[testButton setImageEdgeInsets:UIEdgeInsetsMake(0, (titleWidth + space*0.5), 0, -(titleWidth + space*0.5))];
//
//
//
//
//    /*
//     需要先获取图片和文字的高度**
//     CGFloat    imageHeight = btnImage.size.height;
//     CGFloat    titleHeight = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].height;
//
//      如果要实现上下,比如图片在上，文字在下：
//
//      图片上移：顶部向上扩展，底部收缩 因为本身就是垂直居中的，所以移动的距离是：imageHeight*0.5 + space*0.5
//      文字下移：顶部收缩，底部扩展 移动距离是：titleHeight*0.5 + space*0.5;
//
//      这样做还不够，因为默认图片在左，文字在右。所以还要想办法让他们左右居中：
//      1.图片左边收缩，右边扩展 移动的距离是：(titleWidth+imageWidth)*0.5-imageWidth*0.5 即 titleWidth*0.5;
//      2.文字左边扩展，右边收缩 移动的距离是：(titleWidth+imageWidth)*0.5-titleWidth*0.5 即 imageWidth*0.5;
//     */
//    CGFloat imageHeight = btnImage.size.height;
//    CGFloat titleHeight = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].height;
//    [testButton setImageEdgeInsets:UIEdgeInsetsMake(-(imageHeight*0.5 + space*0.5), titleWidth*0.5, imageHeight*0.5 + space*0.5, -titleWidth*0.5)];
//    [testButton setTitleEdgeInsets:UIEdgeInsetsMake(titleHeight*0.5 + space*0.5, -imageWidth*0.5, -(titleHeight*0.5 + space*0.5), imageWidth*0.5)];
//}
