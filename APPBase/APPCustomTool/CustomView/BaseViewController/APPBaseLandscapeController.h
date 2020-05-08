//
//  APPBaseLandscapeController.h
//  APPBase
//  横屏baseVC
//  Created by 峰 on 2020/4/2.
//  Copyright © 2020 ishansong. All rights reserved.
//  备注：如果屏幕 方向按钮打开状态，竖屏页面 +【手机横屏放置时】 进入 横屏页面 ——> 则 进入 横屏页面不会横屏！！在 进入 横屏前 进行 【代码竖屏】  执行一次！！[APPManagerObject setScreenInterfaceOrientationDefault];//设置竖屏

/**
 优酷视频 横竖屏控制解决： APP内所有页面都是 竖屏，VC中代理只返回竖屏值，在需要横屏的地方 则设置 APP代理中 可以旋转三个方向！在横屏的地方，进行 需要横屏的视频页面进行旋转 90度！！
  监听 APP旋转——> APP旋转则更改 播放界面 旋转！！（其他不需要横屏的界面，APP代理中任然 只返回竖屏值！！）
 */

#import "APPBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface APPBaseLandscapeController : APPBaseController

///状态栏高度 (通过外部传进来，状态栏隐藏获取不到)
@property (nonatomic,assign) CGFloat stateHeight;

///返回按钮 (默认 hidden = YES)
@property (nonatomic,strong) UIButton *backBtn;

///设置状态栏样式
- (void)setNaviBarStyle;

///设置 横屏模式
- (void)setLandscapeModel;

///设置竖屏模式
- (void)setVerticalScreenModel;

///左侧第一个按钮
- (void)leftFirstButtonClick;

///强制退出横屏
- (void)exitLandscape;

///添加背景图
- (UIImageView *)addBgImgviewWithImgName:(NSString *)imgName;

@end

NS_ASSUME_NONNULL_END
