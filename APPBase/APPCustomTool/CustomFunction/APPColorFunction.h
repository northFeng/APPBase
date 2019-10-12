//
//  APPColorFunction.h
//  APPBase
//  颜色功能类
//  Created by 峰 on 2019/10/10.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPColorFunction : NSObject

/**
 颜色值转换为Color

 @param stringToConvert 16进制的值比如：0x646364
 @param alpha 透明度
 @return 返回UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;

///动态颜色
+ (UIColor *)dynamicColorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;

@end

NS_ASSUME_NONNULL_END
