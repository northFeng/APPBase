//
//  APPConfirmAlertView.h
//  APPBase
//  自定义提示弹框
//  Created by 峰 on 2019/10/11.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPConfirmAlertView : UIView <UITextFieldDelegate>

@property (nonatomic,copy) APPBackBlock blockResult;


/**
 弹出弹框

 @param onView 弹窗的父视图
 @param title 标题
 @param brifStr 描述
 @param type 0:带描述  1:修改学生备注 2:修改班级备注
 @param blockResult 回调
 */
+ (void)showAlertOnView:(UIView *)onView title:(NSString *)title brifString:(NSString *)brifStr type:(NSInteger)type block:(APPBackBlock)blockResult;

/// 弹出弹框
/// @param onView 弹窗的父视图
/// @param title 标题
/// @param brifStr 占位文字 （与输入框文本2选一）
/// @param rightText 输入宽文本
/// @param type 0:带描述  1:修改学生备注 2:修改班级备注
/// @param blockResult 回调
+ (void)showAlertOnView:(UIView *)onView title:(NSString *)title brifString:(NSString *)brifStr rightText:(NSString *)rightText type:(NSInteger)type block:(APPBackBlock)blockResult;

@end

NS_ASSUME_NONNULL_END
