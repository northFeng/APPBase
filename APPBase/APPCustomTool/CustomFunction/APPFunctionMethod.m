//
//  APPFunctionMethod.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/26.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "APPFunctionMethod.h"

@implementation APPFunctionMethod

///字符串转换对应的对象（数组/字典）
+ (id)jsonStringConversionToObject:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    /**
     NSJSONReadingMutableContainers = (1UL << 0),//返回可变容器，NSMutableDictionary或NSMutableArray。
     NSJSONReadingMutableLeaves = (1UL << 1),//返回的JSON对象中字符串的值为NSMutableString，目前在iOS 7上测试不好用，应该是个bug
     NSJSONReadingAllowFragments = (1UL << 2)//允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment。例如使用这个选项可以解析 @“123” 这样的字符串。
     */
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers
                                                      error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return jsonObject;
}

///对象转换成字符串
+ (NSString *)jsonObjectConversionToString:(id)jsonObject{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&parseError];
    
    if (parseError) {
        return  nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - array数组操作方法
///数组的升序
+ (void)array_ascendingSortWithMutableArray:(NSMutableArray *)oldArray{
    
    
    //    [oldArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    
    //        APPBoughtInfoModel *bookInfo1 = (APPBoughtInfoModel *)obj1;
    //        APPBoughtInfoModel *bookInfo2 = (APPBoughtInfoModel *)obj2;
    //        double a = [bookInfo1.operateTime integerValue];
    //        double b = [bookInfo2.operateTime integerValue];
    //        if (a < b) {
    //            return NSOrderedDescending;
    //        } else if (a > b) {
    //            return NSOrderedAscending;
    //        } else {
    //            return NSOrderedSame;
    //        }
    //    }];
    
}

///数组降序
+ (void)array_descendingSortWithMutableArray:(NSMutableArray *)oldArray{
    
    
    
}

#pragma mark - base64编码
///编码字符串--->base64字符串
+ (NSString *)base64_encodeBase64StringWithString:(NSString *)encodeStr{
    
    NSData *encodeData = [encodeStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Str = [encodeData base64EncodedStringWithOptions:0];
    
    return base64Str;
}

///编码字符串--->base64data
+ (NSString *)base64_encodeBase64StringWithData:(NSData *)encodeData{
    
    NSString *encodeStr = [encodeData base64EncodedStringWithOptions:0];
    
    return encodeStr;
}

///解码----->原字符串
+ (NSString *)base64_decodeBase64StringWithBase64String:(NSString *)base64Str{
    
    NSString *decodeStr = [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:base64Str options:0] encoding:NSUTF8StringEncoding];
    
    return decodeStr;
}

///解码----->原Data
+ (NSData *)base64_decodeBase64DataWithBase64Data:(NSData *)base64Data{
    
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedData:base64Data options:0];
    
    return decodeData;
}

///字符串编码
+ (NSString *)string_encodeWithString:(NSString *)string {
    
    //编码
    NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];

    return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

///字符串解码
+ (NSString *)string_deCodeWithString:(NSString *)string {
    
    //解码
    return [string stringByRemovingPercentEncoding];
}

///手机号处理
+ (NSString *)string_getPrivacyPhoneNumFromMobileStr:(NSString *)mobileStr {
    
    NSString *newStr = @"";
    
    if (mobileStr.length >= 11) {
        newStr = [NSString stringWithFormat:@"%@****%@",[mobileStr substringToIndex:3],[mobileStr substringWithRange:NSMakeRange(7, 4)]];
    }
    
    return newStr;
}

#pragma mark - 字体操作
///设置字体
+ (UIFont *)font_setFontWithPingFangSC:(NSString *)fontName size:(NSInteger)size{
    
    NSString *fontString = [NSString stringWithFormat:@"PingFangSC-%@",fontName];
    UIFont *font = [UIFont fontWithName:fontString size:size];
    return font;
}


///获取富文本文字(系统默认间距)
+ (NSAttributedString *)string_getAttributeStringWithString:(NSString *)text textFont:(UIFont *)font textColor:(UIColor *)color;{
    
    text = text.length > 0 ? text : @"";
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    return attrString;
}


///获取富文本文字（设置行间距）
+ (NSAttributedString *)string_getAttributeStringWithString:(NSString *)text textFont:(UIFont *)font textColor:(UIColor *)color lineSpace:(CGFloat)lineSpace textAlignment:(NSTextAlignment)textAlignment{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;// 字体的行间距
    paragraphStyle.alignment = textAlignment;//NSTextAlignmentJustified;//两端对齐
    
    text = text.length > 0 ? text : @"";
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paragraphStyle}];
    
    return attrString;
}

///数据字符串处理
+ (NSString *)string_handleNull:(NSString *)string{
    
    if ([string isKindOfClass:[NSNull class]] || string.length == 0) {
        
        string = @"";//自定义无数据提示语
    }
    return  string;
}


///获取文字的高度
+ (CGFloat)string_getTextHeight:(NSString *)text textFont:(UIFont *)font lineSpacing:(CGFloat)lineSpace textWidth:(CGFloat)textWidth{
    text = text.length > 0 ? text : @"";
    CGFloat height = 0.;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;// 字体的行间距
    paragraphStyle.alignment = NSTextAlignmentJustified;//两端对齐
    CGSize cellSize = [text boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil] context:nil].size;
    
    height = cellSize.height;//cellSize.height > 55.5 ? 55.5 : cellSize.height;
    
    return height;
}

///获取文字的宽度
+ (CGFloat)string_getTextWidth:(NSString *)text textFont:(UIFont *)font lineSpacing:(CGFloat)lineSpace textHeight:(CGFloat)textHeight{
    text = text.length > 0 ? text : @"";
    CGFloat width = 0.;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0;//lineSpace;// 字体的行间距
    CGSize cellSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, textHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil] context:nil].size;
    //[self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size
    width = cellSize.width;//cellSize.height > 55.5 ? 55.5 : cellSize.height;
    
    return width+1;//适配iOS10，必须多一点
}

/**
 获取指定的属性字符串(标准型！)
 param:font --字体大小
 param:lineHeight -- 行高
 textWeight: 0，标准字体 1:粗体
 */
+ (NSMutableAttributedString *)string_getAttributedStringWithString:(NSString *)textString textFont:(CGFloat)font textLineHeight:(CGFloat)lineHeight textWight:(NSInteger)textWeight{
    textString = textString.length > 0 ? textString : @"";
    //label必须设置 [label sizeToFit];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (lineHeight > 0) {
        paragraphStyle.lineSpacing = lineHeight - font;
    }
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSDictionary *dictionaryAttrbuted;
    if (textWeight) {
        //粗体
        dictionaryAttrbuted = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:font],NSParagraphStyleAttributeName:paragraphStyle};
    }else{
        dictionaryAttrbuted = @{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paragraphStyle};
    }
    
    NSMutableAttributedString *attributedString;
    if (textString.length) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:textString attributes:dictionaryAttrbuted];
    }else{
        attributedString = [[NSMutableAttributedString alloc] initWithString:@"暂无内容" attributes:dictionaryAttrbuted];
    }
    
    
    return attributedString;
}

///获取文字段内指定文字所有的范围集合
+ (NSArray *)string_getSameStringRangeArray:(NSString *)superString andAppointString:(NSString *)searchString{
    
    NSMutableArray *arrayRange = [NSMutableArray array];
    NSRange searchRange = NSMakeRange(0, superString.length);
    NSRange range = NSMakeRange(0, 0);
    
    //无限循环处理 找 位置
    while(range.location != NSNotFound && searchRange.location < superString.length)
    {
        //NSStringCompareOptions
        range = [superString rangeOfString:searchString options:NSCaseInsensitiveSearch range:searchRange];
        if (range.location != NSNotFound)
        {
            searchRange.location = range.location + range.length;
            searchRange.length = superString.length - searchRange.location;
            NSRange rangeTwo = range;
            [arrayRange addObject:[NSValue valueWithRange:rangeTwo]];
        }
    }
    
    return [arrayRange copy];
}

///合并富文本字符串
+ (NSMutableAttributedString *)string_getMergeAttributedStringWithHeadString:(NSString *)headString headStringFont:(NSInteger)headFont headTextIsBlod:(NSInteger)headBlod headStringColor:(UIColor *)headColor endString:(NSString *)endString endStringFont:(NSInteger)endFont endTextIsBlod:(NSInteger)endBlod endStringColor:(UIColor *)endColor{
    
    headString = headString.length > 0 ? headString : @"";
    endString = endString.length > 0 ? endString : @"";
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",headString,endString]];
    
    UIFont *headfont = headBlod == 0 ? [UIFont systemFontOfSize:headFont] : [UIFont boldSystemFontOfSize:headFont] ;
    UIFont *endfont = endBlod == 0 ? [UIFont systemFontOfSize:endFont] : [UIFont boldSystemFontOfSize:endFont] ;
    
    NSDictionary *headDic = @{NSFontAttributeName:headfont,NSForegroundColorAttributeName:headColor};
    NSDictionary *endDic = @{NSFontAttributeName:endfont,NSForegroundColorAttributeName:endColor};
    
    [attributeString addAttributes:headDic range:NSMakeRange(0, headString.length)];
    [attributeString addAttributes:endDic range:NSMakeRange(headString.length, endString.length)];
    
    return attributeString;
}

///合并富文本字符 —— 特殊文字在中间
+ (NSAttributedString *)string_getMergeAttributedStringWithHeadString:(NSString *)headString headStringFont:(UIFont *)headFont headStringColor:(UIColor *)headColor middleString:(NSString *)middleStr middleStrFont:(UIFont *)middleFont middleStrColor:(UIColor *)middleColor endString:(NSString *)endString endStringFont:(UIFont *)endFont endStringColor:(UIColor *)endColor{
    
    headString = headString.length > 0 ? headString : @"";
    middleStr = middleStr.length > 0 ? middleStr : @"";
    endString = endString.length > 0 ? endString : @"";
    
    NSMutableAttributedString *headAttrStr = [[NSMutableAttributedString alloc] initWithString:headString attributes:@{NSFontAttributeName:headFont,NSForegroundColorAttributeName:headColor}];
    
    NSAttributedString *middleAttrStr = [[NSAttributedString alloc] initWithString:middleStr attributes:@{NSFontAttributeName:middleFont,NSForegroundColorAttributeName:middleColor}];
    
    NSAttributedString *endAtrrStr = [[NSAttributedString alloc] initWithString:endString attributes:@{NSFontAttributeName:endFont,NSForegroundColorAttributeName:endColor}];
    
    [headAttrStr appendAttributedString:middleAttrStr];
    [headAttrStr appendAttributedString:endAtrrStr];
    
    return headAttrStr;
}





///获取唯一标识符字符串
+ (NSString *)string_getUUIDString{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    NSString *uuidString = [(__bridge NSString *)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}

///把字符串 以中间空格拆分 得到 数组
+ (NSArray *)string_getArrayWithNoSpaceString:(NSString *)string{
    NSArray *arrayOne = [string componentsSeparatedByString:@" "];
    
    NSMutableArray *arrayTwo = [NSMutableArray array];
    
    for (NSString *wordString in arrayOne) {
        
        if (wordString.length>0) {
            
            [arrayTwo addObject:wordString];
        }
    }
    
    return [arrayTwo copy];
}

///获取去除字符串的首位空格
+ (NSString *)string_getStringWithRemoveFrontAndRearSpacesByString:(NSString *)oldString{
    NSString *newString = [oldString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return newString;
}

///去除字符串的标点符号
+ (NSString *)string_getStringFilterPunctuationByString:(NSString *)string{
    
    //去除标点符号
    NSString *newString = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]] componentsJoinedByString:@""];
    
    return newString;
}

///判断字符串是否含有表情符号
+ (BOOL)string_getStringIsOrNotContainEmojiByString:(NSString *)string{
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
    
}

///去除字符串中的表情符号
+ (NSString *)string_getStringFilterEmojiByString:(NSString *)string{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string
                                                               options:0
                                                                 range:NSMakeRange(0, [string length])
                                                          withTemplate:@""];
    return modifiedString;
}



///处理高亮文字
+ (NSMutableAttributedString *)string_getHighLigntText:(NSString *)hightText hightFont:(NSInteger)hifhtFont hightColor:(UIColor *)hightColor hightTextIsBlod:(BOOL)isHightBlod totalStirng:(NSString *)totalStirng defaultFont:(NSInteger)defaultFont defaultColor:(UIColor *)defaultColor defaultTextIsBlod:(BOOL)defaultIsBlod{
    
    NSArray *arrayTotal;
    if (hightText.length > 0) {
        arrayTotal = [self string_getSameStringRangeArray:totalStirng andAppointString:hightText];
    }
    
    NSDictionary *dicHight;
    if (isHightBlod) {
        dicHight = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:hifhtFont],NSForegroundColorAttributeName:hightColor};
    }else{
        dicHight = @{NSFontAttributeName:[UIFont systemFontOfSize:hifhtFont],NSForegroundColorAttributeName:hightColor};
    }
    
    NSDictionary *defaultDic;
    if (defaultIsBlod) {
        defaultDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:defaultFont],NSForegroundColorAttributeName:defaultColor};
    }else{
        defaultDic = @{NSFontAttributeName:[UIFont systemFontOfSize:defaultFont],NSForegroundColorAttributeName:defaultColor};
    }
    
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:totalStirng attributes:defaultDic];
    
    for (NSValue *rangValue in arrayTotal) {
        //字段
        NSRange range = [rangValue rangeValue];
        [attrString addAttributes:dicHight range:range];
    }
    
    return attrString;
}


///获取图片附件富文本
+ (NSMutableAttributedString *)string_getAttachmentStringWithString:(NSMutableAttributedString *)mutableString image:(UIImage *)image imageRect:(CGRect)imgRect index:(NSInteger)index{
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    
    //附件的frame，图层绘制是倒置的 ————> 左下角为原点
    attach.bounds = imgRect;
    
    attach.image = image;
    NSAttributedString *strAttach = [NSAttributedString attributedStringWithAttachment:attach];
    
    if (index == -1) {
        [mutableString appendAttributedString:strAttach];
    }else{
        [mutableString insertAttributedString:strAttach atIndex:index];
    }
    return mutableString;
}

///金钱分转换
+ (NSString *)string_moneyStringToIntegerOrFloatWIthMoney:(NSInteger)moneyInt{
    
    NSString *newStr;
    
    if (moneyInt % 100 == 0) {
        newStr = [NSString stringWithFormat:@"%ld",moneyInt / 100];
    }else{
        newStr = [NSString stringWithFormat:@"%.2f",moneyInt / 100.];
    }
    
    
    return newStr;
}

/**
 查找子字符串在父字符串中的所有位置
 @param contentStr 父字符串
 @param word 子字符串
 @return 返回位置数组
 */
+ (NSArray *)string_getCalculateSubStringCount:(NSString *)contentStr str:(NSString *)word {
    
    NSMutableArray *locationArr = [NSMutableArray new];
    NSRange range = [contentStr rangeOfString:word];
    if (range.location == NSNotFound){
        return locationArr;
    }
    //声明一个临时字符串,记录截取之后的字符串
    NSString *subStr = contentStr;
    
    
//    while (range.location != NSNotFound) {
//        if (location == 0) {
//            location += range.location;
//        } else {
//            location += range.location + word.length;
//        }
//        //记录位置
//        NSNumber *number = [NSNumber numberWithUnsignedInteger:location];
//        [locationArr addObject:number];
//        //每次记录之后,把找到的字串截取掉
//        subStr = [subStr substringFromIndex:range.location + range.length];
//
//        NSLog(@"subStr %@",subStr);
//        range = [subStr rangeOfString:word];
//        NSLog(@"rang %@",NSStringFromRange(range));
//    }
    
    NSUInteger location = 0;
    NSUInteger limNum = 0;
    
    while (range.location != NSNotFound) {
                
        location = limNum;
        if (location == 0) {
            location = range.location;
        }
        
        //记录位置
        NSNumber *number = [NSNumber numberWithUnsignedInteger:location];
        [locationArr addObject:number];
        
        
        //每次记录之后,把找到的字串截取掉
        subStr = [subStr substringFromIndex:range.location + range.length];
        
        range = [subStr rangeOfString:word];//截取的字符串 的 新位置
        
        limNum = range.location + (location + word.length);
    }
    
    return [locationArr copy];
}


///获取混合富文本字符串 （搜索显示）
+ (NSAttributedString *)string_getAttributedStringFromContent:(NSString *)content word:(NSString *)word font:(UIFont *)font normalColor:(UIColor *)normalColor selectClocor:(UIColor *)selectColor {
    
    NSArray *localArray = [self string_getCalculateSubStringCount:content str:word];
    
    NSMutableAttributedString *totalString = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:normalColor}];
    
    for (NSNumber *localtionNum in localArray) {
        
        [totalString setAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:selectColor} range:NSMakeRange(localtionNum.intValue, word.length)];
    }
    
    return totalString;
}

#pragma mark - 加载图片 && GIF
///加载图片
+ (void)img_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholderImgName imgView:(UIImageView *)imgView{
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:placeholderImgName] options:SDWebImageRetryFailed];
}

///加载动画
+ (void)img_setImageWithGifName:(NSString *)gifName imgView:(UIImageView *)imgView{
    NSString *path;
    if ([gifName hasSuffix:@"gif"]) {
        gifName = [gifName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
    }
    path = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
    
    //NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = nil;//[UIImage sd_animatedGIFWithData:data];
    imgView.image = image;
}



#pragma mark - 创建定时器
+ (void)timer_createTimerToViewController:(UIViewController *)VCSelf selector:(SEL)aSelector{
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:VCSelf selector:aSelector userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //开启
    //[timer setFireDate:[NSDate distantPast]];
    //暂停
    [timer setFireDate:[NSDate distantFuture]];
    //销毁定时器
    //    [timer invalidate];
    //    timer = nil;
    
}


#pragma mark - u判断URL是否有效
///判断url是否可链接成功
+ (BOOL)url_ValidateUrIsLinkSuccessForUrl:(NSString *)urlStr{
    
    //发送请求
    NSString *url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2];
    //HEAD请求（不请求数据，只请求数据的状态信息）
    [request setHTTPMethod:@"HEAD"];
    
    //响应头:连接的状态，建立链接的时间
    //NSHTTPURLResponse *response;
    //NSError *error;
    //data是请求回来的具体数据内容
    //[NSURLConnection sendSynchronousRequest:request11 returningResponse:&response error:&error];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request];
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)dataTask.response;
    //200成功访问地址
    if ((response.statusCode/100) == 2) {
        return YES;
    }else{
        return NO;
    }
    
}

/**
 * 网址正则验证 1或者2使用哪个都可以
 *
 *  @param string 要验证的字符串
 *
 *  @return 返回值类型为BOOL
 */
+ (BOOL)url_ValidationUrlForUrlString:(NSString *)string{
    NSError *error;
    // 正则1
    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    // 正则2
    //regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        [string substringWithRange:match.range];
        //NSString *substringForMatch = [string substringWithRange:match.range];
        //NSLog(@"匹配");
        return YES;
    }
    
    return NO;
}

#pragma mark - v视图操作

///添加输入框
+ (UITextField *)view_createTextFieldWithPlaceholder:(NSString *)placeholderStr holderStrFont:(UIFont *)holderFont holderColor:(UIColor *)holderColor textFont:(UIFont *)textFont textColor:(UIColor *)textColor keyboardType:(UIKeyboardType)keyboardType returnKeyType:(UIReturnKeyType)returnKeyType{
    
    UITextField *tfield = [[UITextField alloc] init];
    tfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderStr attributes:@{NSFontAttributeName:holderFont,NSForegroundColorAttributeName:holderColor}];
    tfield.font = textFont;
    tfield.textColor = textColor;
    tfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfield.keyboardType = keyboardType;
    tfield.returnKeyType = returnKeyType;
    //监测输入变化
    //[tfield addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    return tfield;
}

///创建无限按钮模式
+ (NSMutableArray *)view_createManyBtnViewWithSpaceLeft:(CGFloat)spaceLeft spaceBetween:(CGFloat)spaceBetween spaceRight:(CGFloat)spaceRight spacetopBottom:(CGFloat)spaceTB spaceTop:(CGFloat)spaceTop maxViewWidth:(CGFloat)maxWidth btnWidth:(CGFloat)btnWidth btnHeight:(CGFloat)btnHeight btnCount:(NSInteger)btnCount{
    
    NSMutableArray *arrayBtn = [NSMutableArray array];
    
    for (int i = 0; i < btnCount; i++) {
        
        UIButton *btnBefore;//上一个按钮
        if (i > 0) {
            btnBefore = [arrayBtn lastObject];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = 1000 + i;
        //btn.backgroundColor = APPColor_White;
        
        if (btnBefore) {
            if ((CGRectGetMaxX(btnBefore.frame) + (spaceBetween + btnWidth) + spaceRight) > maxWidth) {
                //到下一行
                btn.frame = CGRectMake(spaceLeft, CGRectGetMaxY(btnBefore.frame) + spaceTB, btnWidth, btnHeight);
            }else{
                //同行
                btn.frame = CGRectMake(CGRectGetMaxX(btnBefore.frame) + spaceBetween, CGRectGetMinY(btnBefore.frame), btnWidth, btnHeight);
            }
            
        }else{
            //第一个按钮
            btn.frame = CGRectMake(spaceLeft + (btnWidth + spaceBetween)*i, spaceTop, btnWidth, btnHeight);
        }
        
        
        //[self addSubview:btn];
        
        [arrayBtn addObject:btn];
        
    }
    
    return arrayBtn;
}


#pragma mark - 16进制字符串与16进制之间的转换
//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}


// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
}


#pragma mark - 打电话
+ (void)tell_phoneWithNum:(NSString *)phoneNum{
    
    NSString *callPhone = [NSString stringWithFormat:@"tel://%@",phoneNum];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        // Fallback on earlier versions
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}



@end
