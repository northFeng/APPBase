//
//  APPModel.h
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/26.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPModel : NSObject

///title
@property (nonatomic,copy) NSString *title;

///副标题
@property (nonatomic,copy) NSString *subTitle;

///附加字符串
@property (nonatomic,copy) NSString *subString;

///subtitle
@property (nonatomic,copy) NSAttributedString *attributeStr;

///整数
@property (nonatomic,assign) NSInteger numCode;

///图片name
@property (nonatomic,strong) NSString *imgName;

@end

NS_ASSUME_NONNULL_END
