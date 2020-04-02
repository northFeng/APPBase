//
//  APPBaseLandscapeController.m
//  APPBase
//
//  Created by 峰 on 2020/4/2.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import "APPBaseLandscapeController.h"

#import "APPBaseController+ScreenRotation.h"//旋转屏幕

@interface APPBaseLandscapeController ()

@end

@implementation APPBaseLandscapeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation != UIInterfaceOrientationMaskLandscapeRight) {
        //不是横屏
        [self setScreenInterfaceOrientationRight];//屏幕横屏
    }
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"back_s"] forState:UIControlStateNormal];
        _backBtn.hidden = YES;
        [_backBtn addTarget:self action:@selector(leftFirstButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
        _backBtn.sd_layout.leftSpaceToView(self.view, FitIpad(_stateHeight)).topSpaceToView(self.view, FitIpad(20)).widthIs(FitIpad(38)).heightIs(FitIpad(38));
    }
    return _backBtn;
}

///设置状态栏样式
- (void)setNaviBarStyle {
    
    self.naviBar.hidden = YES;
    
    [self removeBackGesture];//移除返回手势
    self.allowScreenRotate = YES;//设置该VC可旋转
    self.APPOrientat = UIInterfaceOrientationMaskLandscapeRight;//横屏
    [self setStatusBarIsHide:YES];//隐藏状态栏
    
    [self setScreenInterfaceOrientationRight];//屏幕横屏
}

///VC支持的旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscapeRight;//向右横屏
}


///左侧第一个按钮
- (void)leftFirstButtonClick {
    
    //默认这个为返回按钮
    [self resumeBackGesture];//回复返回手势
    [self.navigationController popViewControllerAnimated:YES];
    
    self.APPOrientat = UIInterfaceOrientationMaskAllButUpsideDown;//三个方向
    [self setScreenInterfaceOrientationDefault];//恢复竖屏
    
    self.allowScreenRotate = NO;//设置该VC可旋转
}

@end
