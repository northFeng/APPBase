//
//  APPOssInterface.h
//  APPBase
//
//  Created by 峰 on 2020/1/4.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPOssInterface : NSObject

///获取OSS上传对象
+ (instancetype)shareInstance;

/// 上传数据二进制
/// @param upData 二进制数据
/// @param dataId 数据唯一Id(带类型 例如 xxx.mp3)
/// @param blockResult 回调
- (void)uploadData:(NSData *)upData dataId:(NSString *)dataId blockResult:(APPBackBlock)blockResult;


/// 获取OSS数据
/// @param dataId 获取数据id
/// @param blockResult 回调
- (void)getDataFormOSSWithDataId:(NSString *)dataId blockResult:(APPBackBlock)blockResult;

///删除OSS文件
- (void)deleteOSSDataWithDataId:(NSString *)dataId blockResult:(APPBackBlock)blockResult;

///获取对象的URL
- (void)getDataPublicUrlWithDataId:(NSString *)dataId blockResult:(APPBackBlock)blockResult;

@end

NS_ASSUME_NONNULL_END
