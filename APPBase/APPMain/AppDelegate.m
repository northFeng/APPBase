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


@interface AppDelegate ()

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


@end
