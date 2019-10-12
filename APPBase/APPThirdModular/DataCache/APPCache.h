//
//  APPCache.h
//  APPBase
//  数据存储管理
//  Created by 峰 on 2019/10/12.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPCache : NSObject

///存储
+ (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key;

///获取数据
+ (nullable id<NSCoding>)objectForKey:(NSString *)key;

///是否包含key
+ (BOOL)containsObjectForKey:(NSString *)key;

///移除某个数据
+ (void)removeObjectForKey:(NSString *)key;

///移除全部数据
+ (void)removeAllObjects;


@end

NS_ASSUME_NONNULL_END
