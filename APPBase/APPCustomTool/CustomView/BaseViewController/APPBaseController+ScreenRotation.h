//
//  APPBaseController+ScreenRotation.h
//  CleverBaby
//  屏幕旋转分类
//  Created by 峰 on 2019/11/5.
//  Copyright © 2019 小神童. All rights reserved.
//


#import "APPBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface APPBaseController (ScreenRotation)


///屏蔽旋转的VC必须设置 该属性 YES，VC消失时必须设置为NO
@property (nonatomic,assign) BOOL allowScreenRotate;

///控制APP屏幕旋转方向 (默认UIInterfaceOrientationMaskPortrait 竖直方向)（APP与VC的方向最后必须一致，VC在退出时，必须恢复原样）
@property (nonatomic,assign) UIInterfaceOrientationMask APPOrientat;


#pragma mark - ************************* 代码强制控制屏幕方向(用在锁屏时) *************************
//设置屏幕向左翻转
- (void)setScreenInterfaceOrientationLeft;


//设置屏幕向右翻转
- (void)setScreenInterfaceOrientationRight;


//设置屏幕竖屏（默认）
- (void)setScreenInterfaceOrientationDefault;



@end

NS_ASSUME_NONNULL_END

/**
 用法
 - (void)setNaviBarStyle{
     //self.naviBar.hidden = YES;
     
     [self removeBackGesture];//1>移除返回手势
     self.allowScreenRotate = YES;// 2> 设置该VC可旋转
     self.APPOrientat = UIInterfaceOrientationMaskLandscapeRight;// 3>横屏
     //[self setStatusBarIsHide:YES];//隐藏状态栏
     
     [self setScreenInterfaceOrientationRight];// 5> 强制屏幕横屏
 }
 
 ///左侧第一个按钮
 - (void)leftFirstButtonClick{
     
     //默认这个为返回按钮
     [self resumeBackGesture];// 1>回复返回手势
     
     [self.navigationController popViewControllerAnimated:YES];//2> 必须第二个，如果先返回，则该视频已经死亡，则返回手势恢复不了
     
     self.APPOrientat = UIInterfaceOrientationMaskAllButUpsideDown;// 3> 三个方向   -> 控制VC进行选择方向
     [self setScreenInterfaceOrientationDefault];// 4> 恢复竖屏 —>控制VC 旋转竖屏
     
     self.allowScreenRotate = NO;//设置VC不可旋转
 }
 
 - (void)bindViewModel{
     
     [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
         [self setScreenInterfaceOrientationRight];//屏幕横屏
     }];
     
 }
 */
