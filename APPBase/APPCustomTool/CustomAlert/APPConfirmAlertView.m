//
//  APPConfirmAlertView.m
//  APPBase
//
//  Created by 峰 on 2019/10/11.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPConfirmAlertView.h"

@implementation APPConfirmAlertView

{
    UIView *_backView;
    
    UILabel *_titleLabel;//标题
    
    UILabel *_brifLabel;//描述
    
    UITextField *_textField;//输入框
    
    NSInteger _type;
}

#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBtnCancle)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


//创建视图
- (void)createViewWithType:(NSInteger)type {
    
    _backView = [[UIView alloc] init];
    _backView.frame = CGRectMake(48*kScaleW, -187*kScaleW, kScreenWidth - 48*kScaleW*2, (kScreenWidth - 48*kScaleW*(187./200.)));
    _backView.layer.cornerRadius = 5;
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"";
    _titleLabel.font = [UIFont fontWithName:kMediumFont size:18];
    _titleLabel.textColor = COLOR(@"222222");
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_titleLabel];
    
    if (type == 0) {
        //确定弹框
        _brifLabel = [[UILabel alloc] init];
        _brifLabel.text = @"";
        _brifLabel.font = [UIFont fontWithName:kRegularFont size:15];
        _brifLabel.textColor = COLOR(@"#888888");
        _brifLabel.textAlignment = NSTextAlignmentCenter;
        _brifLabel.numberOfLines = 2;
        [_backView addSubview:_brifLabel];
    }else{
        //输入框弹框
        _textField = [[UITextField alloc] init];
        _textField.layer.borderWidth = 1;
        _textField.layer.borderColor = COLOR(@"#9C9C9C").CGColor;
        _textField.layer.cornerRadius = 5;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.placeholder = @"";
        _textField.font = kFontOfSystem(15);
        _textField.textColor = COLOR(@"666666");
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.delegate = self;
        [_backView addSubview:_textField];
    }
    
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.backgroundColor = COLOR(@"#EDEDED");
    cancleBtn.layer.cornerRadius = 5;
    [cancleBtn gf_addTitle:@"取消" textFont:kFontOfSystem(18) textColor:COLOR(@"666666") forState:UIControlStateNormal];
    [_backView addSubview:cancleBtn];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.backgroundColor = COLOR(@"#34A7FF");
    okBtn.layer.cornerRadius = 5;
    [okBtn gf_addTitle:@"确定" textFont:kFontOfSystem(18) textColor:COLOR(@"FFFFFF") forState:UIControlStateNormal];
    [_backView addSubview:okBtn];
    
    //约束布局
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_backView).offset(15*kScaleW);
        make.right.equalTo(self->_backView).offset(-15*kScaleW);
        make.top.equalTo(self->_backView).offset(25*kScaleW);
        make.height.mas_equalTo(25*kScaleW);
    }];
    
    if (type == 0) {
        [_brifLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self->_titleLabel);
            make.top.equalTo(self->_titleLabel.mas_bottom).offset(20*kScaleW);
        }];
    }else{
        //输入框
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_titleLabel.mas_bottom).offset(20*kScaleW);
            make.left.equalTo(self->_backView).offset(27*kScaleW);
            make.right.equalTo(self->_backView).offset(-27*kScaleW);
            make.height.mas_equalTo(35*kScaleW);
        }];
    }
    
    CGFloat btnWidth = (kScreenWidth - kScaleW*(48 * 2) - kScaleW*(15 * 3)) / 2.;
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_backView).offset(15*kScaleW);
        make.bottom.equalTo(self->_backView).offset(-15*kScaleW);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(40*kScaleW);
    }];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_backView).offset(-15*kScaleW);
        make.bottom.equalTo(self->_backView).offset(-15*kScaleW);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(40*kScaleW);
    }];
    
    [cancleBtn addTarget:self action:@selector(onClickBtnCancle) forControlEvents:UIControlEventTouchUpInside];
    [okBtn addTarget:self action:@selector(onClickBtnOk) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - TextField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_textField resignFirstResponder];
    
    return YES;
}

#pragma mark - 业务处理

///取消
- (void)onClickBtnCancle {
    self.hidden = YES;
    if (self.blockResult) {
        self.blockResult(NO, @0);
    }
    [self removeFromSuperview];
//    [UIView animateWithDuration:0.2 animations:^{
//        self->_backView.frame = CGRectMake(48, ScreenHeight, ScreenWidth - 48*2, (ScreenWidth - 48*2)*(187/280.));
//    } completion:^(BOOL finished) {
//        self.hidden = YES;
//        if (self.blockResult) {
//            self.blockResult(NO, @0);
//        }
//        [self removeFromSuperview];
//    }];
}

///确定
- (void)onClickBtnOk {
    if (self->_textField.text.length > 10) {
        if (_type == 1) {
            [APPAlertTool showMessage:@"学生备注不能超过10个字"];
        } else if (_type == 2) {
            [APPAlertTool showMessage:@"班级备注不能超过10个字"];
        }
        return;
    }
    if (_type != 0) {
        NSString * regex = @"^[A-Za-z0-9\u4e00-\u9fa5]{1,10}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:_textField.text];
        if (!isMatch) {
            [APPAlertTool showMessage:@"姓名只能包含中英文、数字"];
            return;
        }
    }
    if (self.blockResult) {
        if (self->_type == 0) {
            self.blockResult(YES, @0);
        }else{
            self.blockResult(YES, self->_textField.text);
        }
    }
    self.hidden = YES;
    [self removeFromSuperview];
//    [UIView animateWithDuration:0.2 animations:^{
//        self->_backView.frame = CGRectMake(48, ScreenHeight, ScreenWidth - 48*2, (ScreenWidth - 48*2)*(187/280.));
//    } completion:^(BOOL finished) {
//        self.hidden = YES;
//        if (self.blockResult) {
//            if (self->_type == 0) {
//                self.blockResult(YES, @0);
//            }else{
//                self.blockResult(YES, self->_textField.text);
//            }
//        }
//        [self removeFromSuperview];
//    }];
}


///展示确定view
+ (void)showAlertOnView:(UIView *)onView title:(NSString *)title brifString:(NSString *)brifStr type:(NSInteger)type block:(APPBackBlock)blockResult {
    
    APPConfirmAlertView *alertView = [[APPConfirmAlertView alloc] init];
    alertView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [onView addSubview:alertView];
    [onView bringSubviewToFront:alertView];
    
    alertView.blockResult = blockResult;
    
    [alertView createViewWithType:type];//创建无输入视图
    [alertView showAlertWithTitle:title brifString:brifStr type:type];
}

///展示view
- (void)showAlertWithTitle:(NSString *)title brifString:(NSString *)brifStr type:(NSInteger)type {
    
    _type = type;
    
    _titleLabel.text = title;
    
    if (type == 0) {
        _brifLabel.text = brifStr;
    }else{
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:brifStr];
        [attr addAttributes:@{NSForegroundColorAttributeName:COLOR(@"#9C9C9C")} range:NSMakeRange(0, brifStr.length)];
        _textField.attributedPlaceholder = attr;
    }
    self->_backView.frame = CGRectMake(48, 224*kScaleH, kScreenWidth - 48*2, (kScreenWidth - 48*2)*(187/280.));
//    [UIView animateWithDuration:0.2 animations:^{
//        self->_backView.frame = CGRectMake(48, 224*kScaleH, ScreenWidth - 48*2, (ScreenWidth - 48*2)*(187/280.));
//    }];
}


///展示确定view
+ (void)showAlertOnView:(UIView *)onView title:(NSString *)title brifString:(NSString *)brifStr rightText:(NSString *)rightText type:(NSInteger)type block:(APPBackBlock)blockResult {
    
    APPConfirmAlertView *alertView = [[APPConfirmAlertView alloc] init];
    alertView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [onView addSubview:alertView];
    [onView bringSubviewToFront:alertView];
    
    alertView.blockResult = blockResult;
    
    [alertView createViewWithType:type];//创建无输入视图
    [alertView showAlertWithTitle:title brifString:brifStr rightText:rightText type:type];
}

///展示view
- (void)showAlertWithTitle:(NSString *)title brifString:(NSString *)brifStr rightText:(NSString *)rightText type:(NSInteger)type {
    
    _type = type;
    
    _titleLabel.text = title;
    
    if (type == 0) {
        _brifLabel.text = brifStr;
    }else{
        _textField.text = rightText;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:brifStr];
        [attr addAttributes:@{NSForegroundColorAttributeName:COLOR(@"#9C9C9C")} range:NSMakeRange(0, brifStr.length)];
        _textField.attributedPlaceholder = attr;
    }
    self->_backView.frame = CGRectMake(48, 224*kScaleH, kScreenWidth - 48*2, (kScreenWidth - 48*2)*(187/280.));
//    [UIView animateWithDuration:0.2 animations:^{
//        self->_backView.frame = CGRectMake(48, 224*kScaleH, ScreenWidth - 48*2, (ScreenWidth - 48*2)*(187/280.));
//    }];
}

@end
