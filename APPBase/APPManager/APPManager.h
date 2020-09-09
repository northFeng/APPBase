//
//  APPManager.h
//  GFAPP
//  APP管理者
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//
/** 检查 项目中 IDFA 收集
 1、打开终端cd到要检查的文件的根目录。

 2、执行下列语句：grep -r advertisingIdentifier .   （别少了最后那个点号）。
 */

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "APPUserInfoModel.h"//用户信息Model

NS_ASSUME_NONNULL_BEGIN

@interface APPManager : NSObject

///状态栏高度
@property (nonatomic,assign) CGFloat stateHeight;

///APP内模式  0:所系统模式  1:白色模式  2:暗黑模式
@property (nonatomic,assign) NSInteger faceStyle;

/** 是否处于已登录状态 （动画不能用约束！！！） */
@property (atomic,strong,nullable) APPUserInfoModel *userInfo;


/** 是否处于已登录状态 */
@property (nonatomic, assign) BOOL isLogined;

/** 是否登录过期 */
@property (nonatomic,assign) BOOL isLoginOverdue;

///APP内获取的纬度
@property (nonatomic,copy) NSString *localLatitude;

///APP内获取的经度
@property (nonatomic,copy) NSString *localLongitude;

///默认地址信息model
@property (nonatomic,strong,nullable) APPDefautlLocalInfo *defaultLoacalInfo;

///是否也设置默认地址
@property (nonatomic,assign) BOOL isSetDefaulLoacl;


// 二期改版添加

///本地已存订单数量
@property (nonatomic,assign) NSInteger loacalOrderCount;

///线上新版本号
@property (nonatomic,copy) NSString *appstoreVersion;

///线上新版本号
@property (nonatomic,copy,nullable) NSString *serviceVersionStr;


/**
 *  APP管理者单例
 */
+ (APPManager *)sharedInstance;

///状态栏高度
+ (CGFloat)stateHeight;

///存储用户信息
- (void)storUserInfo:(NSDictionary *)userInfoDic;

///存储默认地址信息
- (void)storeDefaultLocalInfoWithDic:(NSDictionary *)defaultLocalInfo;

///清除默认地址
- (void)clearDefaultLoacalInfo;

///清楚用户信息
- (void)clearUserInfo;

//设置屏幕竖屏（默认）
- (void)setScreenInterfaceOrientationDefault;

/**
   主动退出
   @prame index 显示TabBar切换的位置显示
 */
- (void)forcedExitUserWithShowControllerItemIndex:(NSInteger)index;


///清楚URL缓存和web中产生的cookie
- (void)cleanCacheAndCookie;


///iPad比例适配
+ (CGFloat)iPhoneAndIpadTextAdapter;

///大小适配
+ (CGFloat)iPhoneAndIpadTextAdapter:(CGFloat)size;

@end


NS_ASSUME_NONNULL_END
