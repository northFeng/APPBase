//
//  APPAudioPlayer.h
//  CleverBaby
//  APP内音乐播放器
//  Created by 峰 on 2019/11/13.
//  Copyright © 2019 小神童. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  播放状态
 */
typedef NS_ENUM(NSInteger,AudioPlayState) {
    /**
     *  加载中
     */
    AudioPlayState_loading = 0,
    /**
     *  播放中
     */
    AudioPlayState_playing = 1,
    /**
     *  暂停
     */
    AudioPlayState_pause = 2,
    /**
     *  停止
     */
    AudioPlayState_stop = 3,
    /**
     *  加载出错(播放失败)
     */
    AudioPlayState_error = 4,
    /**
     *  播放完成
     */
    AudioPlayState_complete = 5,
    
};

/**
 *  播放顺序枚举
 */
typedef NS_ENUM(NSInteger,AudioPlayLoopType) {
    /**
     *  列表依次顺序播放
     */
    AudioPlayLoopType_order = 0,
    /**
     *  随机播放
     */
    AudioPlayLoopType_random = 1,
    /**
     *  单首循环播放
     */
    AudioPlayLoopType_repet = 2,
};

///音频数据item
@interface APPAudioItem : NSObject

///数据id
@property (nonatomic,copy) NSString *audioId;
///歌词id
@property (nonatomic,copy) NSString *lyricsId;

///音频标题
@property (nonatomic,copy) NSString *title;
///音频副标题
@property (nonatomic,copy) NSString *subTitle;
///音频URL
@property (nonatomic,copy) NSString *audioUrl;
///音频图片
@property (nonatomic,copy) NSString *imgUrl;
///图片image
@property (nonatomic,strong) UIImage *image;
///audio歌词
@property (nonatomic,copy) NSString *audioLyrics;

///是否正在播放
@property (nonatomic,assign) BOOL isPlaying;

///视频地址
@property (nonatomic,copy) NSString *videoUrl;


@end


///音乐播放器代理
@protocol APPAudioPlayerDelegate <NSObject>

///回调当前播放的item
- (void)currentPlayItem:(APPAudioItem *)playItem;

///回调当前播放状态
- (void)audioPlayStateChange:(AudioPlayState)playState;

///回调当前播放时间（单位秒）
- (void)audioCurrentPlayTime:(NSUInteger)seconds cureentplayProgress:(CGFloat)progress;

///缓存进度回调 （范围0~1.0）
- (void)audioBufferCacheProgress:(CGFloat)bufferProgress;

///倒计时还剩余的时间
- (void)countDownTimerSeconds:(NSInteger)seconds;

///播放出错
- (void)audioPlayError:(NSString *)errorInfo;


@end


///音频播放器
@interface APPAudioPlayer : NSObject

///播放类型title
@property (nonatomic,copy) NSString *themeTitle;

///代理
@property (nonatomic,weak) id <APPAudioPlayerDelegate> delegate;

///播放源数据
@property (nonatomic,copy,readonly) NSArray <APPAudioItem *>*audioSourceArray;

///播放当前位置
@property (nonatomic,assign,readonly) NSInteger indexItem;

///当前播放Item
@property (nonatomic,strong) APPAudioItem *playItem;

///当前播放URL
@property (nonatomic,copy,readonly) NSString *playUrl;

///当前播放时间(秒)
@property (nonatomic,assign,getter=currentTimePlayed) NSInteger currentTimePlayed;

///当前播放音频持续时间(秒)
@property (nonatomic,assign,getter=durationTime) NSInteger durationTime;


///播放顺序类型 （默认依次顺序播放）
@property (nonatomic,assign) AudioPlayLoopType loopType;

///播放速率（范围0.5 to 2.0.）默认1.0
@property (nonatomic,assign) CGFloat playRate;

///当前播放状态
@property (nonatomic,assign,readonly) AudioPlayState playState;

///是否进行自动播放下一首 (默认NO，开启后，外部不可实现自动播放下一首，否则跳到下下首！)
@property (nonatomic,assign) BOOL autoPlayNext;

///是否关联锁屏界面(默认关闭)
@property (nonatomic,assign) BOOL lockScreen;

///播放完一首触发block
@property (nonatomic,copy) APPBackBlock playCompleteBlock;



///单利播放器
+ (instancetype)shareInstance;

///是否正在播放
- (BOOL)isPlaying;

///获取当前播放音频时长
- (NSUInteger)getCureentAudioDuration;

//--------------------------------------- 播放控制 ---------------------------------------

///开始播放 音频数组（音频列表）
- (void)playAudioArray:(NSArray *)audioSourceArray playIndex:(NSUInteger)index;

///从指定位置开始播放
- (void)playAudioOnIndex:(NSUInteger)playIndex;

///播放 音频URL(单个音频)
- (void)playAudioFromoUrl:(NSString *)url;

///从指定进度开始播放 （暂停后直接指定位置播放）
- (void)playAudioFromOffset:(CGFloat)offset;

///播放
- (void)playAudio;

///暂停播放
- (void)pauseAudio;

///停止播放（停止音频流加载）
- (void)stopAuido;

///上一首
- (void)upAudioPaly;

///下一首
- (void)nextAudioPalay;

///指定位置播放  （播放过程中有效 范围 0.001 ~ 0.999 之间）
- (void)seekToPositon:(CGFloat)value;


///关闭播放器清除信息
- (void)closeAudioPlayerClearInfo;


#pragma mark - ************************* 后台播放设置 && 外部控制事件接受处理 *************************
///APP进入后台开始接受 外部控制事件
- (void)appEnterBackground;

///处理远程控制事件！
//- (void)handleRemoteControlReceivedWithEvent:(UIEvent *)event;

#pragma mark - ************************* 倒计时器功能 *************************
///开始进行倒计时
- (void)startCountDownTimeOfDuration:(NSInteger)duration;

///释放监听者
- (void)deallocObserve;


///获取当前歌词
+ (void)getCurrentAudioLyricsWithBlock:(APPBackBlock)blockResult;


@end

NS_ASSUME_NONNULL_END
