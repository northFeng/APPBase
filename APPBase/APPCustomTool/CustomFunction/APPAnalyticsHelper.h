//
//  APPAnalyticsHelper.h
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/26.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPAnalyticsHelper : NSObject

//跟踪VC页面 （进入跟离开viewController）
+ (void)analyticsViewController;

///设置键盘弹出
+ (void)setKeyBoardlayout;

@end

NS_ASSUME_NONNULL_END
