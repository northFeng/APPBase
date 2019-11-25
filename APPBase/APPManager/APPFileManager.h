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


///获取某文件夹内所有文件大小
+ (NSUInteger)getFolderSizeOfPath:(NSString *)folderPath;

///获取一个文件大小(不能是文件夹)
+ (NSUInteger)getFileSizeOfPath:(NSString *)filePath;

///遍历文件下所有文件计算大小
+ (NSUInteger)getSizeOfFolderPath:(NSString *)folderPath;


@end

NS_ASSUME_NONNULL_END
