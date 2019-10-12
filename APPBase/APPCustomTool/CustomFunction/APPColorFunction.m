//
//  APPColorFunction.m
//  APPBase
//
//  Created by 峰 on 2019/10/10.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPColorFunction.h"

@implementation APPColorFunction

/**
 *    @brief  颜色值转换为Color
 *
 *  @stringToConvert  16进制的值比如：646364
 *
 *    @return 返回UIColor
 */
+ (UIColor *)colorWithHexString:(NSString*)stringToConvert alpha:(CGFloat)alpha {
    
    stringToConvert = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range = (NSRange){0, 2};
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

///动态颜色
+ (UIColor *)dynamicColorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
    
    //UITraitCollection.currentTraitCollection.userInterfaceStyle;
    UIColor *color = lightColor;
    if (@available(iOS 13.0, *)) {
        color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return lightColor;
            }else if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
                return darkColor;
            }else{
                return lightColor;
            }
        }];
    }
    
    return color;
}


@end
