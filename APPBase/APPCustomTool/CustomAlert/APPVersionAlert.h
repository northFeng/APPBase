//
//  APPVersionAlert.h
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/26.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPVersionAlert : UIView

///赋值
- (void)setDicModel:(NSDictionary *)dicModel;

///弹出更新弹框
+ (void)showVersonUpdateAlertViewWithVersonInfo:(NSDictionary *)versonDic;

@end

NS_ASSUME_NONNULL_END
