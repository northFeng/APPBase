//
//  APPNoDataView.h
//  APPBase
//  无数据占位图
//  Created by 峰 on 2019/10/12.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPNoDataView : UIView

///点击按钮信号
@property (nonatomic,strong) RACSignal *btnSignal;


/**
 *  @brief 创建无数据占位图
 *
 *  @param imgName 占位图name
 *  @param brifText 无数据描述
 *  @param btnTitle 按钮name
 *  @param topSpare 占位图空闲距离
 *
 *  @return ESNoDataView实例
 */
+ (APPNoDataView *)createNodateViewWithImgName:(NSString *)imgName brifText:(NSString *)brifText btnTitle:(NSString *)btnTitle topSpare:(CGFloat)topSpare;

@end

NS_ASSUME_NONNULL_END
