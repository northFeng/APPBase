//
//  APPLog.h
//  APPBase
//
//  Created by v_gaoyafeng on 2020/12/7.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPLog : NSObject

///初始化Log配置
+ (void)initDDLogConfiguration;

/// 输出
+ (void)logString:(NSString *)info;


@end

NS_ASSUME_NONNULL_END
