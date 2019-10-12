//
//  APPCache.m
//  APPBase
//
//  Created by 峰 on 2019/10/12.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPCache.h"

#import <YYCache/YYCache.h>

@implementation APPCache

///获取管理者
+ (YYCache *)appCacheManager {
    
    YYCache *cacheManager = [YYCache cacheWithName:@"AppCache"];
    
    return cacheManager;
}

///存储
+ (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key {
    
    YYCache *cacheManager = [self appCacheManager];
    [cacheManager setObject:object forKey:key];
}

///获取数据
+ (nullable id<NSCoding>)objectForKey:(NSString *)key {
    YYCache *cacheManager = [self appCacheManager];
    return [cacheManager objectForKey:key];
}

///是否包含key
+ (BOOL)containsObjectForKey:(NSString *)key {
    YYCache *cacheManager = [self appCacheManager];
    return [cacheManager containsObjectForKey:key];
}

///移除某个数据
+ (void)removeObjectForKey:(NSString *)key {
    YYCache *cacheManager = [self appCacheManager];
    [cacheManager removeObjectForKey:key];
}

///移除全部数据
+ (void)removeAllObjects {
    YYCache *cacheManager = [self appCacheManager];
    [cacheManager removeAllObjects];
}


@end
