//
//  APPAudioNetPlayer.h
//  CleverBaby
//  网络播放音频
//  Created by 峰 on 2020/4/20.
//  Copyright © 2020 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPAudioNetPlayer : NSObject

///播放完毕
@property (nonatomic,copy) APPBackBlock blockComplte;

///播放出错
@property (nonatomic,copy) APPBackBlock blockError;

///时间回调 @[@(playbackTime),@(totalTime)]
@property (nonatomic,copy) APPBackBlock blockTime;

///播放停止
@property (nonatomic,copy) APPBackBlock blockStop;

///使用单利时 注意：不用时 释放 block！
+ (instancetype)shareInstance;

///播放 —> 音频URL (从头播放URL)
- (void)playAudioFromoUrl:(NSString *)url;

///暂停 —> 播放
- (void)playAudio;

///暂停播放
- (void)pauseAudio;

///停止播放（停止音频流加载）
- (void)stopAuido;


@end

NS_ASSUME_NONNULL_END
