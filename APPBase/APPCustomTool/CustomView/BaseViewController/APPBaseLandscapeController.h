//
//  APPBaseLandscapeController.h
//  APPBase
//  横屏baseVC
//  Created by 峰 on 2020/4/2.
//  Copyright © 2020 ishansong. All rights reserved.
//  备注：如果屏幕 方向按钮打开状态，竖屏页面 +【手机横屏放置时】 进入 横屏页面 ——> 则 进入 横屏页面不会横屏！！在 进入 横屏前 进行 【代码竖屏】  执行一次！！[APPManagerObject setScreenInterfaceOrientationDefault];//设置竖屏

#import "APPBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface APPBaseLandscapeController : APPBaseController

///状态栏高度 (通过外部传进来，状态栏隐藏获取不到)
@property (nonatomic,assign) CGFloat stateHeight;

///返回按钮 (默认 hidden = YES)
@property (nonatomic,strong) UIButton *backBtn;

///设置状态栏样式
- (void)setNaviBarStyle;

///左侧第一个按钮
- (void)leftFirstButtonClick;

///添加背景图
- (UIImageView *)addBgImgviewWithImgName:(NSString *)imgName;

@end

NS_ASSUME_NONNULL_END
