//
//  APPBaseModel.h
//  FlashSend
//  APP的数据模型基类
//  Created by gaoyafeng on 2018/8/28.
//  Copyright © 2018年 ishansong. All rights reserved.
//  转换数据 ——> 单独写一个类来处理数据的转换

#import <Foundation/Foundation.h>

#import "APPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface APPBaseModel : NSObject

#pragma mark - YYmodel带的 对象 ——> JSON数据（自动过滤为nil的数据）
///转换成字符串
- (NSString *)gf_modelToJsonString;

///转换成字典
- (NSDictionary *)gf_modelToJsonDictionary;

///转换成data
- (NSData *)gf_modelToJsonData;

@end

NS_ASSUME_NONNULL_END
