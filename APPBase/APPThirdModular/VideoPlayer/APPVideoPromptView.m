//
//  APPVideoPromptView.m
//  CleverBaby
//
//  Created by 峰 on 2020/2/7.
//  Copyright © 2020 小神童. All rights reserved.
//

#import "APPVideoPromptView.h"

@implementation APPVideoPromptView

#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if (self = [super init]) {
        [self createView];
    }
    return self;
}


//创建视图
- (void)createView{
    
    self.backgroundColor = [COLOR(@"#000000") colorWithAlphaComponent:0.8];
    
    UIImageView *leftImg = [APPViewTool view_createImageViewWithImageName:@"video_ld"];
    [self addSubview:leftImg];
    
    UIImageView *rightImg = [APPViewTool view_createImageViewWithImageName:@"video_sy"];
    [self addSubview:rightImg];
    
    //约束布局
    leftImg.sd_layout.centerYEqualToView(self).leftSpaceToView(self, FitIpad(105)).widthIs(127).heightIs(141);
    rightImg.sd_layout.centerYEqualToView(self).rightSpaceToView(self, FitIpad(105)).widthIs(127).heightIs(141);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //[APPCache setDataVideoBrightVolume];//存储数据
    
    self.hidden = YES;
    [self removeFromSuperview];
}

+ (APPVideoPromptView *)showAlertFromView:(UIView *)onView {
    
    //![APPCache getDataVideoBrightVolume]
    if (1) {
        
        APPVideoPromptView *alertView = [[APPVideoPromptView alloc] init];
        [onView addSubview:alertView];
        alertView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        return alertView;
    }
    return nil;
}


@end
