//
//  APPNoDataView.m
//  APPBase
//
//  Created by 峰 on 2019/10/12.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPNoDataView.h"

@implementation APPNoDataView
{
    UIImageView *_imgView;//占位图
    UILabel *_brifLabel;//无数据说明
    UIButton *_actionBtn;//操作按钮
}

#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if (self = [super init]) {
        
        self.backgroundColor = COLOR(@"#FFFFFF");
        [self createView];
    }
    return self;
}


//创建视图
- (void)createView{
    
    _imgView = [[UIImageView alloc] init];
    [self addSubview:_imgView];

    _brifLabel = [[UILabel alloc] init];
    _brifLabel.textAlignment = NSTextAlignmentCenter;
    _brifLabel.font = kFontOfSystem(14);
    _brifLabel.textColor = COLOR(@"#999999");
    _brifLabel.text = @"";
    [self addSubview:_brifLabel];
    
    _actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionBtn.adjustsImageWhenHighlighted = NO;
    [_actionBtn setTitle:@"" forState:UIControlStateNormal];
    [_actionBtn setTitleColor:COLOR(@"#444444") forState:UIControlStateNormal];
    _actionBtn.titleLabel.font = kFontOfCustom(kSemiboldFont, 18);
    [_actionBtn setBackgroundColor:COLOR(@"#FFD800")];
    _actionBtn.layer.cornerRadius = 24.;
    [self addSubview:_actionBtn];
    
    //约束布局
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(117.*kScaleH);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    
    [_brifLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self->_imgView.mas_bottom).offset(31*kScaleH);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(22);
    }];
    
    [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self->_brifLabel.mas_bottom).offset(79*kScaleH);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(47);
    }];
    
    _imgView.hidden = YES;
    _brifLabel.hidden = YES;
    _actionBtn.hidden = YES;
}

#pragma mark - 业务处理

/**
 *  @brief 创建无数据占位图
 *
 *  @param imgName 占位图name
 *  @param brifText 无数据描述
 *  @param btnTitle 按钮name
 *  @param topSpare 占位图空闲距离
 *
 *  @return ESNoDataView实例
 */
+ (APPNoDataView *)createNodateViewWithImgName:(NSString *)imgName brifText:(NSString *)brifText btnTitle:(NSString *)btnTitle topSpare:(CGFloat)topSpare {
    
    APPNoDataView *nodataView = [[APPNoDataView alloc] init];
    
    [nodataView setImgName:imgName brifText:brifText btnTitle:btnTitle topSpare:topSpare];
    
    return nodataView;
}


///赋值数据
- (void)setImgName:(NSString *)imgName brifText:(NSString *)brifText btnTitle:(NSString *)btnTitle topSpare:(CGFloat)topSpare {
    
    if (imgName.length) {
        _imgView.hidden = NO;
        UIImage *image = [UIImage imageNamed:imgName];
        _imgView.image = image;
        [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(image.size.width);
            make.height.mas_equalTo(image.size.height);
            make.top.equalTo(self).offset(topSpare*kScaleH);
        }];
    }
    
    if (brifText.length) {
        _brifLabel.text = brifText;
        _brifLabel.hidden = NO;
    }
    
    if (btnTitle.length) {
        [_actionBtn setTitle:btnTitle forState:UIControlStateNormal];
        _actionBtn.hidden = NO;
        CGFloat btnWidth = [btnTitle string_getTextWidthWithTextFont:kFontOfCustom(kSemiboldFont, 18) lineSpacing:0 textHeight:25];
        [_actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(btnWidth + 47*2);
        }];
    }
}

- (RACSignal *)btnSignal{
    if (!_btnSignal) {
        _btnSignal = [_actionBtn rac_signalForControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSignal;
}

@end
