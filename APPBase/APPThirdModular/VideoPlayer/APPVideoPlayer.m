//
//  APPVideoPlayer.m
//  CleverBaby
//
//  Created by 峰 on 2019/11/19.
//  Copyright © 2019 小神童. All rights reserved.
//

#import "APPVideoPlayer.h"

#import <PLPlayerKit/PLPlayerKit.h>

@interface APPVideoPlayer () <PLPlayerDelegate>

///播放配置
@property (nonatomic,strong) PLPlayerOption *option;

///播放器
@property (nonatomic,strong) PLPlayer *player;

///定时器
@property (nonatomic,strong) NSTimer *timer;


@end

@implementation APPVideoPlayer
{
    BOOL _isOpen;//是否打开定时器
}

- (void)dealloc {
    NSLog(@"播放器死亡");
    [self deallocObserve];//释放监听者
}

///释放监听者
- (void)deallocObserve {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

///创建单利
+ (instancetype)shareInstance {
    static APPVideoPlayer *videoPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoPlayer = [[self alloc] init];
    });
    return videoPlayer;
}

- (instancetype)init {
    if (self = [super init]) {
        //初始化参数
        _isOpen = NO;
        _videoScale = 16./9.;//默认16：9
        
        [APPNotificationCenter addObserver:self selector:@selector(appWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];//APP将要放弃活跃
    }
    return self;
}

///APP将要放弃活跃
- (void)appWillResignActiveNotification {
    
    if (self.isPlaying) {
        [self pauseVideo];//暂停播放
    }
}

- (PLPlayerOption *)option {
    if (!_option) {
        _option = [PLPlayerOption defaultOption];
        /**
        // 更改需要修改的 option 属性键所对应的值
        [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
        [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
        [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
        [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
        [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
         */
        [_option setOptionValue:@(kPLPLAY_FORMAT_MP4) forKey:PLPlayerOptionKeyVideoPreferFormat];//播放Mp4格式
    }
    return _option;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [self timerPause];
    }
    return _timer;
}

///开启定时器
- (void)timerStart {
    if (!_isOpen) {
        [self.timer setFireDate:[NSDate distantPast]];
        _isOpen = YES;
    }
}

///暂停定时器
- (void)timerPause {
    if (_isOpen) {
        [self.timer setFireDate:[NSDate distantFuture]];
        _isOpen = NO;
    }
}

#pragma mark - ************************* 播放器控制 *************************
- (BOOL)isPlaying {
    if (_player) {
        return _player.isPlaying;
    }else{
        return NO;
    }
}

///播放URL
- (UIView *)playVideoWithUrl:(NSString *)videoUrl {
    
    NSURL *url;
    
    if ([videoUrl hasPrefix:@"http"]) {
        url = [NSURL gf_URLWithString:videoUrl];//网络视频
    }else{
        url = [NSURL fileURLWithPath:videoUrl];//本地视频
    }
    if (_player) {
        [_player playWithURL:url sameSource:YES];
    }else{
        _player = [PLPlayer playerWithURL:url option:self.option];
        _player.delegate = self;
        [_player setBufferingEnabled:NO];//不缓存
        //_player.loopPlay = YES;//是否循环播放
    }
    //_player.launchView = [UIImage imageNamed:@""];//启动图
    
    [_player play];//开始播放
    return _player.playerView;
}

///点播从某记忆点开始播放
- (void)preStartPlayTime:(NSUInteger)seconds {
    
    /**
     提前设置点播从某记忆点开始播放。
     
     @since v3.3.1
     */
    [_player preStartPosTime:CMTimeMake(seconds, 1)];
}

///播放
- (void)playVideo {
    
    if (!_player.isPlaying) {
        [_player resume];
    }
}

///暂停播放
- (void)pauseVideo {
    
    if (_player.isPlaying) {
        [_player pause];
    }
}

///停止播放
- (void)stopVideo {
    
    [_player stop];
}

///跳到指定进度播放
- (void)seekToPlaySeconds:(NSInteger)seconds {
    [_player seekTo:CMTimeMake(seconds, 1)];
    [self playVideo];//播放
}

#pragma mark - ************************* 视频代理实现 *************************
/**
 告知代理对象 PLPlayer 即将开始进入后台播放任务
 
 @param player 调用该代理方法的 PLPlayer 对象
 
 @since v1.0.0
 */
- (void)playerWillBeginBackgroundTask:(nonnull PLPlayer *)player {
    if (player.isPlaying) {
        [player pause];
        //暂停
    }
}

/**
 告知代理对象 PLPlayer 即将结束后台播放状态任务
 
 @param player 调用该方法的 PLPlayer 对象
 
 @since v2.1.1
 */
- (void)playerWillEndBackgroundTask:(nonnull PLPlayer *)player {
    
}

/**
 告知代理对象播放器状态变更
 
 @param player 调用该方法的 PLPlayer 对象
 @param state  变更之后的 PLPlayer 状态
 
 @since v1.0.0
 */
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    
    VideoPlayState playState = VideoPlayState_loading;//加载中
    
    switch (state) {
        case PLPlayerStatusUnknow:
            //PLPlayer 未知状态，只会作为 init 后的初始状态，开始播放之后任何情况下都不会再回到此状态。
            
            break;
        case PLPlayerStatusPreparing:
            //PLPlayer 正在准备播放所需组件，在调用 -play 方法时出现。
            NSLog(@"预备中..");
            playState = VideoPlayState_loading;
            
            break;
        case PLPlayerStatusReady:
            //PLPlayer 播放组件准备完成，准备开始播放，在调用 -play 方法时出现。
            NSLog(@"预备完毕..");
            playState = VideoPlayState_loading;
            
            break;
        case PLPlayerStatusOpen:
            //PLPlayer 播放组件准备完成，准备开始连接 （请勿在此状态时，调用 playWithURL 切换 URL 操作）
            NSLog(@"开始连接..");
            playState = VideoPlayState_loading;
            
            break;
        case PLPlayerStatusCaching:
            //PLPlayer 缓存数据为空状态。 --> 特别需要注意的是当推流端停止推流之后，PLPlayer 将出现 caching 状态直到 timeout 后抛出 timeout 的 error 而不是出现 PLPlayerStatusStopped 状态，因此在直播场景中，当流停止之后一般做法是使用 IM 服务告知播放器停止播放，以达到即时响应主播断流的目的。
            NSLog(@"缓冲中..");
            playState = VideoPlayState_loading;
            
            break;
        case PLPlayerStatusPlaying:
            //PLPlayer 正在播放状态。
            NSLog(@"播放中..");
            playState = videoPlayState_playing;
            [self timerStart];//开启定时器
            
            break;
        case PLPlayerStatusPaused:
             //PLPlayer 暂停状态。
            NSLog(@"暂停..");
            playState = videoPlayState_pasuse;
            [self timerPause];//暂停定时器
            
             break;
        case PLPlayerStatusStopped:
             //PLPlayer 停止状态 (该状态仅会在回放时播放结束出现，RTMP 直播结束并不会出现此状态)
            NSLog(@"停止..");
            playState = videoPlayState_stop;
            [self timerPause];//暂停定时器
            
             break;
        case PLPlayerStatusError:
            //PLPlayer 错误状态，播放出现错误时会出现此状态。
            NSLog(@"出错..");
            playState = videoPlayState_error;
            [self timerPause];//暂停定时器
            
            break;
        case PLPlayerStateAutoReconnecting:
            //PLPlayer 自动重连的状态
            NSLog(@"重连中..");
            playState = VideoPlayState_loading;
            [self timerPause];//暂停定时器
            
            break;
        case PLPlayerStatusCompleted:
            //PLPlayer 播放完成（该状态只针对点播有效）
            NSLog(@"播放完..");
            playState = videoPlayState_completed;
            [self timerPause];//暂停定时器
            
            break;
        default:
            break;
    }
    
    //回调状态
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayState:)]) {
        [self.delegate videoPlayState:playState];
    }
}

/**
 告知代理对象播放器因错误停止播放
 
 @param player 调用该方法的 PLPlayer 对象
 @param error  携带播放器停止播放错误信息的 NSError 对象
 
 @since v1.0.0
 */
- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    if (error) {
        [player pause];//暂停播放
        //根据错误状态码进行处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(playError:)]) {
            NSString *errorDescrip = [self getErrorInfoWithCode:error.code];
            [self.delegate playError:errorDescrip];
        }
    }
}

/**
 点播已缓冲区域
 
 @param player 调用该方法的 PLPlayer 对象
 @param timeRange  CMTime , 表示从0时开始至当前缓冲区域，单位秒。
 
 @warning 仅对点播有效
 
 @since v2.4.1
 */
- (void)player:(nonnull PLPlayer *)player loadedTimeRange:(CMTime)timeRange {
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoCacheLoadedProgress:)]) {
        CGFloat seconds = CMTimeGetSeconds(timeRange)*1.;
        CGFloat durationTime = CMTimeGetSeconds(player.totalDuration)*1.;
        //回调缓存进度
        [self.delegate videoCacheLoadedProgress:(seconds / durationTime)];
    }
}

/**
 回调将要渲染的帧数据
 该功能只支持直播
 */
//- (void)player:(nonnull PLPlayer *)player willRenderFrame:(nullable CVPixelBufferRef)frame pts:(int64_t)pts sarNumerator:(int)sarNumerator sarDenominator:(int)sarDenominator {
//
//}


/**
 音视频渲染首帧回调通知
 
 @param player 调用该方法的 PLPlayer 对象
 @param firstRenderType 音视频首帧回调通知类型
 
 @since v3.2.1
 */
//- (void)player:(nonnull PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType {
//
//}

/**
 视频宽高数据回调通知

 @param player 调用该方法的 PLPlayer 对象
 @param width 视频流宽
 @param height 视频流高
 
 @since v3.3.0
 */
- (void)player:(nonnull PLPlayer *)player width:(int)width height:(int)height {
    NSLog(@"----->视频宽:%d----高%d",width,height);
    _videoScale = (width * 1.) / (height * 1.);
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoSizeForWidth:height:)]) {
        [self.delegate videoSizeForWidth:width height:height];
    }
}

/**
 seekTo 完成的回调通知
 
 @param player 调用该方法的 PLPlayer 对象
 
 @since v3.3.0
 */
- (void)player:(nonnull PLPlayer *)player seekToCompleted:(BOOL)isCompleted {
    //播放完成
}


#pragma mark - ************************* 定时器事件 *************************
///定时器回调播放进度
- (void)timerEvent {
    
    if (self.delegate) {
        
        //播放时间变化
        if ([self.delegate respondsToSelector:@selector(videoCureentPlayTime:durationTime:)]) {
            
            if (self.player) {
                NSInteger cureentSeconds = CMTimeGetSeconds(self.player.currentTime) / 1;
                NSInteger duration = CMTimeGetSeconds(self.player.totalDuration) / 1;
                [self.delegate videoCureentPlayTime:cureentSeconds durationTime:duration];
            }
        }
    }
    
}

///获取错误信息
- (NSString *)getErrorInfoWithCode:(NSInteger)code {
    NSString *errorDescrip = @"播放错误";
    switch (code) {
        case PLPlayerErrorUnknow:
            //0  errorDescrip = @"未知错误";
            break;
        case PLPlayerErrorEOF:
            //-1 文件结束
            break;
        case PLPlayerErrorURLNotSupported:
            //-2000 URL to play is not supported
            errorDescrip = @"不支持该视频播放";
            break;
        case PLPlayerErrorAudioSessionNotSupportToPlay:
            //-2001,  // "AVAudioSession's category doesn't support audio play."
            errorDescrip = @"不支持该音频播放";
            break;
        case PLPlayerErrorAudioFormatNotSupport:
            // = -2002, // "RTMP/FLV live audio only support AAC."
            errorDescrip = @"不支持该音频播放";
            break;
        case PLPlayerErrorVideoFormatNotSupport:
            // = -2003, // "RTMP/FLV live video only support H264."
            errorDescrip = @"不支持该视频播放";
            break;
        case PLPlayerErrorStreamFormatNotSupport:
            // = -2004, // FFMPEG can not open stream, or can not find stream info.'
            errorDescrip = @"连接视频失败，请检查网络";
            break;
        case PLPlayerErrorInputTimeout:
            // = -2100, // "Input read data timeout."
            errorDescrip = @"连接视频失败";
            break;
        case PLPLayerErrorInputReadError:
            // = -2101, // "Input read data error."
            errorDescrip = @"连接视频失败";
            break;
        case PLPlayerErrorCodecInitFailed:
            // = -2201, // "codec init failed."
            errorDescrip = @"连接视频失败";
            break;
        case PLPlayerErrorHWCodecInitFailed:
            // = -2202, // "hardware codec init faile."
            errorDescrip = @"视频解码失败";
            break;
        case PLPlayerErrorDecodeFailed:
            // = -2203,   // "decode failed."
            errorDescrip = @"视频解码失败";
            break;
        case PLPlayerErrorHWDecodeFailed:
            // = -2204, // "hardware decode failed."
            errorDescrip = @"视频解码失败";
            break;
        case PLPlayerErrorDecodeNoFrame:
            // = -2205, // "decode no frame."
            errorDescrip = @"视频解码失败";
            break;
        case PLPlayerErrorVideoSizeChange:
            // = -2206, // "video size change, should stop and replay."
            errorDescrip = @"视频播放错误";
            break;
        case PLPlayerErrorRTMPErrorUnknowOption:
            // = -999, // "Unknown option %s"
            errorDescrip = @"视频播放错误";
            break;
        case PLPlayerErrorRTMPErrorAccessDNSFailed:
            // = -1000,    // "Failed to access the DNS. (addr: %s)"
            errorDescrip = @"视频域名解析失败";
            break;
        case PLPlayerErrorRTMPErrorFailedToConnectSocket:
            // = -1001, // "Failed to connect socket. %d (%s)"
            errorDescrip = @"视频连接失败";
            break;
        case PLPlayerErrorRTMPErrorSocksNegotiationFailed:
            // = -1002, // "Socks negotiation failed"
            errorDescrip = @"视频连接失败";
            break;
        case PLPlayerErrorRTMPErrorFailedToCreateSocket:
            // = -1003, // " %d (%s)"
            errorDescrip = @"视频连接失败";
            break;
        case PLPlayerErrorRTMPErrorHandshakeFailed:
            // = -1004,    // "Handshake failed"
            errorDescrip = @"视频连接失败";
            break;
        case PLPlayerErrorRTMPErrorRTMPConnectFailed:
            // = -1005, // "RTMP connect failed"
            errorDescrip = @"视频连接失败";
            break;
        case PLPlayerErrorRTMPErrorSendFailed:
            // = -1006, // "Send error %d (%s), (%d bytes)"
            errorDescrip = @"视频连接失败";
            break;
        case PLPlayerErrorRTMPErrorServerRequestedClose:
            // = -1007, //    "RTMP server requested close"
            errorDescrip = @"视频连接失败";
            break;
        case PLPlayerErrorRTMPErrorNetStreamFailed:
            // = -1008, // "NetStream failed"
            errorDescrip = @"视频连接失败";
            break;
        case PLPlayerErrorRTMPErrorNetStreamPlayFailed:
            // = -1009, // "NetStream play failed"
            errorDescrip = @"视频播放失败";
            break;
        case PLPlayerErrorRTMPErrorNetStreamPlayStreamNotFound:
            // = -1010, // "NetStream play stream not found"
            errorDescrip = @"视频连接失败";
            break;
        case PLPlayerErrorRTMPErrorNetConnectionConnectInvalidApp:
            // = -1011, // "NetConnection connect invalip app"
            errorDescrip = @"视频连接失败";
            break;
        case PLPlayerErrorRTMPErrorSanityFailed:
            // = -1012, //    "Sanity failed. Trying to send header of type: 0x%02X"
            errorDescrip = @"视频播放失败";
            break;
        case PLPlayerErrorRTMPErrorSocketClosedByPeer:
            // = -1013, // "RTMP socket closed by peer"
            errorDescrip = @"视频连接失败";
            break;
        case PLPlayerErrorRTMPErrorRTMPConnectStreamFailed:
            // = -1014,    // "RTMP connect stream failed"
            errorDescrip = @"视频连接失败";
            break;
        case PLPlayerErrorRTMPErrorTLSConnectFailed:
            //// SSL errors = -1200,    //    "TLS_Connect failed"
            errorDescrip = @"视频连接失败";
            break;
        case PLPlayerErrorRTMPErrorNoSSLOrTLSSupport:
            // = -1201,    //    "No SSL/TLS support"
            errorDescrip = @"视频连接失败";
            break;
        case PLPlayerErrorHTTPErrorHTTPConnectFailed:
            // = -1202, // "HTTP connect failed"
            errorDescrip = @"视频连接失败";
            break;
        default:
            break;
    }
    
    return errorDescrip;
}


@end
