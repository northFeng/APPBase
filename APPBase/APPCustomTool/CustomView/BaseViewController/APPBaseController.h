//
//  APPBaseController.h
//  APPBase
//  APP内基类VC
//  Created by 峰 on 2019/10/10.
//  Copyright © 2019 ishansong. All rights reserved.
//  (可以不继承，但最好集成自定义导航条)

#import <UIKit/UIKit.h>

//导航条
#import "GFNavigationBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface APPBaseController : UIViewController <GFNavigationBarViewDelegate>

///导航条
@property (nonatomic, strong,nullable) GFNavigationBarView *naviBar;



#pragma mark - 状态栏设置
/**
 *  @brief 设置状态栏是否隐藏
 *
 */
- (void)setStatusBarIsHide:(BOOL)isHide;

/**
 *  @brief 设置状态栏样式为默认
 *
 */
- (void)setStatusBarStyleDefault;

/**
 *  @brief 设置状态栏样式为白色
 *
 */
- (void)setStatusBarStyleLight;



#pragma mark - 右滑返回手势的 开启  && 禁止
///禁止返回手势
- (void)removeBackGesture;

/**
 * 恢复返回手势
 */
- (void)resumeBackGesture;



#pragma mark - 视图推进封装

/**
 *  @brief 推进视图 && Xib
 *
 *  @param classString VC类的字符串
 *  @param title VC页面标题
 */
- (void)pushViewControllerWithNibClassString:(NSString *)classString pageTitle:(NSString *)title;

/**
 *  @brief 推进视图 && 无Xib
 *
 *  @param classString VC类的字符串
 *  @param title VC页面标题
 */
- (void)pushViewControllerWithClassString:(NSString *)classString pageTitle:(NSString *)title;

#pragma mark - 弹出模态视图

///弹出模态视图
- (void)presentViewController:(UIViewController *)presentVC;

/**
 *  @brief 弹出模态视图
 *
 *  @param presentVC VC视图
 *  @param presentStyle 弹出动画风格
 *  @param completion 动画执行完毕回调
 */
- (void)presentViewController:(UIViewController *)presentVC presentStyle:(UIModalTransitionStyle)presentStyle completionBlock:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
