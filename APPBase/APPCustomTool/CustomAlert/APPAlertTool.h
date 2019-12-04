//
//  APPAlertTool.h
//  APPBase
//
//  Created by 峰 on 2019/10/11.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPAlertTool : NSObject

#pragma mark - MBProgressHUD ——> 吐字 && loadingView
///获取APP内最顶层的VC
+ (UIViewController *)topViewControllerOfAPP;

///弹出文字提示
+ (void)showMessage:(NSString *)message;

///展示文字到某个视图上
+ (void)showMessage:(NSString *)message onView:(UIView *)view;

///显示菊花等待
+ (void)showLoading;

///显示菊花（是否可以手势交互）
+ (void)showLoadingForInterEnabled:(BOOL)enable;

///隐藏菊花等待
+ (void)hideLoading;


#pragma mark - 自定义 ——> loadingView

///显示自定义loading
+ (void)showCustomLoading;

///隐藏自定义loading
+ (void)hideCustomLoading;

///显示自定义loading && 开始文字
+ (void)showCustomLoadingWithTitle:(NSString *)title;

///结束自定义loading && 结束文字
+ (void)hideCustomLoadingWithTitle:(NSString *)title;



#pragma mark - 自定义消息确认弹框
/**
 *  @brief 自定义消息框 && 确定按钮执行事件
 *
 *  @param message 消息
 *  @param block 执行按钮事件block
 */
+ (void)showAlertCustomMessage:(NSString *)message okBlock:(APPBackBlock)block;

/**
 *  @brief 自定义弹框——>自定义标题
 *
 *  @param title 标题
 *  @param message 消息
 *  @param block 执行按钮事件block
 */
+ (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message okBlock:(APPBackBlock)block;

/**
 *  @brief 自定义弹框——>自定义标题——>自定义按钮文字
 *
 *  @param title 标题
 *  @param message 消息
 *  @param cancleTitle 取消按钮标题
 *  @param okTitle 确定按钮标题
 *  @param block 执行按钮事件block
 */
+ (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message cancleBtnTitle:(NSString *)cancleTitle okBtnTitle:(NSString *)okTitle okBlock:(APPBackBlock)block;

/**
 *  @brief 自定义弹框——>自定义标题——>自定义按钮文字 ——>左右按钮事件
 *
 *  @param title 标题
 *  @param message 消息
 *  @param cancleTitle 取消按钮标题
 *  @param okTitle 确定按钮标题
 *  @param blockLeft 执行左按钮事件block
 *  @param blockRight 执行右按钮事件block
 */
+ (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message cancleBtnTitle:(NSString *)cancleTitle okBtnTitle:(NSString *)okTitle leftBlock:(APPBackBlock)blockLeft rightBlock:(APPBackBlock)blockRight;

/**
 *  @brief 消息提示框
 *
 *  @param message 消息默认显示在Window视图上，全APP内显示位置一样（多个控制提示可能会重叠）
 *
 */
+ (void)showAlertMessage:(NSString *)message title:(NSString *)title;

/**
 *  @brief 消息提示框 && 带一个按钮执行事件
 *
 *  @param message 消息
 *  @param title 消息框标题
 *  @param btnTitle 按钮标题
 *  @param block 执行按钮事件block
 */
+ (void)showAlertMessage:(NSString *)message title:(NSString *)title btnTitle:(NSString *)btnTitle block:(APPBackBlock)block;

/**
 *  @brief 消息提示框 && 带两个按钮执行事件
 *
 *  @param message 消息
 *  @param title 消息框标题
 *  @param leftTitle 左边按钮标题
 *  @param leftBlock 执行左边按钮事件block
 *  @param rightTitle 右边按钮标题
 *  @param rightBlock 执行右边按钮事件block
 */
+ (void)showAlertMessage:(NSString *)message title:(NSString *)title btnLeftTitle:(NSString *)leftTitle leftBlock:(APPBackBlock)leftBlock btnRightTitle:(NSString *)rightTitle rightBlock:(APPBackBlock)rightBlock;


@end

NS_ASSUME_NONNULL_END
