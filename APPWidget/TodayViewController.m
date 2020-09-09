//
//  TodayViewController.m
//  APPWidget
//
//  Created by 峰 on 2020/9/9.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

/**
 
 注意：plist文件貌似不用修改
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (@available(iOS 10.0, *)){
           self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
       }
       
    
    self.preferredContentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width - 20, 100);
    
    //创建视图
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = UIColor.redColor;
    btn1.frame = CGRectMake(50, 25, 50, 50);
    [btn1 setTitle:@"搜索" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = UIColor.redColor;
    btn2.frame = CGRectMake(150, 25, 50, 50);
    [btn2 setTitle:@"查看" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.backgroundColor = UIColor.redColor;
    btn3.frame = CGRectMake(250, 25, 50, 50);
    [btn3 setTitle:@"下载" forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    
    [btn1 addTarget:self action:@selector(onClickBtn1) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(onClickBtn2) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(onClickBtn3) forControlEvents:UIControlEventTouchUpInside];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    
    NSLog(@"maxWidth %f maxHeight %f",maxSize.width,maxSize.height);
    
    //在这里可进行布局
    
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        
        self.preferredContentSize = CGSizeMake(maxSize.width, 200);
        
    } else{
        
        self.preferredContentSize = CGSizeMake(maxSize.width, 200);
        
    }
}

//iOS10 以后放弃该方法 —> iOS10之前，视图原点默认存在一个间距，可以实现以下方法来调整视图间距
//- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
//    return UIEdgeInsetsMake(0, 10, 0, 10);
//}


#pragma mark - ************************* 处理按钮点击事件 *************************
/**
 Widget 唤醒 宿主APP
 */
///按钮1点击
- (void)onClickBtn1 {
    
    //在 跳转URL后面进行参数拼接，宿主APP 来解析 路径，进行不同的操作！ ——> 在 AppDelegate.m APP代理中接受 openUrl代理事件，进行处理事件
    NSURL *url = [NSURL URLWithString:@"appbaseWidget://btn1"];
    
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
    }];
}

///按钮2点击
- (void)onClickBtn2 {
    
    NSURL *url = [NSURL URLWithString:@"appbaseWidget://btn2"];
    
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
    }];
}

///按钮3点击
- (void)onClickBtn3 {
    
    NSURL *url = [NSURL URLWithString:@"appbaseWidget://btn3"];
    
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
    }];
}

/**  简书 https://www.jianshu.com/p/012319813522
 数据共享

 扩展程序一般都不是脱离宿主程序单独运行的，难免需要和宿主程序进行数据交互。而相对于一般的APP，数据可以用单例，NSUserDefault等等。但由于拓展与宿主应用是两个完全独立的App，并且iOS应用基于沙盒的形式限制，所以一般的共享数据方法都是实现不了数据共享，这里就需要使用App Groups。

 在宿主程序和扩展程序中分别设置打开App Group，设置一个group的名称，这里要保证宿主APP和扩展APP的groupName要是相同的。

 
 两种数据存储方式

 使用NSUserDefault
 这里不能使用[NSUserDefaults standardUserDefaults];方法来初始化NSUserDefault对象，正像之前所说，由于沙盒机制，拓展应用是不允许访问宿主应用的沙盒路径的，因此上述用法是不对的，需要搭配app group完成实例化UserDefaults。正确的使用方式如下：
 
 1-1、写入数据
 NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.japho.widgetDemo"];
 [userDefaults setObject:self.textField.text forKey:@"widget"];
 [userDefaults synchronize];
 
 1-2、读取数据
 NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.japho.widgetDemo"];
 self.contentStr = [userDefaults objectForKey:@"widget"];

 
 2-1、通过NSFileManager共享数据
 写入数据
 NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.xxx"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/ widget"];
    NSString *value = @"asdfasdfasf";
    BOOL result = [value writeToURL:containerURL atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!result)
    {
        NSLog(@"%@",err);
    }
    else
    {
        NSLog(@"save value:%@ success.",value);
    }
 
 2-2、读取数据
 NSError *err = nil;
 NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.xxx"];
 containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/ widget"];
 NSString *value = [NSString stringWithContentsOfURL:containerURL encoding: NSUTF8StringEncoding error:&err];
 
 
 其他

 补充：widget的上线也是需要单独申请APP ID的 需要配置证书和Provisioning Profiles文件
 没有配置相关证书时：
 
 */


@end
