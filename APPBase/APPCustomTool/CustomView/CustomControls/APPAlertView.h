//
//  APPAlertView.h
//  FlashRider
//  APP内提示弹框
//  Created by gaoyafeng on 2018/11/26.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPAlertView : UIView

@property (nonatomic,strong) UIView *backView;


///样式一（默认标题和按钮演示）
- (void)showAlertWithTitle:(NSString *)title withBlock:(APPBackBlock)block;


///隐藏
- (void)hideAlert;


///样式二（自定义标题）
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif withBlock:(APPBackBlock)block;

///样式三（自定义标题，按钮显示）
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif leftBtnTitle:(NSString *)cancleTitle rightBtnTitle:(NSString *)okTitle withBlock:(APPBackBlock)block;



@end

NS_ASSUME_NONNULL_END
