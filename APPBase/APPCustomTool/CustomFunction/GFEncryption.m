//
//  GFEncryption.m
//  GFAPP
//
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFEncryption.h"

#import "NSString+Hash.h"//哈希散列算法


@implementation GFEncryption


#pragma mark - md5
//小写16位
+ (NSString *)md5LowercaseString_16:(NSString *)string{
    return [NSString MD5ForLower16Bate:string];
}

//大写16位
+ (NSString *)md5UppercaseString_16:(NSString *)string{
    return [NSString MD5ForUpper16Bate:string];
}

//小写32位
+ (NSString *)md5LowercaseString_32:(NSString *)string{
    return [NSString MD5ForLower32Bate:string];
}

//大写32位
+ (NSString *)md5UppercaseString_32:(NSString *)string{
    return [NSString MD5ForUpper32Bate:string];
}




@end
