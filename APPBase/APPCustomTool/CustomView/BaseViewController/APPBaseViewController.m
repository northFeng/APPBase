//
//  APPBaseViewController.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/8/24.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "APPBaseViewController.h"

#import "MBProgressHUDTool.h"//文字提示

#import "AppDelegate.h"//代理

#import "APPAlertView.h"//提示弹框

@interface APPBaseViewController ()

///执行回调事件
@property (nonatomic,copy) APPBackBlock blockSEL;

@end

@implementation APPBaseViewController
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
    
    if (_waitingView) {
       [_waitingView deallocTimer];
    }
}


//tabBar的控制页面 在 点方法中设置标题
- (void)setNaviBarTitle:(NSString *)naviBarTitle{
    
    _naviBarTitle = naviBarTitle;
    self.naviBar.title = _naviBarTitle;
    //要在这里进行修改
    self.headLabelTitle.text = _naviBarTitle;
}

#pragma mark - 创建视图&&初始化数据
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /** 设置视图不自动压低tableview
     self.automaticallyAdjustsScrollViewInsets = NO;
     self.edgesForExtendedLayout = UIRectEdgeNone;
     */
    
    //注册登录通知
    [APPNotificationCenter addObserver:self selector:@selector(loginStateChange) name:_kGlobal_LoginStateChange object:nil];
    
    //接收网络状态变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityNetStateChanged:) name:_kGlobal_NetworkingReachabilityChangeNotification object:nil];
    
    //统一视图背景颜色
    self.view.backgroundColor = APPColor_White;
    
    //设置状态栏状态数据初始状态(默认为黑色，不隐藏)
    _statusStyle = UIStatusBarStyleDefault;
    _statusIsHide = NO;
    
    //初始化一些数据
    self.page = 1;
    self.arrayDataList = [NSMutableArray array];//分页请求存储数据数组
    
    //创建导航条
    self.naviBar = [[GFNavigationBarView alloc] init];
    self.naviBar.title = self.naviBarTitle;
    self.naviBar.titleLabel.alpha = 0;
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
    
    //创建界面  自己在子视图中自己定义加载位置
    //[self createTableView];
    //[self createView];
    
}

#pragma mark - 初始化界面基础数据
- (void)initData {
    
    
}

///设置导航栏样式
- (void)setNaviBarStyle{
    
    
}

#pragma mark - Init View  初始化一些视图之类的
- (void)createView{
    
    
}


///添加等待视图
- (APPLoadWaitView *)waitingView{
    
    if (!_waitingView) {
        //创建等待视图
        _waitingView = [[APPLoadWaitView alloc] init];
        _waitingView.frame = CGRectMake(0, 0, 121, 121);
        _waitingView.center = CGPointMake(kScreenWidth/2., kScreenHeight/2.);
        _waitingView.layer.cornerRadius = 4;
        _waitingView.layer.masksToBounds = YES;
    }
    return _waitingView;
}



#pragma mark - 消息提示弹框

///开启等待视图
- (void)startWaitingAnimating{
    
    [self.view bringSubviewToFront:self.waitingView];
    [self.waitingView startAnimation];
}
///关闭等待视图
- (void)stopWaitingAnimating{
    
    [self.waitingView stopAnimation];
}

///开启等待视图
- (void)startWaitingAnimatingWithTitle:(NSString *)title{
    
    [self.view bringSubviewToFront:self.waitingView];
    [self.waitingView startAnimationWithTitle:title];
}
///关闭等待视图
- (void)stopWaitingAnimatingWithTitle:(NSString *)title{
    
    [self.waitingView stopAnimationWithTitle:title];
}

///关闭等待视图——>执行block
- (void)stopWaitingAnimatingWithTitle:(NSString *)title block:(APPBackBlock)block{
    
    [self.waitingView stopAnimationWithTitle:title];
    
    if (block) {
        block(YES,nil);
    }
}

///消息提示弹框
- (void)showMessage:(NSString *)message{
    //默认设置两秒
    [[MBProgressHUDTool sharedMBProgressHUDTool] showTextToastView:message view:self.view];
}

///消息提示弹框 && 执行block
- (void)showMessage:(NSString *)message block:(APPBackBlock)block{
    
    //默认设置两秒
    [[MBProgressHUDTool sharedMBProgressHUDTool] showTextToastView:message view:self.view];
    
    self.blockSEL = block;
    [self performSelector:@selector(performBlock) withObject:nil afterDelay:1];
}

///执行block
- (void)performBlock{
    
    if (self.blockSEL) {
        self.blockSEL(YES, nil);
    }
}

/**
 *  @brief 消息提示框（显示在本控制器上，多个提示框不会重叠）
 *
 *  @param message 消息默认显示在self.view上
 *
 */
- (void)showMessage:(NSString *)message onView:(UIView *)subView{
    //默认设置两秒
    [[MBProgressHUDTool sharedMBProgressHUDTool] showTextToastView:message view:subView];
}


///自定义消息确定框
- (void)showAlertCustomMessage:(NSString *)message okBlock:(APPBackBlock)block{
    
    APPAlertView *fsAlert = [[APPAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:message withBlock:block];
}

///自定义弹框——>自定义标题
- (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message okBlock:(APPBackBlock)block{
    
    APPAlertView *fsAlert = [[APPAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:title brif:message withBlock:block];
}

///自定义弹框——>自定义标题——>自定义按钮文字
- (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message cancleBtnTitle:(NSString *)cancleTitle okBtnTitle:(NSString *)okTitle okBlock:(APPBackBlock)block{
    
    APPAlertView *fsAlert = [[APPAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:title brif:message leftBtnTitle:cancleTitle rightBtnTitle:okTitle withBlock:block];
}

///自定义弹框——>自定义标题——>自定义按钮文字 ——>左右按钮事件
- (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message cancleBtnTitle:(NSString *)cancleTitle okBtnTitle:(NSString *)okTitle leftBlock:(APPBackBlock)blockLeft rightBlock:(APPBackBlock)blockRight{
    
    APPAlertView *fsAlert = [[APPAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:title brif:message leftBtnTitle:cancleTitle rightBtnTitle:okTitle blockleft:blockLeft blockRight:blockRight];
}

///消息确定框
- (void)showAlertMessage:(NSString *)message title:(NSString *)title{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancleAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

///消息提示框
- (void)showAlertMessage:(NSString *)message title:(NSString *)title btnTitle:(NSString *)btnTitle block:(Block)block{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //执行block
        if (block) {
            block();
        }
    }];
    [alertController addAction:cancleAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

///消息提示框 && 处理block
- (void)showAlertMessage:(NSString *)message title:(NSString *)title btnLeftTitle:(NSString *)leftTitle leftBlock:(Block)leftBlock btnRightTitle:(NSString *)rightTitle rightBlock:(Block)rightBlock{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //执行block
        if (leftBlock) {
            leftBlock();
        }
    }];
    [alertController addAction:leftAction];
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //执行block
        if (rightBlock) {
            rightBlock();
        }
    }];
    [alertController addAction:rightAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


///提示无网
- (void)showPromptNonetView{
    self.promptNonetView.hidden = NO;
    self.promptEmptyView.hidden = YES;
}

///提示无内容
- (void)showPromptEmptyView{
    self.promptNonetView.hidden = YES;
    self.promptEmptyView.hidden = NO;
}

//隐藏无网&&无内容提示图
- (void)hidePromptView{
    self.promptNonetView.hidden = YES;
    self.promptEmptyView.hidden = YES;
}



@end
