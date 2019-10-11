//
//  APPLoadWaitView.h
//  FlashRider
//  APP加载等待菊花
//  Created by gaoyafeng on 2018/11/26.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPLoadWaitView : UIView


/// 显示加载loading
/// @param view 显示在某个view上
/// @param loadTitle 提示文字
+ (APPLoadWaitView *)showLoadingAddedTo:(UIView *)view loadTitle:(NSString *)loadTitle;

/// 隐藏加载loading
/// @param view 从view上移除
/// @param endTitle 移除前显示文字
+ (BOOL)hideLoadingForView:(UIView *)view endTitle:(NSString *)endTitle;


@end

NS_ASSUME_NONNULL_END
