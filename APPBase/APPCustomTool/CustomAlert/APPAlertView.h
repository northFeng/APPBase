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
- (void)showAlertWithMessage:(NSString *)message withBlock:(APPBackBlock)block;


///隐藏
- (void)hideAlert;


///样式二（自定义标题）
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif withBlock:(APPBackBlock)block;

///样式三（自定义标题，按钮显示）
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif leftBtnTitle:(NSString *)cancleTitle rightBtnTitle:(NSString *)okTitle withBlock:(APPBackBlock)block;

///样式四(左右按钮事件)
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif leftBtnTitle:(NSString *)cancleTitle rightBtnTitle:(NSString *)okTitle blockleft:(APPBackBlock)blockleft blockRight:(APPBackBlock)blockRight;

///样式5（只有确定按钮）
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif okBtnTitle:(NSString *)okTitle withOkBlock:(APPBackBlock)okBlock;

///样式六  （万能版本）
- (void)showAlert6WithTitle:(NSString *)title brifStr:(NSString *)brifStr leftBtnTitle:(NSString *)cancleTitle rightBtnTitle:(NSString *)okTitle blockleft:(APPBackBlock)blockleft blockRight:(APPBackBlock)blockRight;

///样式7  （万能版本2）
- (void)showAlert7WithTitle:(NSAttributedString *)title brifStr:(NSAttributedString *)brifStr leftBtnTitle:(NSAttributedString *)cancleTitle rightBtnTitle:(NSAttributedString *)okTitle blockleft:(APPBackBlock)blockleft blockRight:(APPBackBlock)blockRight;


@end

NS_ASSUME_NONNULL_END
