//
//  APPBaseController.m
//  APPBase
//
//  Created by 峰 on 2019/10/10.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPBaseController.h"

@interface APPBaseController ()

@end

@implementation APPBaseController
{
    UIStatusBarStyle _statusStyle;
    BOOL _statusIsHide;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //...配置
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注册登录通知
    [APPNotificationCenter addObserver:self selector:@selector(loginStateChange) name:_kGlobal_LoginStateChange object:nil];
    
    //接收网络状态变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityNetStateChanged:) name:_kGlobal_NetworkingReachabilityChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVCLightOrDarkModel) name:_kGlobal_LightOrDarkModelChange object:nil];
    
    //统一视图背景颜色
    self.view.backgroundColor = DynamicColor([UIColor whiteColor], [UIColor blackColor]);
    
    //设置状态栏状态数据初始状态(默认为黑色，不隐藏)
    _statusStyle = UIStatusBarStyleDefault;
    _statusIsHide = NO;
    
    //创建导航条
    self.naviBar = [[GFNavigationBarView alloc] init];
    self.naviBar.title = self.title;
    self.naviBar.delegate = self;
    [self.view addSubview:self.naviBar];
    //导航条约束
    [self.naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view);
        make.height.mas_equalTo(kTopNaviBarHeight);
    }];
    
    if (self.navigationController.viewControllers.count > 1) {
        // 设置返回按钮
        [self.naviBar setLeftFirstButtonWithImageName:@"back_s2"];
    }
    
    //请求数据
    [self initData];
    
    //设置状态栏样式
    [self setNaviBarStyle];
}

///初始化数据参数
- (void)initData {
    
}

///设置状态栏样式
- (void)setNaviBarStyle {
    
}

///重写系统的title方法
- (void)setTitle:(NSString *)title{
    [super setTitle:title];
    if (self.naviBar) {
        self.naviBar.title = title;
    }
}

#pragma mark - 设置状态栏
///设置状态栏是否隐藏
- (void)setStatusBarIsHide:(BOOL)isHide{
    _statusIsHide = isHide;
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
}
///设置状态栏样式为默认
- (void)setStatusBarStyleDefault{
    _statusStyle = UIStatusBarStyleDefault;//随系统改变
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
}
///设置状态栏样式为白色
- (void)setStatusBarStyleLight{
    _statusStyle = UIStatusBarStyleLightContent;
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
}

///设置状态栏样式为暗黑
- (void)setStatusBarStyleDark{
    if (@available(iOS 13.0, *)) {
        _statusStyle = UIStatusBarStyleDarkContent;
        [self setNeedsStatusBarAppearanceUpdate];//更新状态栏
    } else {
        // Fallback on earlier versions
    }
}

//是否隐藏
- (BOOL)prefersStatusBarHidden{
    return _statusIsHide;
}
//状态栏样式
/**
 typedef NS_ENUM(NSInteger, UIStatusBarStyle) {
 UIStatusBarStyleDefault                                     = 0, // Dark content, for use on light backgrounds
 UIStatusBarStyleLightContent     NS_ENUM_AVAILABLE_IOS(7_0) = 1, // Light content, for use on dark backgrounds
 
 UIStatusBarStyleBlackTranslucent NS_ENUM_DEPRECATED_IOS(2_0, 7_0, "Use UIStatusBarStyleLightContent") = 1,
 UIStatusBarStyleBlackOpaque      NS_ENUM_DEPRECATED_IOS(2_0, 7_0, "Use UIStatusBarStyleLightContent") = 2,
 } __TVOS_PROHIBITED;
 */
//状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return _statusStyle;
}
/**
 typedef NS_ENUM(NSInteger, UIStatusBarAnimation) {
 UIStatusBarAnimationNone,
 UIStatusBarAnimationFade NS_ENUM_AVAILABLE_IOS(3_2),
 UIStatusBarAnimationSlide NS_ENUM_AVAILABLE_IOS(3_2),
 }
 */
//状态栏隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationSlide;
}


#pragma mark - 右滑返回手势的 开启  && 禁止
///禁止返回手势
- (void)removeBackGesture{
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

/**
 * 恢复返回手势
 */
- (void)resumeBackGesture{
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


#pragma mark - 视图推进封装
///推进视图 && Xib
- (void)pushViewControllerWithNibClassString:(NSString *)classString pageTitle:(NSString *)title{
    
    Class ClassViewController = NSClassFromString(classString);
    
    UIViewController *pushVC = [[ClassViewController alloc] initWithNibName:classString bundle:nil];
    
    if (title) {
        pushVC.title = title;
    }
    
    [self.navigationController pushViewController:pushVC animated:YES];
}

///推进视图
- (void)pushViewControllerWithClassString:(NSString *)classString pageTitle:(NSString *)title{
    
    Class ClassViewController = NSClassFromString(classString);
    
    UIViewController *pushVC = [[ClassViewController alloc] init];
    
    if (title) {
        pushVC.title = title;
    }
    
    [self.navigationController pushViewController:pushVC animated:YES];
}


#pragma mark - 弹出模态视图

///弹出模态视图
- (void)presentViewController:(UIViewController *)presentVC{
    
    presentVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:presentVC animated:YES completion:nil];
}

///弹出模态视图
- (void)presentViewController:(UIViewController *)presentVC presentStyle:(UIModalTransitionStyle)presentStyle completionBlock:(void (^)(void))completion{
    
    presentVC.modalTransitionStyle = presentStyle;
    
    [self presentViewController:presentVC animated:YES completion:completion];
}


#pragma mark - 导航条&&协议方法

///左侧第一个按钮
- (void)leftFirstButtonClick{
    
    //默认这个为返回按钮
    [self.navigationController popViewControllerAnimated:YES];
}

///右侧第一个按钮
- (void)rightFirstButtonClick{
    
}

///右侧第二个按钮
- (void)rightSecondButtonClick{
    
    
}

#pragma mark - ************************* 通知触发事件 *************************
///登录状态变化发生处理事件
- (void)loginStateChange{
    NSLog(@"登录状态发生变化");
    
}

#pragma mark - 网络状态发生变化触发事件
- (void)reachabilityNetStateChanged:(NSNotification *)noti{
    
    /**
    StatusUnknown           = -1, //未知网络
    StatusNotReachable      = 0,    //没有网络
    StatusReachableViaWWAN  = 1,    //手机自带网络
    StatusReachableViaWiFi  = 2     //wifi
     */
    
    switch ([APPHttpTool sharedNetworking].networkStats) {
        case StatusUnknown:
            //[self showMessage:@"未知网络"];
            break;
        case StatusNotReachable:
            //[self showMessage:@"网络连接断开"];
            break;
        case StatusReachableViaWWAN:
            //[self showMessage:@"您正在使用2G/3G/4G网络"];
            break;
        case StatusReachableViaWiFi:
            //[self showMessage:@"您正在使用WiFi网络"];
            break;
            
        default:
            break;
    }
}

///改变模式通知 警告！这个是单独设置个别VC的特征集合模式，设置完不受系统控制
- (void)changeVCLightOrDarkModel {

    if (@available(iOS 13.0, *)) {
        
        switch ([APPManager sharedInstance].faceStyle) {
            case 0:
                //系统
                self.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
                [self setStatusBarStyleDefault];
                break;
            case 1:
                //白色
                self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
                [self setStatusBarStyleDark];//暗黑状态栏
                break;
            case 2:
                //暗黑
                self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
                [self setStatusBarStyleLight];//白色状态栏
                break;
                
            default:
                break;
        }
    } else {
        // Fallback on earlier versions
    }
    /**
    VC中self.overrideUserInterfaceStyle 只会改变VC内所有的子视图模式
    当我们强行设置当前viewController为Dark Mode后，这个viewController下的view都是Dark Mode

    由这个ViewController present出的ViewController不会受到影响，依然跟随系统的模式
     
    要想一键设置App下所有的ViewController都是Dark Mode，请直接在Window上执行overrideUserInterfaceStyle

    对window.rootViewController强行设置Dark Mode也不会影响后续present出的ViewController的模式
     
     注意!!!
     当我们强行设置当前viewController为Dark Mode后，这个viewController下的view都是Dark Mode
     由这个ViewController present出的ViewController不会受到影响，依然跟随系统的模式
     要想一键设置App下所有的ViewController都是Dark Mode，请直接在Window上执行overrideUserInterfaceStyle

     对window.rootViewController强行设置Dark Mode也不会影响后续present出的ViewController的模式
     */
}

#pragma mark - ************************* 暗黑模式改变的监听 *************************
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    // trait发生了改变
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            //模式已变
            NSLog(@"模式切换");
            //在这里进行 layer的颜色动态改变
            if (_statusStyle != UIStatusBarStyleDefault) {
                //不是系统默认
                if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                    //更新暗黑模式
                    [self setStatusBarStyleDark];
                }else if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
                    //更新亮色模式
                    [self setStatusBarStyleLight];
                }
            }
        }
    }
    /** 这些布局方法也会触发
       - (void)drawRect;
       - (void)viewWillLayoutSubviews;
       - (void)viewDidLayoutSubviews;
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"*************内存警告*************");
}

@end
