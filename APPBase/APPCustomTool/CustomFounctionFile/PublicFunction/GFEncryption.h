//
//  GFEncryption.h
//  GFAPP
//  加密
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GFEncryption : NSObject

#pragma mark - 哈希算法
///小写16位
+ (NSString *)md5LowercaseString_16:(NSString *)string;

///大写16位
+ (NSString *)md5UppercaseString_16:(NSString *)string;

///小写32位
+ (NSString *)md5LowercaseString_32:(NSString *)string;

///大写32位
+ (NSString *)md5UppercaseString_32:(NSString *)string;





@end

NS_ASSUME_NONNULL_END
