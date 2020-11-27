//
//  GFNavigationBarView.h
//  GFAPP
//
//  Created by XinKun on 2017/11/13.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//导航条按钮协议
@protocol GFNavigationBarViewDelegate <NSObject>

- (void)leftFirstButtonClick;
- (void)rightFirstButtonClick;
- (void)rightSecondButtonClick;


@end


@interface GFNavigationBarView : UIView

///导航条代理
@property (nonatomic,weak) id <GFNavigationBarViewDelegate> delegate;

///导航条标题
@property (nonatomic, copy) NSString *title; //导航栏标题

/** 导航栏标题(暴露出来) */
@property (nonatomic, strong) UILabel *titleLabel;

#pragma mark - 专为iPhone X设置的方法
///设置按钮条背景颜色
- (void)setItemsBtnBarColor:(UIColor *)btnBarColor;

///设置分割线颜色
- (void)setSegmentationLineColor:(UIColor *)SegmentationColor;

///显示导航条分割线
- (void)showSegmentationLine:(BOOL)show;


#pragma mark - 常规设置按钮
///设置左侧第一个按钮为返回按钮
- (void)setLeftFirstButtonWithImageName:(NSString *)imageName;

///设置左侧第一个按钮显示文字
- (void)setLeftFirstButtonWithTitleName:(NSString *)titleName;

///设置右侧第一个按钮显示图片
- (void)setRightFirstButtonWithImageName:(NSString *)imageName;

///设置右侧第一个按钮显示文字
- (void)setRightFirstButtonWithTitleName:(NSString *)titleName;

///设置右侧第二个按钮显示图片
- (void)setRightSecondButtonWithImageName:(NSString *)imageName;

///设置右侧第二个按钮显示文字
- (void)setRightSecondButtonWithTitleName:(NSString *)titleName;




@end


@interface APPUINavigationBar : UINavigationBar

- (void)makeBackgroundClearWithColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
