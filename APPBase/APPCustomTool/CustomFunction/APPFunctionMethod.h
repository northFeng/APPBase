//
//  APPFunctionMethod.h
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/26.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPFunctionMethod : NSObject


#pragma mark - 数组与字符串之间的转换
///字符串转换对应的对象（数组/字典）
+ (id)jsonStringConversionToObject:(NSString *)jsonString;

///对象转换成字符串
+ (NSString *)jsonObjectConversionToString:(id)jsonObject;

#pragma mark - array数组操作方法
///数组的升序
+ (void)array_ascendingSortWithMutableArray:(NSMutableArray *)oldArray;

///数组降序
+ (void)array_descendingSortWithMutableArray:(NSMutableArray *)oldArray;

#pragma mark - base64编码
///编码字符串--->base64字符串
+ (NSString *)base64_encodeBase64StringWithString:(NSString *)encodeStr;

///编码字符串--->base64data
+ (NSString *)base64_encodeBase64StringWithData:(NSData *)encodeData;

///解码----->原字符串
+ (NSString *)base64_decodeBase64StringWithBase64String:(NSString *)base64Str;

///解码----->原Data
+ (NSData *)base64_decodeBase64DataWithBase64Data:(NSData *)base64Data;

#pragma mark - 字体操作
///设置字体
+ (UIFont *)font_setFontWithPingFangSC:(NSString *)fontName size:(NSInteger)size;

#pragma mark - 加载图片 && GIF
///加载图片
+ (void)img_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholderImgName imgView:(UIImageView *)imgView;

///加载动画
+ (void)img_setImageWithGifName:(NSString *)gifName imgView:(UIImageView *)imgView;


#pragma mark - s字符串操作

///获取富文本文字(系统默认行间距)
+ (NSAttributedString *)string_getAttributeStringWithString:(NSString *)text textFont:(UIFont *)font textColor:(UIColor *)color;


///获取富文本文字（设置行间距）
+ (NSAttributedString *)string_getAttributeStringWithString:(NSString *)text textFont:(UIFont *)font textColor:(UIColor *)color lineSpace:(CGFloat)lineSpace textAlignment:(NSTextAlignment)textAlignment;

///数据字符串处理
+ (NSString *)string_handleNull:(NSString *)string;

///获取文字的高度
+ (CGFloat)string_getTextHeight:(NSString *)text textFont:(UIFont *)font lineSpacing:(CGFloat)lineSpace textWidth:(CGFloat)textWidth;

///获取文字的宽度
+ (CGFloat)string_getTextWidth:(NSString *)text textFont:(UIFont *)font lineSpacing:(CGFloat)lineSpace textHeight:(CGFloat)textHeigh;

/**
 获取指定的属性字符串(标准型！)
 param:font --字体大小
 param:lineHeight -- 行高
 textWeight: 0，标准字体 1:粗体
 */
+ (NSMutableAttributedString *)string_getAttributedStringWithString:(NSString *)textString textFont:(CGFloat)font textLineHeight:(CGFloat)lineHeight textWight:(NSInteger)textWeight;

///获取文字段内指定文字所有的范围集合
+ (NSArray *)string_getSameStringRangeArray:(NSString *)superString andAppointString:(NSString *)searchString;

///合并富文本字符串
+ (NSMutableAttributedString *)string_getMergeAttributedStringWithHeadString:(NSString *)headString headStringFont:(NSInteger)headFont headTextIsBlod:(NSInteger)headBlod headStringColor:(UIColor *)headColor endString:(NSString *)endString endStringFont:(NSInteger)endFont endTextIsBlod:(NSInteger)endBlod endStringColor:(UIColor *)endColor;

///合并富文本字符 —— 特殊文字在中间
+ (NSAttributedString *)string_getMergeAttributedStringWithHeadString:(NSString *)headString headStringFont:(UIFont *)headFont headStringColor:(UIColor *)headColor middleString:(NSString *)middleStr middleStrFont:(UIFont *)middleFont middleStrColor:(UIColor *)middleColor endString:(NSString *)endString endStringFont:(UIFont *)endFont endStringColor:(UIColor *)endColor;

///获取唯一标识符字符串
+ (NSString *)string_getUUIDString;

///把字符串 以中间空格拆分 得到 数组
+ (NSArray *)string_getArrayWithNoSpaceString:(NSString *)string;

///获取去除字符串的首位空格
+ (NSString *)string_getStringWithRemoveFrontAndRearSpacesByString:(NSString *)oldString;

///去除字符串的标点符号
+ (NSString *)string_getStringFilterPunctuationByString:(NSString *)string;

///判断字符串是否含有表情符号
+ (BOOL)string_getStringIsOrNotContainEmojiByString:(NSString *)string;

///去除字符串中的表情符号
+ (NSString *)string_getStringFilterEmojiByString:(NSString *)string;

///处理高亮文字
+ (NSMutableAttributedString *)string_getHighLigntText:(NSString *)hightText hightFont:(NSInteger)hifhtFont hightColor:(UIColor *)hightColor hightTextIsBlod:(BOOL)isHightBlod totalStirng:(NSString *)totalStirng defaultFont:(NSInteger)defaultFont defaultColor:(UIColor *)defaultColor defaultTextIsBlod:(BOOL)defaultIsBlod;

/**
 *  @brief 获取图片附件富文本
 *
 *  @param mutableString 需要拼接的富文本字符串
 *  @param image 转换富文本的图片
 *  @param imgRect 图片的rect
 *  @param index 图片要插入的富文本字符串位置(-1为默认直接拼接后面)
 *  @return NSMutableAttributedString 返回拼接的富文本
 */
+ (NSMutableAttributedString *)string_getAttachmentStringWithString:(NSMutableAttributedString *)mutableString image:(UIImage *)image imageRect:(CGRect)imgRect index:(NSInteger)index;

///金钱分转换
+ (NSString *)string_moneyStringToIntegerOrFloatWIthMoney:(NSInteger)moneyInt;

#pragma mark - 创建定时器 （一定要在delloc执行之前进行释放定时器，否则定时器不会销毁）
+ (void)timer_createTimerToViewController:(UIViewController *)VCSelf selector:(SEL)aSelector;


#pragma mark - u判断URL是否有效
///判断url是否可链接成功
+ (BOOL)url_ValidateUrIsLinkSuccessForUrl:(NSString *)urlStr;

/**
 * 网址正则验证 1或者2使用哪个都可以
 *
 *  @param string 要验证的字符串
 *
 *  @return 返回值类型为BOOL
 */
+ (BOOL)url_ValidationUrlForUrlString:(NSString *)string;

///添加输入框
+ (UITextField *)view_createTextFieldWithPlaceholder:(NSString *)placeholderStr holderStrFont:(UIFont *)holderFont holderColor:(UIColor *)holderColor textFont:(UIFont *)textFont textColor:(UIColor *)textColor keyboardType:(UIKeyboardType)keyboardType returnKeyType:(UIReturnKeyType)returnKeyType;

///创建无限按钮模式 spaceLeft:左边间距 spaceBetween:按钮中间间距 spaceRight:右边间距  spaceTB:按钮上下间距 spaceTop:上边间距 maxWidth:添加视图最大宽度 btnCount:按钮数量
+ (NSMutableArray *)view_createManyBtnViewWithSpaceLeft:(CGFloat)spaceLeft spaceBetween:(CGFloat)spaceBetween spaceRight:(CGFloat)spaceRight spacetopBottom:(CGFloat)spaceTB spaceTop:(CGFloat)spaceTop maxViewWidth:(CGFloat)maxWidth btnWidth:(CGFloat)btnWidth btnHeight:(CGFloat)btnHeight btnCount:(NSInteger)btnCount;


#pragma mark - 打电话
+ (void)tell_phoneWithNum:(NSString *)phoneNum;


#pragma mark - 接口请求
///post请求一个字典
+ (void)postRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(void(^)(BOOL result, id idObject))block;

///get请求一个字典
+ (void)getRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(void(^)(BOOL result, id idObject))block;




@end

NS_ASSUME_NONNULL_END
