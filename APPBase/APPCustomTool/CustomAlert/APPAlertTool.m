//
//  APPAlertTool.m
//  APPBase
//
//  Created by 峰 on 2019/10/11.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPAlertTool.h"

#import <MBProgressHUD/MBProgressHUD.h>

#import "APPLoadWaitView.h"//自定义等待视图

#import "APPAlertView.h"//自定义消息确认弹框

@implementation APPAlertTool

///获取APP内最顶部的View
+ (UIView *)topViewOfTopVC {
    
    UIViewController *topVC = [self topViewControllerOfAPP];
    
    if (topVC) {
        return topVC.view;
    }else{
        return nil;
    }
}

///获取APP内最顶层的VC
+ (UIViewController *)topViewControllerOfAPP {
    
    UINavigationController *navi = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *topVC = [self topViewControllerWithRootViewController:navi];
    
    return topVC;
}

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    /**
    [[[UIApplication sharedApplication] keyWindow] rootViewController]有时为nil 比如当页面有菊花在转的时候，这个rootViewController就为nil;

    所以使用[[[[UIApplication sharedApplication] delegate] window] rootViewController]
    或者[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController]

    presentedViewController 和presentingViewController
    当A弹出B
    A.presentedViewController=B
    B.presentingViewController=A
     */
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
 
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if (rootViewController.presentedViewController) {
 
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
 
        UINavigationController *navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else {
        return rootViewController;
    }
}

+ (void)showMessage:(NSString *)message{
    
    //先取消已有的
    //[MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
    
    NSEnumerator *subviewsEnum = [[UIApplication sharedApplication].keyWindow.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
            MBProgressHUD *hud = (MBProgressHUD *)subview;
            //hud.removeFromSuperViewOnHide = YES;
            //[hud hideAnimated:NO];
            [hud removeFromSuperview];
            hud = nil;
        }
    }
    
    //显示新的
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.userInteractionEnabled = NO;//不阻挡下面的手势
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = message;
    hud.bezelView.backgroundColor = COLOR(@"#000000");
    hud.bezelView.layer.cornerRadius = 10.f;
    hud.detailsLabel.textColor = COLOR(@"#FFFFFF");
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    hud.minShowTime = 1.5;
    hud.offset = CGPointMake(0, -kScreenHeight*0.1);//2/5处 (5/10 - 4/10)
    [hud hideAnimated:YES afterDelay:1.5];
}

///展示文字到某个视图上
+ (void)showMessage:(NSString *)message onView:(UIView *)view {
    
    if (view) {
        //先取消已有的
        //[MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
        
        NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
        for (UIView *subview in subviewsEnum) {
            if ([subview isKindOfClass:[MBProgressHUD class]]) {
                MBProgressHUD *hud = (MBProgressHUD *)subview;
                //hud.removeFromSuperViewOnHide = YES;
                //[hud hideAnimated:NO];
                [hud removeFromSuperview];
                hud = nil;
            }
        }
        
        //显示新的
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;//不阻挡下面的手势
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = message;
        hud.bezelView.backgroundColor = DynamicColor([UIColor blackColor],[UIColor lightGrayColor]);
        hud.bezelView.layer.cornerRadius = 10.f;
        hud.detailsLabel.textColor = DynamicColor([UIColor whiteColor], [UIColor blackColor]);
        hud.detailsLabel.font = [UIFont systemFontOfSize:16];
        hud.minShowTime = 1.5;
        hud.offset = CGPointMake(0, -kScreenHeight*0.1);//2/5处 (5/10 - 4/10)
        [hud hideAnimated:YES afterDelay:1.5];
    }
}


+ (void)showLoading{
    
    UIView *view = [self topViewOfTopVC];
    if (view) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.userInteractionEnabled = NO;
        hud.contentColor = [UIColor redColor];//菊花颜色
        hud.offset = CGPointMake(0, -kScreenHeight*0.1);//2/5处 (5/10 - 4/10)
    }
}

+ (void)showLoadingForInterEnabled:(BOOL)enable{
    
    UIView *view = [self topViewOfTopVC];
    if (view) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.userInteractionEnabled = !enable;
        hud.bezelView.backgroundColor = DynamicColor([UIColor whiteColor], [UIColor blackColor]);
        hud.contentColor = [UIColor lightGrayColor];//菊花颜色
        hud.offset = CGPointMake(0, -kScreenHeight*0.1);//2/5处 (5/10 - 4/10)
    }
}

+ (void)hideLoading{
    
    UIView *view = [self topViewOfTopVC];
    
    if (view) {
        [MBProgressHUD hideHUDForView:view animated:YES];
    }
}

+ (void)showCustomLoading {
    [self showCustomLoadingWithTitle:@"加载中"];
}

+ (void)hideCustomLoading {
    [self hideCustomLoadingWithTitle:@""];
}

+ (void)showCustomLoadingWithTitle:(NSString *)title {
        
    UIView *view = [self topViewOfTopVC];
    if (view) {
        [APPLoadWaitView hideLoadingForView:view endTitle:@""];
        
        [APPLoadWaitView showLoadingAddedTo:view loadTitle:title];
    }
}

+ (void)hideCustomLoadingWithTitle:(NSString *)title {
    
    UIView *view = [self topViewOfTopVC];
    if (view) {
        [APPLoadWaitView hideLoadingForView:view endTitle:title];
    }
}


#pragma mark - ************************* 自定义消息确认弹框 *************************

///自定义消息确定框
+ (void)showAlertCustomMessage:(NSString *)message okBlock:(APPBackBlock)block{
    
    APPAlertView *fsAlert = [[APPAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:message withBlock:block];
}

///自定义弹框——>自定义标题
+ (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message okBlock:(APPBackBlock)block{
    
    APPAlertView *fsAlert = [[APPAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:title brif:message withBlock:block];
}

///自定义弹框——>自定义标题——>自定义按钮文字
+ (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message cancleBtnTitle:(NSString *)cancleTitle okBtnTitle:(NSString *)okTitle okBlock:(APPBackBlock)block{
    
    APPAlertView *fsAlert = [[APPAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:title brif:message leftBtnTitle:cancleTitle rightBtnTitle:okTitle withBlock:block];
}

///自定义弹框——>自定义标题——>自定义按钮文字 ——>左右按钮事件
+ (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message cancleBtnTitle:(NSString *)cancleTitle okBtnTitle:(NSString *)okTitle leftBlock:(APPBackBlock)blockLeft rightBlock:(APPBackBlock)blockRight{
    
    APPAlertView *fsAlert = [[APPAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:title brif:message leftBtnTitle:cancleTitle rightBtnTitle:okTitle blockleft:blockLeft blockRight:blockRight];
}

///消息确定框
+ (void)showAlertMessage:(NSString *)message title:(NSString *)title{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancleAction];
    
    UIViewController *topVC = [self topViewControllerOfAPP];
    [topVC presentViewController:alertController animated:YES completion:nil];
}

///消息提示框
+ (void)showAlertMessage:(NSString *)message title:(NSString *)title btnTitle:(NSString *)btnTitle block:(APPBackBlock)block{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //执行block
        if (block) {
            block(YES,@0);
        }
    }];
    [alertController addAction:cancleAction];
    
    UIViewController *topVC = [self topViewControllerOfAPP];
    [topVC presentViewController:alertController animated:YES completion:nil];
}

///消息提示框 && 处理block
+ (void)showAlertMessage:(NSString *)message title:(NSString *)title btnLeftTitle:(NSString *)leftTitle leftBlock:(APPBackBlock)leftBlock btnRightTitle:(NSString *)rightTitle rightBlock:(APPBackBlock)rightBlock{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //执行block
        if (leftBlock) {
            leftBlock(YES,@0);
        }
    }];
    [alertController addAction:leftAction];
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //执行block
        if (rightBlock) {
            rightBlock(YES,@0);
        }
    }];
    [alertController addAction:rightAction];
    
    UIViewController *topVC = [self topViewControllerOfAPP];
    [topVC presentViewController:alertController animated:YES completion:nil];
}

@end
