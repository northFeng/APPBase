//
//  APPFileManager.h
//  APPBase
//  APP文件管理
//  Created by 峰 on 2019/10/12.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPFileManager : NSObject

///创建路径
+ (void)createFilePath:(NSString *)filePath;

///清除文件
+ (void)removeFileOfPath:(NSString *)filePath;


///获取某文件夹内所有文件大小
+ (void)getFolderSizeOfPath:(NSString *)folderPath endBlock:(APPBackBlock)blockEnd;


///获取一个文件大小(不能是文件夹)
+ (NSUInteger)getFileSizeOfPath:(NSString *)filePath;

///遍历文件下所有文件计算大小
+ (void)getSizeOfFolderPath:(NSString *)folderPath endBlock:(APPBackBlock)blockEnd;

///获取Cache文件大小
+ (void)getCacheFileSizeEndBlock:(APPBackBlock)blockEnd;

///清理Cache下的所有缓存
+ (void)clearDiskItemsOfCacheEndBlock:(APPBackBlock)blockEnd;


//-----------------------------------  APP内路径获取  ---------------------------------------
///获取音频缓存路径
+ (NSString *)auidoCachePath;


@end

NS_ASSUME_NONNULL_END
