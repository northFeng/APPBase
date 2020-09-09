//
//  AppDelegate+RootConTroller.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/21.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "AppDelegate+RootConTroller.h"

#import "GFNavigationController.h"
#import "GFTabBarController.h"

#import "FRHomeVC.h"//APP主页
#import "GFMiddleController.h"
#import "GFMineController.h"

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
    
    FRHomeVC *one = [[FRHomeVC alloc] init];
    
    /**
    GFNavigationController *navi = [[GFNavigationController alloc] initWithRootViewController:home];
    navi.navigationBar.hidden = YES;//隐藏系统导航条（只是隐藏的NavigationController上的naviBar，因此返回手势存在）
    //设置根视图
    self.window.rootViewController = navi;
     */
    
    GFMiddleController *two = [[GFMiddleController alloc] init];
    GFMineController *thr = [[GFMineController alloc] init];
        
    GFTabBarController *gfTabBar = [GFTabBarController sharedInstance];
    gfTabBar.viewControllers = @[one,two,thr];//添加子视图
    //默认图片
    NSArray *arrayNomal = @[@"home_n",@"order_n",@"mine_n"];
    //选中按钮的图片
    NSArray *arraySelect = @[@"home_s",@"order_s",@"mine_s"];
    //item的标题
    NSArray *arrayTitle = @[@"首页",@"订单",@"我的"];
    
    [gfTabBar creatItemsWithDefaultIndex:0 normalImageNameArray:arrayNomal selectImageArray:arraySelect itemsTitleArray:arrayTitle];//设置items并设置第一个显示位置
    
    GFNavigationController *navi = [[GFNavigationController alloc] initWithRootViewController:gfTabBar];
    navi.navigationBar.hidden = YES;//隐藏系统导航条
    //设置根视图
    self.window.rootViewController = navi;
    
    //检查更新
    [self checkTheLatestVersion];
}



#pragma mark - 版本检测是否有更新
- (void)checkTheLatestVersion{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //方法一  以APP商店为标准
        NSString *appStoreVerson = [APPLoacalInfo judgeIsHaveUpdate];
        if (appStoreVerson.length) {
            //App Store上有新版本
            
            [APPHttpTool getRequestNetDicDataUrl:_kNet_version_check params:@{} WithBlock:^(BOOL result, id  _Nonnull idObject, NSInteger code) {
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
        
        
        /**
         //方法2
         [APPHttpTool getRequestNetDicDataUrl:@"v2/front/upgrade" params:@{@"clinentUpdateType":@(2)} WithBlock:^(BOOL result, id  _Nonnull idObject, NSInteger code) {
             if (result) {
                 NSDictionary *newVersionInfo = ((NSDictionary *)idObject)[@"upgrade"];

                 NSString *netVerson = newVersionInfo[@"version"];//服务器版本
                 
                 if (kObjectEntity(netVerson)) {
                     
                     [APPManager sharedInstance].appstoreVersion = netVerson;
             
                     NSString *appLocalVerson = [APPLoacalInfo appVerion];//本地APP版本号
                     
                     BOOL isHaveUpdate = [APPLoacalInfo compareTheTwoVersionsAPPVerson:netVerson localVerson:appLocalVerson];
                     
                     if (isHaveUpdate) {
                         //新版本
                         //提示更新弹框
                         dispatch_async(dispatch_get_main_queue(), ^{
                             //有新版本 && 进行提示
                             //[APPVersionAlertView showVersonUpdateAlertViewWithVersonInfo:newVersionInfo];

                         });
                     }
                 }
             }
         }];
         */
        

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



#pragma mark - ************************* APPicon 3DTouch功能 *************************
///添加3D touch功能，APP长按弹框
- (void)add3DTouch {
    
    //1、静态添加 ——> 在info.plist文件中添加 字段
    /**
     UIApplicationShortcutItems —> Array 类型 ——> 添加Item ——> 四个字段
     UIApplicationShortcutItems：数组中的元素就是我们那些快捷选项标签
     
     UIApplicationShortcutItemIcon：标签图标（可选）
     
     UIApplicationShortcutItemType: 快捷可选项的特定字符串(必填)
     UIApplicationShortcutItemTitle: 快捷可选项的标题(必填)
     UIApplicationShortcutItemSubtitle: 快捷可选项的子标题(可选)
     UIApplicationShortcutItemIconType: 快捷可选项的图标(可选)
     UIApplicationShortcutItemIconFile: 快捷可选项的自定义图标(可选)
     UIApplicationShortcutItemUserInfo: 快捷可选项的附加信息(可选)
     */
    
    /**
     静态添加 和 动态添加 可以同时使用, 但是系统会先加载 静态 items, 然后再加载 动态 items.

     开发者自定义的貌似最多只能添加 4 个 item, 加上系统会自带一个 分享应用 一共 5 个.(虽然没有看到文档里面有写个数限制)
     */
    
    //2、代码动态添加
    if (self.window.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        //创建3DTouch模型
        
        //自定义图标  注意：自定义的 icon 必须是 35 * 35 的 「正方形 单色」(底层镂空，图形 黑色) 的图片
        UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];//+ (instancetype)iconWithTemplateImageName:(NSString *)templateImageName; 自定义icon
        UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
        
        //创建带有自定义图标的item
        UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"icon1" localizedTitle:@"搜索" localizedSubtitle:@"首页搜索" icon:icon1 userInfo:nil];
        UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"icon2" localizedTitle:@"分享" localizedSubtitle:@"课程分享" icon:icon2 userInfo:nil];
        
        [[UIApplication sharedApplication] setShortcutItems:@[item1,item2]];
    }
    
    /**
     注: 在支持3D Touch的设备上,用户可以在程序运行期间通过设置 -> 通用 -> 辅助功能 -> 3D Touch来关闭3D Touch功能,所以我们有必要通过重写-traitCollectionDidChange:方法随时处理
     */
}

///APPicon菜单弹框事件
- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler {
    
    //获取 shortcutItem 的 type ，type就是初始化 item 的时候 传入的唯一标识符
    NSString *type = shortcutItem.type;
    
    if ([type isEqualToString:@"icon1"]) {
        //搜索
        NSLog(@"点击弹框菜单—>搜索");
    }else if ([type isEqualToString:@"icon2"]) {
        //分享
        NSLog(@"点击弹框菜单—>分享");
    }

}


#pragma mark - ************************* Widget事件处理 *************************
//iOS 9 之前
//- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation {
//
//
//    return YES;
//}

//iOS9之后
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.absoluteString hasPrefix:@"appbaseWidget"]) {
        //Widget事件
        NSLog(@"Widget事件URL---->%@",url.absoluteString);
    }
    
    return YES;
}

@end
