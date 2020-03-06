//
//  AppDelegate.h
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/21.
//  Copyright © 2018 ishansong. All rights reserved.
//  swift混合开发版本

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

///是否允许屏幕旋转
@property (nonatomic,assign) BOOL allowRotate;

@property (strong, nonatomic) UIWindow *window;


/** 引导滑动图 */
@property (nonatomic,strong) UIScrollView *scrollerView;


@end

