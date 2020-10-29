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


//-----------------------------------  NSFileMange 和 NSFileHandle  ---------------------------------------
+ (void)fileHandleWriteData {
    
    /**  操作文件管理时，判断本地沙盒文件是否还有存储空间！！否则内存已满，写入时会崩溃
     
     NSFileHandle  此类主要是对 「文件内容」进行读取和写入操作

     NSFileMange   此类主要是对  「文件」进行的操作以及文件信息的获取
     
     
     常用处理方法

     + (id)fileHandleForReadingAtPath:(NSString *)path  打开一个文件准备读取

     + (id)fileHandleForWritingAtPath:(NSString *)path  打开一个文件准备写入

     + (id)fileHandleForUpdatingAtPath:(NSString *)path  打开一个文件准备更新

     -  (NSData *)availableData; 从设备或通道返回可用的数据

     -  (NSData *)readDataToEndOfFile; 从当前的节点读取到文件的末尾

     -  (NSData *)readDataOfLength:(NSUInteger)length; 从当前节点开始读取指定的长度数据

     -  (void)writeData:(NSData *)data; 写入数据

     -  (unsigned long long)offsetInFile;  获取当前文件的偏移量

     -  (void)seekToFileOffset:(unsigned long long)offset; 跳到指定文件的偏移量

     -  (unsigned long long)seekToEndOfFile; 跳到文件末尾

     -  (void)truncateFileAtOffset:(unsigned long long)offset; 将文件的长度设为offset字节

     -  (void)closeFile;  关闭文件
     */
    
    //1-向文件追加数据

    NSString *homePath  = NSHomeDirectory();

    NSString *sourcePath = [homePath stringByAppendingPathComponent:@"testfile.text"];

    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:sourcePath];

    [fileHandle seekToEndOfFile];//将节点跳到文件的末尾!!!!!!!!写文件要指定文件的位置！

    NSString *str = @"追加的数据";

    NSData *stringData  = [str dataUsingEncoding:NSUTF8StringEncoding];//把数据转换成Data

    [fileHandle writeData:stringData];//追加写入数据

    [fileHandle closeFile];//关闭文件

    //2-定位数据
    NSFileManager *fm = [NSFileManager defaultManager];

    NSString *content = @"abcdef";

    [fm createFileAtPath:@"user/path" contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];

    NSFileHandle *fileHandle2 = [NSFileHandle fileHandleForReadingAtPath:@"user/path"];

    NSUInteger length = [fileHandle2.availableData length]; //获取数据长度

    [fileHandle2 seekToFileOffset:length/2];//偏移量文件的一半
    //NSData *data = [fileHandle readDataToEndOfFile];//从当前偏移量 读取剩余的数据

    [fileHandle closeFile];
    
    
    
    //3-复制文件
    NSFileHandle *infile, *outfile; //输入文件、输出文件

    NSData *buffer; //读取的缓冲数据

    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *homePath3 = NSHomeDirectory( );

    NSString *sourcePath3 = [homePath3 stringByAppendingPathComponent:@"testfile.txt"]; //源文件路径

    
    NSString *outPath = [homePath stringByAppendingPathComponent:@"outfile.txt"];//输出文件路径
    [fileManager createFileAtPath:outPath contents:nil attributes:nil];//创建输出的文件

    infile = [NSFileHandle fileHandleForReadingAtPath:sourcePath3];//创建读取源路径文件

    if (infile != nil){

        outfile = [NSFileHandle fileHandleForReadingAtPath:outPath];//创建病打开要输出的文件

        if (outfile != nil){

            [outfile truncateFileAtOffset:0];//将输出文件的长度设为0

            buffer = [infile readDataToEndOfFile]; //读取数据

            [outfile writeData:buffer]; //写入输入

            [infile closeFile]; //关闭写入、输入文件

            [outfile closeFile];
        }
    }
    
}


@end
