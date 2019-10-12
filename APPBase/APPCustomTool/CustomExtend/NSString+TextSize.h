//
//  NSString+TextSize.h
//  APPBase
//  文字尺寸扩展
//  Created by 峰 on 2019/10/12.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TextSize)

/**
 拼接字符串
 */
- (NSString *(^)(NSString *))append;

///获取文字的宽度
- (CGFloat)string_getTextWidthWithTextFont:(UIFont *)font lineSpacing:(CGFloat)lineSpace textHeight:(CGFloat)textHeight;

///获取文字的高度
- (CGFloat)string_getTextHeightWithTextFont:(UIFont *)font lineSpacing:(CGFloat)lineSpace textWidth:(CGFloat)textWidth;

///获取富文本
- (NSAttributedString *)string_getAttributeStringWithFont:(UIFont *)font textColor:(UIColor *)textColor lingSpacing:(CGFloat)lineSpace;

@end

NS_ASSUME_NONNULL_END
