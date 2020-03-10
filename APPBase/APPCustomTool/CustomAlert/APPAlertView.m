//
//  APPAlertView.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/26.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "APPAlertView.h"

@implementation APPAlertView

{
    
    UILabel *_labelTitle;
    
    UILabel *_labelBrif;
    
    UIButton *_btnCancle;
    
    UIButton *_btnOk;
    
    UIView *_lineS;//竖线
    
    APPBackBlock _blockLeft;
    
    APPBackBlock _blockRight;
    
}

#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if ([super init]) {
        
        self.backgroundColor = [COLOR(@"#222F3A") colorWithAlphaComponent:0.72];
        [self createView];
    }
    return self;
}


//创建视图
- (void)createView{
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 285*kIpadScale)/2., kScreenHeight*0.35, 285*kIpadScale, 285*kIpadScale*(176./285.))];
    _backView.backgroundColor = DynamicColor(APPColorFunction.whiteColor, APPColorFunction.blackAlertColor);
    _backView.layer.cornerRadius = 16;
    _backView.alpha = 0.;
    [self addSubview:_backView];
    
    _labelTitle = [[UILabel alloc] init];
    _labelTitle.tintColor = DynamicColor(APPColorFunction.textBlackColor, APPColorFunction.lightTextColor);
    _labelTitle.font = kFontOfCustom(kMediumFont, 14*kIpadScale);
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.text = @"温馨提示";
    [_backView addSubview:_labelTitle];
    
    _labelBrif = [[UILabel alloc] init];
    _labelBrif.textColor = DynamicColor(APPColorFunction.textBlackColor, APPColorFunction.lightTextColor);
    _labelBrif.font = kFontOfSystem(14*kIpadScale);
    _labelBrif.textAlignment = NSTextAlignmentCenter;
    _labelBrif.numberOfLines = 10;//最大10行文字
    [_labelBrif sizeToFit];
    [_backView addSubview:_labelBrif];
    
    _btnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCancle setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancle setTitleColor:DynamicColor(COLOR(@"#717B99"), APPColorFunction.lightTextColor) forState:UIControlStateNormal];
    _btnCancle.titleLabel.font = kFontOfCustom(kMediumFont, 14*kIpadScale);
    [_backView addSubview:_btnCancle];
    [_btnCancle addTarget:self action:@selector(onClickBtnCancle) forControlEvents:UIControlEventTouchUpInside];
    
    
    _btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnOk setTitle:@"确认" forState:UIControlStateNormal];
    [_btnOk setTitleColor:APPColorFunction.textBlueColor forState:UIControlStateNormal];
    _btnOk.titleLabel.font = kFontOfCustom(kMediumFont, 14*kIpadScale);
    [_backView addSubview:_btnOk];
    [_btnOk addTarget:self action:@selector(onClickBtnOk) forControlEvents:UIControlEventTouchUpInside];
    
    //添加横线
    UIView *lineH = [[UIView alloc] init];
    lineH.backgroundColor = COLOR(@"#E4E4E4");
    [_backView addSubview:lineH];
    
    _lineS = [[UIView alloc] init];
    _lineS.backgroundColor = COLOR(@"#E4E4E4");
    [_backView addSubview:_lineS];
    
    
    //添加约束
    //_labelTitle.sd_layout.leftSpaceToView(_backView, 28).topSpaceToView(_backView, 22).rightSpaceToView(_backView, 28).heightIs(28);
    //_labelBrif.sd_layout.leftSpaceToView(_backView, 35).rightSpaceToView(_backView, 35).topSpaceToView(_labelTitle, 4).heightIs(40);
    [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(15);
        make.right.equalTo(self.backView).offset(-15);
        make.top.equalTo(self.backView).offset(20*kIpadScale);
        make.height.mas_equalTo(20*kIpadScale);
    }];
    [_labelBrif mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(15);
        make.right.equalTo(self.backView).offset(-15);
        make.top.equalTo(self->_labelTitle.mas_bottom).offset(15*kIpadScale);
        //make.height.mas_equalTo(40.);
    }];
    
    lineH.sd_layout.leftEqualToView(_backView).rightEqualToView(_backView).bottomSpaceToView(_backView, 48*kIpadScale).heightIs(0.5);
    _lineS.sd_layout.centerXEqualToView(_backView).topSpaceToView(lineH, 0).bottomEqualToView(_backView).widthIs(0.5);
    _btnCancle.sd_layout.leftEqualToView(_backView).bottomEqualToView(_backView).heightIs(48*kIpadScale).rightSpaceToView(_lineS, 0);
    _btnOk.sd_layout.rightEqualToView(_backView).bottomEqualToView(_backView).heightIs(48*kIpadScale).leftSpaceToView(_lineS, 0);
}



#pragma mark - 点击事件

///取消
- (void)onClickBtnCancle{
    NSLog(@"点击取消");
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.backView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.backView.alpha = 0.;
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        [self removeFromSuperview];//移除
        
        if (self->_blockLeft) {
            self->_blockLeft(YES,nil);
        }
    }];
}

///确定
- (void)onClickBtnOk{
    NSLog(@"点击确定");
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.backView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.backView.alpha = 0.;
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        [self removeFromSuperview];//移除
        
        if (self->_blockRight) {
            self->_blockRight(YES,nil);
        }
    }];
}


#pragma mark - 动画逻辑

///弹出来

///样式一
- (void)showAlertWithMessage:(NSString *)message withBlock:(APPBackBlock)block{
    
    _labelBrif.text = message;
    
    _blockRight = block;
    
    [self showAlert];
}

///样式二
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif withBlock:(APPBackBlock)block{
    
    _labelTitle.text = title;
    
    _labelBrif.text = brif;
    
    _blockRight = block;
    
    [self showAlert];
}

///样式二
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif leftBtnTitle:(NSString *)cancleTitle rightBtnTitle:(NSString *)okTitle withBlock:(APPBackBlock)block{
    
    _labelTitle.text = title;
    
    _labelBrif.text = brif;
    
    [_btnCancle setTitle:cancleTitle forState:UIControlStateNormal];
    
    [_btnOk setTitle:okTitle forState:UIControlStateNormal];
    
    _blockRight = block;
    
    [self showAlert];
}

///样式四
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif leftBtnTitle:(NSString *)cancleTitle rightBtnTitle:(NSString *)okTitle blockleft:(APPBackBlock)blockleft blockRight:(APPBackBlock)blockRight{
    
    _labelTitle.text = title;
    
    _labelBrif.text = brif;
    
    [_btnCancle setTitle:cancleTitle forState:UIControlStateNormal];
    
    [_btnOk setTitle:okTitle forState:UIControlStateNormal];
    
    _blockLeft = blockleft;
    
    _blockRight = blockRight;
    
    [self showAlert];
}

///样式5（只有确定按钮）
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif okBtnTitle:(NSString *)okTitle withOkBlock:(APPBackBlock)okBlock {
    
    _labelTitle.text = title;
    
    _labelBrif.text = brif;
    
    [_btnOk setTitle:okTitle forState:UIControlStateNormal];
    
    _blockRight = okBlock;
    
    _lineS.hidden = YES;
    _btnCancle.hidden = YES;
    _btnOk.sd_resetLayout.leftEqualToView(_backView).rightEqualToView(_backView).bottomEqualToView(_backView).heightIs(48*kIpadScale);
    
    [self showAlert];
}

///样式六  （万能版本）
- (void)showAlert6WithTitle:(NSString *)title brifStr:(NSString *)brifStr leftBtnTitle:(NSString *)cancleTitle rightBtnTitle:(NSString *)okTitle blockleft:(APPBackBlock)blockleft blockRight:(APPBackBlock)blockRight  {
    
    if (title.length) {
        _labelTitle.text = title;
    }else{
        _labelTitle.hidden = YES;
        [_labelTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(0);
            make.height.mas_equalTo(0);
        }];
        [_labelBrif mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_labelTitle.mas_bottom).offset(28*kIpadScale);
            //make.height.mas_equalTo(40.);
        }];
    }
    
    if (brifStr.length) {
        _labelBrif.text = brifStr;
    }
    
    if (cancleTitle.length) {
        [_btnCancle setTitle:cancleTitle forState:UIControlStateNormal];
        _blockLeft = blockleft;
    }else{
        //隐藏左侧按钮
        _lineS.hidden = YES;
        _btnCancle.hidden = YES;
        
        _btnOk.sd_resetLayout.leftEqualToView(_backView).rightEqualToView(_backView).bottomEqualToView(_backView).heightIs(48*kIpadScale);
    }
    
    
    _blockRight = blockRight;
    [_btnOk setTitle:okTitle forState:UIControlStateNormal];
    
    [self showAlert];
}

///样式7  （万能版本2）
- (void)showAlert7WithTitle:(NSAttributedString *)title brifStr:(NSAttributedString *)brifStr leftBtnTitle:(NSAttributedString *)cancleTitle rightBtnTitle:(NSAttributedString *)okTitle blockleft:(APPBackBlock)blockleft blockRight:(APPBackBlock)blockRight {
    
    if (title.length) {
        _labelTitle.attributedText = [APPFunctionMethod string_getAttributeStringWithString:title.string textFont:kFontOfCustom(kMediumFont, FitIpad(14)) textColor:[self getAttrStrColorWithAttrStr:title]];
    }else{
        _labelTitle.hidden = YES;
        [_labelTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(0);
            make.height.mas_equalTo(0);
        }];
        [_labelBrif mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_labelTitle.mas_bottom).offset(28*kIpadScale);
            //make.height.mas_equalTo(40.);
        }];
    }
    
    if (brifStr.length) {
        _labelBrif.attributedText = [APPFunctionMethod string_getAttributeStringWithString:brifStr.string textFont:kFontOfSystem(FitIpad(14)) textColor:[self getAttrStrColorWithAttrStr:brifStr]];;
    }
    
    if (cancleTitle.length) {
        [_btnCancle setTitle:cancleTitle.string forState:UIControlStateNormal];
        [_btnCancle setTitleColor:[self getAttrStrColorWithAttrStr:cancleTitle] forState:UIControlStateNormal];
        _blockLeft = blockleft;
    }else{
        //隐藏左侧按钮
        _lineS.hidden = YES;
        _btnCancle.hidden = YES;
        
        _btnOk.sd_resetLayout.leftEqualToView(_backView).rightEqualToView(_backView).bottomEqualToView(_backView).heightIs(48*kIpadScale);
    }
    
    
    _blockRight = blockRight;
    if (okTitle.length) {
        [_btnOk setTitle:okTitle.string forState:UIControlStateNormal];
        [_btnOk setTitleColor:[self getAttrStrColorWithAttrStr:okTitle] forState:UIControlStateNormal];
    }
    
    [self showAlert];
}

///获取富文本颜色
- (UIColor *)getAttrStrColorWithAttrStr:(NSAttributedString *)attrStr {
    
    NSRange rang = NSMakeRange(0, attrStr.length);
    
    NSDictionary *dicAttr = [attrStr attributesAtIndex:0 effectiveRange:&rang];
    UIColor *textColor = [dicAttr objectForKey:NSForegroundColorAttributeName];
    
    textColor = textColor ? textColor : DynamicColor(APPColorFunction.textBlackColor, APPColorFunction.lightTextColor);
    
    return textColor;
}

///显示处理啊
- (void)showAlert {
    
    CGFloat birfHeight = [_labelBrif.text string_getTextHeightWithTextFont:kFontOfSystem(FitIpad(14)) lineSpacing:2 textWidth:285*kIpadScale - 30];
    
    if (_labelTitle.hidden) {
        _backView.frame = CGRectMake((kScreenWidth - 285*kIpadScale)/2., kScreenHeight*0.35, 285*kIpadScale, FitIpad(118 - 40) + birfHeight);//没有标题，减去标题高度
    }else{
        _backView.frame = CGRectMake((kScreenWidth - 285*kIpadScale)/2., kScreenHeight*0.35, 285*kIpadScale, FitIpad(118) + birfHeight);
    }
    
    _backView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.backView.transform = CGAffineTransformMakeScale(1, 1);
        self.backView.alpha = 1.;
    }];
}



///隐藏
- (void)hideAlert{
    
    WeakSelf(self);
    [UIView animateWithDuration:0.1 animations:^{
        
        self.backView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.backView.alpha = 0.;
        
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];//移除
    }];
}





@end
