//
//  APPAnalyticsHelper.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/26.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "APPAnalyticsHelper.h"

//输入跟踪日志框架
#import "Aspects.h"

#import <IQKeyboardManager/IQKeyboardManager.h>//键盘框架

@implementation APPAnalyticsHelper

+ (void)analyticsViewController {
    //放到异步线程去执行
    //__weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Aspect only debug
        //面向切面，用于界面日志的输出
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:0 usingBlock:^(id<AspectInfo> info){
            NSLog(@"ViewContriller Enter \n ==================> \n %@", info.instance);
        } error:NULL];
        [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:0 usingBlock:^(id<AspectInfo> info){
            NSLog(@"ViewContriller Exit \n ==================> \n %@", info.instance);
        } error:NULL];
        [UIViewController aspect_hookSelector:@selector(didReceiveMemoryWarning) withOptions:0 usingBlock:^(id<AspectInfo> info){
            NSLog(@"ViewContriller didReceiveMemoryWarning \n ==================> \n %@", info.instance);
        } error:NULL];
    });
}


///设置键盘弹出
+ (void)setKeyBoardlayout{
    
    //******** 系统键盘做处理 ********
    //默认为YES，关闭为NO
    [IQKeyboardManager sharedManager].enable = YES;
    //键盘弹出时，点击背景，键盘收回
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //隐藏键盘上面的toolBar,默认是开启的
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
}

@end
