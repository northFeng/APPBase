//
//  CBAudioSmallAlerView.h
//  CleverBaby
//  音频播放全局小弹框view
//  Created by 峰 on 2019/12/21.
//  Copyright © 2019 小神童. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBAudioSmallAlerView : UIView <APPAudioPlayerDelegate>

///是否关闭播放器
@property (nonatomic,assign) BOOL closeAudio;

///单利
+ (instancetype)shareInstance;

///显示小播放器
- (void)showSmallAudioAlertView;

///隐藏小播放器
- (void)hideSmallAudioAlertView;

///外部列表点击进行播放
- (void)clickAudioListToPlayAudioWithAudioArrayData:(NSArray *)audioArray index:(NSInteger)playIndex themeTitle:(NSString *)themeTitle;

@end

NS_ASSUME_NONNULL_END
