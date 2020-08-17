//
//  APPFileManager.m
//  APPBase
//
//  Created by 峰 on 2019/10/12.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPFileManager.h"

@implementation APPFileManager

///创建路径
+ (void)createFilePath:(NSString *)filePath {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:filePath]) {
        [fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

///清除文件
+ (void)removeFileOfPath:(NSString *)filePath {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:nil];
    }
}

///获取某文件夹的大小
+ (void)getFolderSizeOfPath:(NSString *)folderPath endBlock:(APPBackBlock)blockEnd {
    
    [self getSizeOfFolderPath:folderPath endBlock:blockEnd];
}

///获取文件大小
+ (NSUInteger)getFileSizeOfPath:(NSString *)filePath {
   
    NSUInteger size = 0;
    
    NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    size = (NSUInteger)[attrs fileSize];
    
    return size;
}


///遍历文件下所有文件计算大小
+ (void)getSizeOfFolderPath:(NSString *)folderPath endBlock:(APPBackBlock)blockEnd {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSUInteger size = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:folderPath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
            NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (blockEnd) {
                blockEnd(YES,@(size));
            }
        });
    });
}

///获取Cache文件大小
+ (void)getCacheFileSizeEndBlock:(APPBackBlock)blockEnd {
    
    NSString *filePath = kAPP_File_CachePath;
    [self getSizeOfFolderPath:filePath endBlock:blockEnd];
}

///清理Cache下的所有缓存
+ (void)clearDiskItemsOfCacheEndBlock:(APPBackBlock)blockEnd {
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSString *cachePath = kAPP_File_CachePath;
        NSArray * files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];//返回这个路径下的所有文件的数组
        for (NSString *fileName in files) {

            NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
            
            [self removeFileOfPath:filePath];//清除文件
        }
        
        if (blockEnd) {
            blockEnd(YES,@0);
        }
    });
}

///获取缓存路径
+ (NSString *)getCachePathOfUrl:(NSString *)fileName cacheFilePath:(NSString *)cachePath  {

    NSError *error;
    NSArray *pathArray = [NSFileManager.defaultManager contentsOfDirectoryAtPath:cachePath error:&error];
    
    NSString *path = @"";
    for (NSString *file in pathArray) {
        if ([file isEqualToString:fileName]) {
            path = [NSString stringWithFormat:@"%@/%@",cachePath,file];
            break;
        }
    }
    
    return path;
}

///删除最旧的文件
+ (void)removeOldestFilePath:(NSString *)filePath suffix:(NSString *)suffix {
    
    NSError *error;
    NSArray *pathArray = [NSFileManager.defaultManager contentsOfDirectoryAtPath:filePath error:&error];
    
    if (pathArray.count) {
        //删除第一条视频
        
        NSString *fileName = @"";
        NSString *removeName = @"";
        NSDate *removeDate = nil;
        for (NSInteger i = 0; i < pathArray.count ; i++) {
            //倒着取
            fileName = pathArray[i];
            if ([fileName hasSuffix:suffix]) {
                //是对应后缀文件
                NSString *path = [filePath stringByAppendingPathComponent:fileName];
                
                //获取该文件属性
                NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
                NSDate *createDate = [attrs fileCreationDate];//创建日期
                if (i == 0) {
                    removeDate = createDate;
                    removeName = fileName;
                }else{
                    if (createDate.timeIntervalSince1970 < removeDate.timeIntervalSince1970) {
                        removeDate = createDate;
                        removeName = fileName;
                    }
                }
            }
        }
        
        if (removeName.length) {
            NSString *removePath = [filePath stringByAppendingPathComponent:removeName];
            [NSFileManager.defaultManager removeItemAtPath:removePath error:nil];
        }
    }
}


//-----------------------------------  APP内路径获取  ---------------------------------------
///获取音频缓存路径
+ (NSString *)auidoCachePath {
    
    NSString *audioCachePath = [kAPP_File_CachePath stringByAppendingPathComponent:@"AudioCache"];
    [self createFilePath:audioCachePath];
    
    return audioCachePath;
}



@end
