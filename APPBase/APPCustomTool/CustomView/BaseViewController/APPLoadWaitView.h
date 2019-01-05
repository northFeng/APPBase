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

///销毁定时器
- (void)deallocTimer;

///开启
- (void)startAnimation;

///关闭
- (void)stopAnimation;


///开启 && 显示文字
- (void)startAnimationWithTitle:(NSString *)title;

///关闭 && 显示文字
- (void)stopAnimationWithTitle:(NSString *)title;

///设置显示文字
- (void)setShowLabelText:(NSString *)showStr;

@end

NS_ASSUME_NONNULL_END
