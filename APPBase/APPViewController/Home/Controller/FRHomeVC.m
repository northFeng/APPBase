//
//  FRHomeVC.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/21.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "FRHomeVC.h"
#import "FROrderCellVC.h"
#import "GFNavigationController.h"
#import "APPDataBase.h"//数据库

///Apple 登录框架
#import <AuthenticationServices/AuthenticationServices.h>

#import "APPLoginApi.h"

@interface FRHomeVC () <UIViewControllerPreviewingDelegate , UIContextMenuInteractionDelegate>

///
@property (nonatomic,strong) APPDataBase *dataBase;



@end

@implementation FRHomeVC
{
    UIButton *_btnTwo;
    UIButton *_btn3;
}

- (void)dealloc{
    
    NSLog(@"---->FRHome死亡了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"SwiftOne" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 200, 50, 30);
    [btn addTarget:self action:@selector(onClickBtnStore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"全部" forState:UIControlStateNormal];
    btn2.backgroundColor = UIColor.yellowColor;
    btn2.frame = CGRectMake(200, 300, 100, 50);
    [btn2 addTarget:self action:@selector(onClickBtnTake) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn3 setTitle:@"分页" forState:UIControlStateNormal];
    btn3.frame = CGRectMake(300, 200, 50, 30);
    [btn3 addTarget:self action:@selector(onClickBtnTakePage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    
    _dataBase = [[APPDataBase alloc] init];
    
    [_dataBase createDataBase];
    
    
    ASAuthorizationAppleIDButton * appleIDBtn = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeDefault style:ASAuthorizationAppleIDButtonStyleWhite];
    appleIDBtn.frame = CGRectMake(30, 80, 60, 64);
    [appleIDBtn addTarget:self action:@selector(didAppleIDBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:appleIDBtn];
    
    
    //添加3DTouch view
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        NSLog(@"3D Touch  可用!");
        //给cell注册3DTouch的peek（预览）和pop功能 ，注册(在哪个页面上使用该功能就注册在哪个页面上)
        [self registerForPreviewingWithDelegate:self sourceView:btn2];
    } else {
        NSLog(@"3D Touch 无效");
    }
}

//--------------------------------------- 3DTouch代理  UIContextMenuInteractionDelegate ---------------------------------------
//2.第二步
#pragma mark - UIViewControllerPreviewingDelegate（实现代理的方法）
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    FROrderCellVC *cellVC = [[FROrderCellVC alloc] init];
    
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    //UIView *touchView = [previewingContext sourceView]];
    
    
    //设定预览的界面 的 尺寸 (可不设置)
    cellVC.preferredContentSize = CGSizeMake(0,0);// 默认 (0,0) ——>系统会自动适配 宽高 ， 非0的话，设置多少显示多少。默认居中显示
    
    //设置 被按压区域view的尺寸 ——> 为了不让 按压的view 不被虚化
    //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    CGRect rect = CGRectMake(0, 0, 100, 50); //这个尺寸 是以按压view的bounds,设置 不被虚化的 尺寸！！！！——>默认x,y为0， width/height为view的宽高
    previewingContext.sourceRect = rect;
    
    return cellVC;
    
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}


/*!
 * @abstract Called when the interaction begins.
 *
 * @param interaction  The UIContextMenuInteraction.
 * @param location     The location of the interaction in its view.
 *
 * @return A UIContextMenuConfiguration describing the menu to be presented. Return nil to prevent the interaction from beginning.
 *         Returning an empty configuration causes the interaction to begin then fail with a cancellation effect. You might use this
 *         to indicate to users that it's possible for a menu to be presented from this view, but that there are no actions to
 *         present at this particular time.
 */
//- (nullable UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location API_AVAILABLE(ios(13.0)) {
//    //UIContextMenuInteraction
//}

//--------------------------------------------------------------------------------------------



///
- (void)didAppleIDBtnClicked {
    
    NSLog(@"点击苹果登录按钮");
    
    [APPLoginApi.shareInstance appleLogin];
}

///存储
- (void)onClickBtnStore {
    
    NSLog(@"---->%@",[APPLoacalInfo getDeviceIDInKeychain]);
    //4780A8E1-8F2D-4324-B5FF-92228139AB53
    
    OneSwiftController *swiftVC = [[OneSwiftController alloc] init];
    swiftVC.infoStr = @"OC传的消息";
    [self.navigationController pushViewController:swiftVC animated:YES];

}

///读取
- (void)onClickBtnTake {
   
    [_dataBase getData];
    
}

///
- (void)onClickBtnTakePage {
    static int i = 0;
    [_dataBase getDataPage:i limit:5];
    i ++;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
