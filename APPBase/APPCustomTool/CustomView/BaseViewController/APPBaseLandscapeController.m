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
{
    UIInterfaceOrientationMask _orientation;//方向
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _orientation = UIInterfaceOrientationMaskLandscapeRight;//横屏方向

    //这不必须写上，APP回到桌面 再进来，系统屏幕方向已变，返回时，底层的VC方向其实已经改变！！ 所以在这里我们 就监听APP进入活跃状态 就 使 设备的方向 横屏过来 ——> 当前VC的 之前的VC方向就旋转了
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self setScreenInterfaceOrientationRight];//横屏
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation != UIInterfaceOrientationMaskLandscapeRight) {
        //不是横屏 ——> 横屏
        [self setLandscapeModel];
    }
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _backBtn.backgroundColor = UIColor.redColor;
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
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
    
    [self setLandscapeModel];//横屏模式
}

///设置 横屏模式
- (void)setLandscapeModel {
    
    [self removeBackGesture];//移除返回手势
    
    _orientation = UIInterfaceOrientationMaskLandscapeRight;//横屏
    self.allowScreenRotate = YES;//设置该VC可旋转
    self.APPOrientat = UIInterfaceOrientationMaskLandscapeRight;//横屏
    [self setStatusBarIsHide:YES];//隐藏状态栏
    
    [self setScreenInterfaceOrientationRight];//屏幕横屏
}

///设置竖屏模式
- (void)setVerticalScreenModel {
        
    _orientation = UIInterfaceOrientationMaskPortrait;//竖屏
    
    self.APPOrientat = UIInterfaceOrientationMaskAllButUpsideDown;//三个方向
    [self setScreenInterfaceOrientationDefault];//恢复竖屏
    
    self.allowScreenRotate = NO;//设置该VC可旋转
}

///VC支持的旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return _orientation;//向右横屏
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

///强制退出横屏
- (void)exitLandscape {
    
    //默认这个为返回按钮
    [self resumeBackGesture];//回复返回手势
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    self.APPOrientat = UIInterfaceOrientationMaskAllButUpsideDown;//三个方向
    [self setScreenInterfaceOrientationDefault];//恢复竖屏
    
    self.allowScreenRotate = NO;//设置该VC可旋转
}

///添加背景图
- (UIImageView *)addBgImgviewWithImgName:(NSString *)imgName {
    //背景图
    UIImageView *bgImgview = [APPViewTool view_createImageViewWithImageName:imgName];
    [self.view addSubview:bgImgview];
    CGSize sizeBg = bgImgview.image.size;
    if (kIsiPhone) {
       bgImgview.sd_layout.leftEqualToView(self.view).bottomEqualToView(self.view).rightEqualToView(self.view).heightIs(kScreenWidth * (sizeBg.height / sizeBg.width));
    }else{
        bgImgview.sd_layout.topEqualToView(self.view).bottomEqualToView(self.view).centerXEqualToView(self.view).widthIs(kScreenHeight * (sizeBg.width / sizeBg.height));
    }
    return bgImgview;
}


@end
