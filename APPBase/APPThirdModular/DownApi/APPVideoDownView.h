//
//  APPVideoDownView.h
//  CleverBaby
//  下载view
//  Created by 峰 on 2020/8/15.
//  Copyright © 2020 小神童. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPVideoDownView : UIView

///下载
- (void)downVideo:(NSString *)videoUrl blockComplete:(APPBackBlock)blockEnd;

///获取本地的视频路径
- (NSString *)loacalVideoFilePath:(NSString *)videoUrl;

@end

NS_ASSUME_NONNULL_END
