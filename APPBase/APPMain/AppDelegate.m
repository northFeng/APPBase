//
//  AppDelegate.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/21.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "AppDelegate.h"

//设置根视图
#import "AppDelegate+RootConTroller.h"

//bug统计
#import <Bugly/Bugly.h>

//带有热更新的Bugly
//#import <BuglyHotfix/Bugly.h>
//#import <BuglyHotfix/BuglyMender.h>
#import "JPEngine.h"

#import "APPAnalyticsHelper.h"//统计分析工具

@interface AppDelegate ()<BuglyDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //对APP进行一些配置
    [self appConfiguration];
    
    //启动用户信息
    [APPManager sharedInstance];
    
    //设置根视图
    [self setRootViewController];
    
    
    return YES;
}

#pragma mark - app配置
///APP配置
- (void)appConfiguration{
    
    //开启网络监测类
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [APPHttpTool startMonitoring];
    });
    
#if DEBUG
    //输入页面跟踪信息
    [APPAnalyticsHelper analyticsViewController];
#endif
    
    //设置键盘适配界面
    [APPAnalyticsHelper setKeyBoardlayout];
    
    //对APP做特别的配置
    [self setAPPConfiguration];
    
    //bug统计
    [Bugly startWithAppId:[APPKeyInfo getBuglyId]];
    
}


///设置APP内的特别设置
- (void)setAPPConfiguration{
    
    //设置界面按钮只能点击一个
    [[UIButton appearance] setExclusiveTouch:YES];
    
}


- (void)configBugly {
    //初始化 Bugly 异常上报
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.delegate = self;
    config.debugMode = YES;
    config.reportLogLevel = BuglyLogLevelInfo;
    [Bugly startWithAppId:[APPKeyInfo getBuglyId]
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    //捕获 JSPatch 异常并上报
    [JPEngine handleException:^(NSString *msg) {
        NSException *jspatchException = [NSException exceptionWithName:@"Hotfix Exception" reason:msg userInfo:nil];
        [Bugly reportException:jspatchException];
    }];
    /**
    //检测补丁策略
    [[BuglyMender sharedMender] checkRemoteConfigWithEventHandler:^(BuglyHotfixEvent event, NSDictionary *patchInfo) {
        //有新补丁或本地补丁状态正常
        if (event == BuglyHotfixEventPatchValid || event == BuglyHotfixEventNewPatch) {
            //获取本地补丁路径
            NSString *patchDirectory = [[BuglyMender sharedMender] patchDirectory];
            if (patchDirectory) {
                //指定执行的 js 脚本文件名
                NSString *patchFileName = @"main.js";
                NSString *patchFile = [patchDirectory stringByAppendingPathComponent:patchFileName];
                //执行补丁加载并上报激活状态
                if ([[NSFileManager defaultManager] fileExistsAtPath:patchFile] &&
                    [JPEngine evaluateScriptWithPath:patchFile] != nil) {
                    BLYLogInfo(@"evaluateScript success");
                    [[BuglyMender sharedMender] reportPatchStatus:BuglyHotfixPatchStatusActiveSucess];
                }else {
                    BLYLogInfo(@"evaluateScript failed");
                    [[BuglyMender sharedMender] reportPatchStatus:BuglyHotfixPatchStatusActiveFail];
                }
            }
        }
    }];
    */
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 设置APP的旋转方向
/*  这个方法来控制APP的屏幕旋转，viewController里面的代码是来控制界面的旋转
 1.建议去掉General里Device Orientation的勾选用代码方式设置。
 2.建议在AppDelegate.h里设置公有属性，通过设置该属性来灵活改变App支持方向。
 3.此方法在shouldAutorotate返回YES时会触发。
 */
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotate) {

        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else {

        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
