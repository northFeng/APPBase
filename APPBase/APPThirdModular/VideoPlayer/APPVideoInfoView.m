//
//  APPVideoInfoView.m
//  CleverBaby
//
//  Created by 峰 on 2020/2/4.
//  Copyright © 2020 小神童. All rights reserved.
//

#import "APPVideoInfoView.h"

@implementation APPVideoInfoView
{
    UIImageView *_bcImgview;//背景
    
    UIProgressView *_progress;//进度条
}

#pragma mark - 视图布局
//初始化
- (instancetype)initWithBcImg:(NSString *)bcImgName {
    
    if (self = [super init]) {
        
        [self createView:bcImgName];
    }
    return self;
}


//创建视图
- (void)createView:(NSString *)bcImgName {
    
    self.backgroundColor = [COLOR(@"#242C40") colorWithAlphaComponent:0.5];
    self.sd_cornerRadius = @(FitIpad(20));
    
    _bcImgview = [APPViewTool view_createImageViewWithImageName:bcImgName];
    [self addSubview:_bcImgview];
    
    _progress = [[UIProgressView alloc] init];
    _progress.trackTintColor = [UIColor whiteColor];
    _progress.progressTintColor = APPColorFunction.textBlueColor;
    _progress.progress = 0.0;
    // 改变进度条的粗细
    _progress.transform = CGAffineTransformMakeScale(1.0f,3.0f);
    _progress.progressViewStyle = UIProgressViewStyleBar;
    _progress.sd_cornerRadius = @1.5;
    [self addSubview:_progress];
    
    //约束布局
    _bcImgview.sd_layout.centerYEqualToView(self).leftSpaceToView(self, FitIpad(13)).widthIs(16).heightIs(16);
    _progress.sd_layout.centerYEqualToView(self).leftSpaceToView(_bcImgview, FitIpad(10)).rightSpaceToView(self, FitIpad(17)).heightIs(20);
}

#pragma mark - 业务处理
///设置进度
- (void)setValue:(CGFloat)value {
    
    _progress.progress = value;
}

- (CGFloat)value {
    return _progress.progress;
}


@end
