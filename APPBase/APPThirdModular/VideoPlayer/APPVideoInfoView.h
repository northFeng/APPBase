//
//  APPVideoInfoView.h
//  CleverBaby
//  视频亮度 && 音量显示 弹框
//  Created by 峰 on 2020/2/4.
//  Copyright © 2020 小神童. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPVideoInfoView : UIView

///进度
@property (nonatomic,assign) CGFloat value;


- (instancetype)initWithBcImg:(NSString *)bcImgName;

@end

NS_ASSUME_NONNULL_END
