//
//  APPDateTool.m
//  CleverBaby
//
//  Created by 峰 on 2019/11/21.
//  Copyright © 2019 小神童. All rights reserved.
//

#import "APPDateTool.h"

@implementation APPDateTool

///获取当前时间@"yyyy-MM-dd HH:mm
+ (NSString *)date_getCurrentDateWithType:(NSString *)timeType{
    //获取当前时间
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:timeType];
    NSString *timeString=[dateformatter stringFromDate:senddate];
    
    return timeString;
}

///时间戳转换时间 timeStamp:时间戳（记得转化精度为秒） timeType:转换格式(@"yyyy-MM-dd  HH:mm:ss" / yyyy年MM月dd日)
+ (NSString *)date_getDateWithTimeStamp:(NSInteger)timeStamp timeType:(NSString *)timeType{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:timeType];
    
    NSString *timeString=[dateformatter stringFromDate:date];
    
    return timeString;
}

///获取当前时间戳 && 精度1000毫秒 1000000微妙
+ (NSInteger)date_getNowTimeStampWithPrecision:(NSInteger)precision{
    
    NSDate *date = [NSDate date];
    
    NSTimeInterval nowTime = date.timeIntervalSince1970 * precision;
    
    NSInteger nowStamp = nowTime / 1;
    
    return nowStamp;
}

///把日期数字换换成 年月日
+ (NSString *)date_getTimeString:(NSString *)timeString{
    //,[timeString substringWithRange:NSMakeRange(6, 2)]
    NSString *time = [NSString stringWithFormat:@"%@-%@-%@",[timeString substringToIndex:4],[timeString substringWithRange:NSMakeRange(4, 2)],[timeString substringWithRange:NSMakeRange(6, 2)]];
    
    return time;
}

///把日期数字换换成 年月日 不带 ——
+ (NSString *)date_getTimeStringTwo:(NSString *)timeString{
    //,[timeString substringWithRange:NSMakeRange(6, 2)]
    NSString *time = [NSString stringWithFormat:@"%@年%@月",[timeString substringToIndex:4],[timeString substringWithRange:NSMakeRange(4, 2)]];
    
    return time;
}

///年月日字符转换时间时间戳 precision精度 1秒、1000毫秒、1000000微秒 (默认格式yyyy-MM-dd HH:mm:ss)
+ (NSInteger)date_getTimeStampFormDateString:(NSString *)dateStr precision:(NSInteger)precision{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateTime = [dateFormatter dateFromString:dateStr];
    
    NSTimeInterval timeNum = dateTime.timeIntervalSince1970 * precision;
    
    NSInteger time = timeNum / 1;
    
    return time;
}

///年月日字符转换时间时间戳  timeType(时间格式 默认格式yyyy-MM-dd HH:mm:ss)    precision精度 1秒、1000毫秒、1000000微秒
+ (NSInteger)date_getTimeStampFormDateString:(NSString *)dateStr timeType:(NSString *)timeType precision:(NSInteger)precision {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (timeType.length) {
        [dateFormatter setDateFormat:timeType];
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate *dateTime = [dateFormatter dateFromString:dateStr];
    
    NSTimeInterval timeNum = dateTime.timeIntervalSince1970 * precision;
    
    NSInteger time = timeNum / 1;
    
    return time;
}



///指定年月——>到现在的年月
+ (NSMutableArray *)date_getDateArrayToNowWithYear:(NSInteger)startYear startMonth:(NSInteger)startMonth{
    
    NSMutableArray *arrayDate = [NSMutableArray array];
    
    NSMutableArray *arrayYear = [NSMutableArray array];//年份
    NSMutableArray *arrayMonth = [NSMutableArray array];//月份
    
    //获取当前时间
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM"];
    NSString *nowDateStr = [dateformatter stringFromDate:senddate];
    
    NSArray *arrayNowDate = [nowDateStr componentsSeparatedByString:@"-"];
    NSInteger nowYear = [arrayNowDate[0] integerValue];//现在的年份
    NSInteger nowMonth = [arrayNowDate[1] integerValue];//现在的月份
    
    //    NSInteger startYear = 2015;//开始的年份
    //    NSInteger startMonth = 10;//开始的月份
    NSInteger beginYear = startYear;
    while (1) {
        
        //添加年份
        [arrayYear addObject:[NSString stringWithFormat:@"%ld",(long)startYear]];
        
        //添加月份
        NSArray *array;
        if (startYear == beginYear) {
            //开始年份 && 判断 开始年份 是否等于 现在年份
            NSMutableArray *firstMonthArray = [NSMutableArray array];
            
            if (startYear == nowYear) {
                //年份相同
                for (NSInteger i = startMonth; i < nowMonth + 1; i++) {
                    [firstMonthArray gf_addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                }
            }else{
                //年份不同
                for (NSInteger i = startMonth; i < 12 + 1; i++) {
                    [firstMonthArray gf_addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                }
            }
            
            array = [firstMonthArray copy];
        }else if (startYear == nowYear){
            //等于现在年份
            NSMutableArray *lastMonthArray = [NSMutableArray array];
            for (int i = 1; i < nowMonth + 1; i++) {
                [lastMonthArray gf_addObject:[NSString stringWithFormat:@"%d",i]];
            }
            array = [lastMonthArray copy];
        }else{
            //小于现在年份
            array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
        }
        
        [arrayMonth addObject:array];
        
        startYear ++;
        
        if (startYear > nowYear) {
            //中断循环
            break ;
        }
    }
    
    [arrayDate addObject:arrayYear];
    [arrayDate addObject:arrayMonth];
    
    return arrayDate;
}

@end
