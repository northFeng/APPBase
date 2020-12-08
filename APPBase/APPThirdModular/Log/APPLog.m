//
//  APPLog.m
//  APPBase
//
//  Created by v_gaoyafeng on 2020/12/7.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import "APPLog.h"

#import <CocoaLumberjack/CocoaLumberjack.h>


#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif

@implementation APPLog
/**
 1.DDLog（整个框架的基础）
 2.DDASLLogger（发送日志语句到苹果的日志系统，以便它们显示在Console.app上）
 3.DDTTYLoyger（发送日志语句到Xcode控制台）
 4.DDFIleLoger（把日志写入本地文件）

 */

///初始化Log配置
+ (void)initDDLogConfiguration {
    
    // 添加DDASLLogger，你的日志语句将被发送到Xcode控制台
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
    // 添加DDTTYLogger，你的日志语句将被发送到Console.app
    [DDLog addLogger:[DDASLLogger sharedInstance]];
        
    //添加DDFileLogger，你的日志语句将写入到一个文件中，默认路径在沙盒的Library/Caches/Logs/目录下，文件名为bundleid+空格+日期.log。
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
        
    //产生Log
    DDLogVerbose(@"Verbose");
    DDLogDebug(@"Debug");
    DDLogInfo(@"Info");
    DDLogWarn(@"Warn");
    DDLogError(@"Error");
}





@end
