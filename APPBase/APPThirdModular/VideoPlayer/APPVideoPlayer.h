//
//  APPVideoPlayer.h
//  CleverBaby
//  APP内视频播放器
//  Created by 峰 on 2019/11/19.
//  Copyright © 2019 小神童. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  视频播放状态
 */
typedef NS_ENUM(NSInteger,VideoPlayState) {
    /**
     *  加载中
     */
    VideoPlayState_loading = 0,
    /**
     *  播放中
     */
    videoPlayState_playing,
    /**
     *  暂停
     */
    videoPlayState_pasuse,
    /**
     *  停止
     */
    videoPlayState_stop,
    /**
     *  出错
     */
    videoPlayState_error,
    /**
     *  播放完成
     */
    videoPlayState_completed,
};

///视频播放器代理
@protocol APPVideoPlayerDelegate <NSObject>

///视频开始加载完后回调 视频流的宽高
- (void)videoSizeForWidth:(int)width height:(int)height;

///视频缓存回调进度（0 ~ 1.0）
- (void)videoCacheLoadedProgress:(CGFloat)progress;

///视频播放状态
- (void)videoPlayState:(VideoPlayState)state;

///视频播放 当前时间 && 视频持续时间
- (void)videoCureentPlayTime:(NSInteger)cureentPlayTime durationTime:(NSInteger)duration;

///播放出错
- (void)playError:(NSString *)errorInfo;


@end


///视频播放器
@interface APPVideoPlayer : NSObject

///代理
@property (nonatomic,weak) id <APPVideoPlayerDelegate> delegate;

///当前视频的宽高比 (初始化默认16：9)
@property (nonatomic,assign,readonly) CGFloat videoScale;

///是否正在播放
@property (nonatomic,assign,getter=isPlaying) BOOL isPlaying;

///创建单利
+ (instancetype)shareInstance;

///播放URL
- (UIView *)playVideoWithUrl:(NSString *)videoUrl;

///点播从某记忆点开始播放
- (void)preStartPlayTime:(NSUInteger)seconds;

///播放
- (void)playVideo;

///暂停播放
- (void)pauseVideo;

///停止播放
- (void)stopVideo;

///跳到指定进度播放
- (void)seekToPlaySeconds:(NSInteger)seconds;


///释放监听者
- (void)deallocObserve;

@end

NS_ASSUME_NONNULL_END
