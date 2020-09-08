//
//  AppDelegate+RootConTroller.h
//  FlashRider
//  代理进行扩展 —— 根视图的设置
//  Created by gaoyafeng on 2018/11/21.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (RootConTroller)

/**
 *  根视图
 */
- (void)setRootViewController;


///添加3D touch功能，APP长按弹框
- (void)add3DTouch;

@end

NS_ASSUME_NONNULL_END
