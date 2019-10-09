//
//  AppDelegate+RootConTroller.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/21.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "AppDelegate+RootConTroller.h"

#import "GFNavigationController.h"

#import "FRHomeVC.h"//APP主页

#import "APPVersionAlert.h"//版本更新提示

@implementation AppDelegate (RootConTroller)

/**
 *  根视图
 */
- (void)setRootViewController{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 让当前UIWindow变成keyWindow，并显示出来
    [self.window makeKeyAndVisible];
    
    //不是第一次安装
    [self setRoot];
    
    /**
    //判断是否第一次安装
    NSString *isFirstOpen = [APPUserDefault objectForKey:_kGlobal_IsFirstOpen];
    if (kObjectEntity(isFirstOpen)) {
        //不是第一次安装
        [self setRoot];
    }else{
        //跳进协议页面
        [self setAgreementVC];
    }
     */
}

#pragma mark - 设置根视图
///设置根视图
- (void)setRoot{
    
    FRHomeVC *home = [[FRHomeVC alloc] init];
    
    GFNavigationController *navi = [[GFNavigationController alloc] initWithRootViewController:home];
    navi.navigationBar.hidden = YES;//隐藏系统导航条（只是隐藏的NavigationController上的naviBar，因此返回手势存在）
    //设置根视图
    self.window.rootViewController = navi;
    
    //检查更新
    [self checkTheLatestVersion];
}



#pragma mark - 版本检测是否有更新
- (void)checkTheLatestVersion{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *appStoreVerson = [APPLoacalInfo judgeIsHaveUpdate];
        if (appStoreVerson.length) {
            //App Store上有新版本
            
            [APPFunctionMethod getRequestNetDicDataUrl:_kNet_version_check params:@{} WithBlock:^(BOOL result, id  _Nonnull idObject) {
                
                if (result) {
                    NSDictionary *newVersionInfo = (NSDictionary *)idObject;
                    
                    //数据请求成功
                    if (kObjectEntity(newVersionInfo)) {
                    
                        //判断App Store版本号 与 后台 版本号 是否一致 ——> 一致 说明 后台数据库已更新版本号
                        if ([appStoreVerson isEqualToString:newVersionInfo[@"versionName"]]) {
                            //提示更新弹框
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //有新版本 && 进行提示
                                [APPVersionAlert showVersonUpdateAlertViewWithVersonInfo:newVersionInfo];
                            });
                        }
                    }
                }
            }];
        }
    });
    
}


///消息提示框 && 处理block
- (void)showAlertMessage:(NSString *)message title:(NSString *)title btnLeftTitle:(NSString *)leftTitle leftBlock:(APPBackBlock)leftBlock btnRightTitle:(NSString *)rightTitle rightBlock:(APPBackBlock)rightBlock{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //执行block
        if (leftBlock) {
            leftBlock(YES,nil);
        }
    }];
    [alertController addAction:leftAction];
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //执行block
        if (rightBlock) {
            rightBlock(YES,nil);
        }
    }];
    [alertController addAction:rightAction];
    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}



@end
