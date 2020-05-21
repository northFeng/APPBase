//
//  APPDateTool.h
//  CleverBaby
//  时间工具
//  Created by 峰 on 2019/11/21.
//  Copyright © 2019 小神童. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPDateTool : NSObject

///获取当前时间@"yyyy-MM-dd HH:mm
+ (NSString *)date_getCurrentDateWithType:(NSString *)timeType;

///时间戳转换时间 timeStamp:时间戳（记得转化精度为秒） timeType:转换格式(@"yyyy-MM-dd  HH:mm:ss" / yyyy年MM月dd日)
+ (NSString *)date_getDateWithTimeStamp:(NSInteger)timeStamp timeType:(NSString *)timeType;

///获取当前时间戳 && 精度1000毫秒 1000000微妙 （注意5s以下的设备 32位处理器，时间戳会溢出，改成double类型来接受）
+ (NSInteger)date_getNowTimeStampWithPrecision:(NSInteger)precision;

///获取当前时间戳 && 精度1000毫秒 1000000微妙  字符串 （防止 32处理器设备移除）
+ (NSString *)date_getNowTimeStampStringWithPrecision:(NSInteger)precision;

///把日期数字换换成 年月日
+ (NSString *)date_getTimeString:(NSString *)timeString;

///把日期数字换换成 年月日 不带 ——
+ (NSString *)date_getTimeStringTwo:(NSString *)timeString;

///年月日字符转换时间时间戳 precision精度 1秒、1000毫秒、1000000微秒
+ (NSInteger)date_getTimeStampFormDateString:(NSString *)dateStr precision:(NSInteger)precision;

///年月日字符转换时间时间戳  timeType(时间格式 默认格式yyyy-MM-dd HH:mm:ss)    precision精度 1秒、1000毫秒、1000000微秒
+ (NSInteger)date_getTimeStampFormDateString:(NSString *)dateStr timeType:(NSString *)timeType precision:(NSInteger)precision;

///指定年月——>到现在的年月
+ (NSMutableArray *)date_getDateArrayToNowWithYear:(NSInteger)startYear startMonth:(NSInteger)startMonth;

@end

NS_ASSUME_NONNULL_END
