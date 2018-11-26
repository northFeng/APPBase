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
        
        NSString *url = HTTPURL(_kNet_version_check);
        
        NSString *appInfoString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
        
        if (kObjectIsEmptyEntity(appInfoString)) {
            return ;
        }
        
        NSData *appInfoData = [appInfoString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:appInfoData options:NSJSONReadingMutableLeaves error:&error];
        
        //新版本信息
        NSDictionary *newVersionInfo = appInfoDic[@"data"];
        
        //与本地版本进行判断
        //NSDictionary *oldVersionInfo = [APPUserDefault objectForKey:_kGlobal_versionInfo];
        
        if (!error && kObjectEntity(appInfoDic) && [appInfoDic[@"status"] integerValue] == 200 && kObjectEntity(newVersionInfo)) {
            
            APPManagerObject.serviceVersionStr = newVersionInfo[@"versionName"];
            
            //本地存储的版本信息
            NSDictionary *oldVersionInfo = [APPUserDefault objectForKey:_kGlobal_versionInfo];
            
            if (kObjectEntity(oldVersionInfo)) {
                NSLog(@"%@",newVersionInfo);
                //判断本地版本号
                NSString *versionLocal = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                
                if (![versionLocal isEqualToString:newVersionInfo[@"versionName"]]) {
                    //版本号不一样
                    
                    //旧的版本序号
                    NSInteger oldVersionNum = [oldVersionInfo[@"versionCode"] integerValue];
                    //新的版本序号
                    NSInteger newVersionNum = [newVersionInfo[@"versionCode"] integerValue];
                    
                    //是否提示更新依据 版本序号！！ 版本序号 小于 服务版本序号 则提示更新
                    if (oldVersionNum < newVersionNum) {
                        //有新的版本序号
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //有新版本 && 进行提示
                            APPVersionAlert *alertView = [[APPVersionAlert alloc] init];
                            alertView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                            [alertView setDicModel:newVersionInfo];
                            
                            [self.window.rootViewController.view addSubview:alertView];
                        });
                    }
                    
                }else{
                    //版本号一致 && 更新本地版本信息
                    [APPUserDefault setObject:newVersionInfo forKey:_kGlobal_versionInfo];
                }
                
            }else{
                //第一次进来先存储服务器版本信息
                [APPUserDefault setObject:newVersionInfo forKey:_kGlobal_versionInfo];
            }
            
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
