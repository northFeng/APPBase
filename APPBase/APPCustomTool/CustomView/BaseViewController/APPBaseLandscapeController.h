//
//  APPBaseLandscapeController.h
//  APPBase
//  横屏baseVC
//  Created by 峰 on 2020/4/2.
//  Copyright © 2020 ishansong. All rights reserved.
//

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


@end

NS_ASSUME_NONNULL_END
