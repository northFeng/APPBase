//
//  NSString+TextSize.m
//  APPBase
//
//  Created by 峰 on 2019/10/12.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "NSString+TextSize.h"


@implementation NSString (TextSize)

- (NSString *(^)(NSString *))append {
    return ^NSString *(NSString * str){
        if (!str) {
            return self;
        }
        return [self stringByAppendingString:str];
    };
}

///获取文字的宽度
- (CGFloat)string_getTextWidthWithTextFont:(UIFont *)font lineSpacing:(CGFloat)lineSpace textHeight:(CGFloat)textHeight{
    
    CGFloat width = 0.;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0;//lineSpace;// 字体的行间距
    CGSize cellSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, textHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil] context:nil].size;
    //[self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size
    width = cellSize.width;//cellSize.height > 55.5 ? 55.5 : cellSize.height;
    
    return width+1;//适配iOS10，必须多一点
}

///获取文字的高度
- (CGFloat)string_getTextHeightWithTextFont:(UIFont *)font lineSpacing:(CGFloat)lineSpace textWidth:(CGFloat)textWidth{
    
    CGFloat height = 0.;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;// 字体的行间距
    paragraphStyle.alignment = NSTextAlignmentJustified;//两端对齐
    CGSize cellSize = [self boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil] context:nil].size;
    
    height = cellSize.height;
    
    return height;
}

- (NSAttributedString *)string_getAttributeStringWithFont:(UIFont *)font textColor:(UIColor *)textColor lingSpacing:(CGFloat)lineSpace{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;// 字体的行间距
    paragraphStyle.alignment = NSTextAlignmentJustified;//两端对齐
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *dictionaryAttrbuted = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:textColor};
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[self copy] attributes:dictionaryAttrbuted];
    
    return attributedString;
}


@end
