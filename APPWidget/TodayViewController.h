//
//  TodayViewController.h
//  APPWidget
//
//  Created by 峰 on 2020/9/9.
//  Copyright © 2020 ishansong. All rights reserved.
//
/**
 顺便说一句，扩展程序虽然是程序的扩展，但是这两个应用其实是“独立”的。准确的来说，它们是两个独立的进程，默认情况下互相不应该知道对方的存在。扩展需要对宿主 app (host app，即调用该扩展的 app) 的请求做出响应，当然，通过进行配置和一些手段，我们可以在扩展中访问和共享一些容器 app 的资源，这个我们稍后再说。
 */

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController

@end
