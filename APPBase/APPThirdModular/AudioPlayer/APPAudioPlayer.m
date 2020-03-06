//
//  APPAudioPlayer.m
//  CleverBaby
//
//  Created by 峰 on 2019/11/13.
//  Copyright © 2019 小神童. All rights reserved.
//

#import "APPAudioPlayer.h"

#import <FreeStreamer/FSAudioStream.h>

#import <AVFoundation/AVFoundation.h>//系统音视频框架

//锁屏播放
#import <MediaPlayer/MediaPlayer.h>

#import "APPFileManager.h"

///音频item
@implementation APPAudioItem



@end

@interface APPAudioPlayer ()

///音频播放对象
@property (nonatomic,strong) FSAudioStream *audioStream;

///定时器
@property (nonatomic,strong) NSTimer *timer;

///倒计时计时器
@property (nonatomic,strong) NSTimer *countDownTime;

///是否出错
@property (nonatomic,assign) BOOL isError;

@end

@implementation APPAudioPlayer
{
    BOOL _isOpen;//是否打开定时器
    
    UIBackgroundTaskIdentifier _bgTaskId;//
    
    NSInteger _countDownSeconds;//倒计时
    
    BOOL _isConeectSysetemContorl;//是否连接屏幕控制音乐
    
}

- (void)dealloc {
    
    [self deallocObserve];//释放监听者
}

///释放监听者
- (void)deallocObserve {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_audioStream) {
        _audioStream.onCompletion = nil;
        _audioStream.onStateChange = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

///单利播放器
+ (instancetype)shareInstance
{
    static APPAudioPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[self alloc] init];
    });
    return player;
}

- (instancetype)init {
    if (self = [super init]) {
        
        //初始化默认参数
        _indexItem = 0;//默认0
        _audioSourceArray = @[];
        _playRate = 1.0;
        _isOpen = NO;
        _autoPlayNext = NO;
        _loopType = AudioPlayLoopType_order;
        _playState = AudioPlayState_loading;//默认为加载中
        
        _lockScreen = NO;//默认关闭锁屏关联
        
        _countDownSeconds = 0;//从0开始
        
        _isError = NO;
        
        _isConeectSysetemContorl = NO;
        
        //监听播放中断事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterrupted:) name:AVAudioSessionInterruptionNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];//设置通知
        
        //接收网络状态变化通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityNetStateChanged:) name:_kGlobal_NetworkingReachabilityChangeNotification object:nil];
    }
    return self;
}

- (FSAudioStream *)audioStream {
    if (!_audioStream) {
        FSStreamConfiguration *stramConfig = [[FSStreamConfiguration alloc] init];
        stramConfig.cacheEnabled = YES;//是否可以缓存
        stramConfig.seekingFromCacheEnabled = YES;//有缓存时，是否先播放缓存
        stramConfig.maxDiskCacheSize = 101000000; //最大缓存101 MB
        stramConfig.cacheDirectory = [APPFileManager auidoCachePath];//缓存路径(默认Document文件)
        _audioStream = [[FSAudioStream alloc] initWithConfiguration:stramConfig];
        _audioStream.maxRetryCount = 1;//加载失败重连次数
    }
    if (_audioStream) {
        [self addObserverAudioPlayStateChange];
    }
    return _audioStream;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
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

- (APPAudioItem *)playItem {
    if (!_playItem) {
        _playItem = [_audioSourceArray gf_getItemWithIndex:_indexItem];
    }
    return _playItem;
}

- (void)setIsError:(BOOL)isError {
    _isError = isError;
}

#pragma mark - ************************* 网络监测 *************************
///网络状态发生变化触发事件
- (void)reachabilityNetStateChanged:(NSNotification *)noti{
    
    /**
    StatusUnknown           = -1, //未知网络
    StatusNotReachable      = 0,    //没有网络
    StatusReachableViaWWAN  = 1,    //手机自带网络
    StatusReachableViaWiFi  = 2     //wifi
     */
    
    if ([APPHttpTool sharedNetworking].networkStats != StatusReachableViaWiFi) {
        //非WiFi网络
        //不允许手机网络播放
        if ([self isPlaying]) {
            //停止播放
            [self pauseAudio];
        }
    }
}



#pragma mark - ************************* 播放功能 *************************

- (BOOL)isPlaying {
    return [self.audioStream isPlaying];
}

///获取当前播放音频时长
- (NSUInteger)getCureentAudioDuration {
    
    return self.audioStream.duration.playbackTimeInSeconds * 1;
}

//--------------------------------------- 播放控制 ---------------------------------------

///播放 音频数组
- (void)playAudioArray:(NSArray *)audioSourceArray playIndex:(NSUInteger)index {
    
    if (audioSourceArray.count && [audioSourceArray gf_getItemWithIndex:index]) {
        _audioSourceArray = audioSourceArray;
        _indexItem = index;
        [self playAudioItem];//播放
    }
}

///从指定位置开始播放
- (void)playAudioOnIndex:(NSUInteger)playIndex {
    
    if ([_audioSourceArray gf_getItemWithIndex:playIndex]) {
        _indexItem = playIndex;
        [self playAudioItem];
    }
}

///播放 音频URL
- (void)playAudioFromoUrl:(NSString *)url {
    if (url.length) {
        _playUrl = url;
        
        //先播放（否则切换会失败) (如果暂停播放了，切换上下首则播放器不会切换---在播放状态下，会切换！，这里必须先是播放中，再切换)
        if (![self isPlaying]) {
            [self.audioStream pause];
        }
        [self.audioStream playFromURL:[NSURL gf_URLWithString:url]];
    }else{
        //暂停播放
        [self pauseAudio];//暂停
    }
}

///从指定进度开始播放
- (void)playAudioFromOffset:(CGFloat)offset {
    
    /**
    FSSeekByteOffset position;
    //position.start = (UInt64)[self getCureentAudioDuration] *offset;
    //position.end = [self getCureentAudioDuration];
    position.position = offset;
    [self.audioStream playFromOffset:position];
     */
    self.audioStream.volume = 0.;
    [self seekToPositon:offset];
    self.audioStream.volume = 1.;
}

///播放
- (void)playAudio {
    
    if (_isError) {
        //出错
        [self playAudioFromoUrl:_playUrl];
    }else{
        //正常播放
        if (![self isPlaying]) {
            
            [self.audioStream pause];
        }
    }
}

///暂停播放
- (void)pauseAudio {
    
    if ([self isPlaying]) {
        [self.audioStream pause];
    }
}

///停止播放（停止音频流加载）
- (void)stopAuido {
    
    [self.audioStream stop];
}

///上一首
- (void)upAudioPaly {
    
    if (_loopType == AudioPlayLoopType_random) {
        //随机
        _indexItem = arc4random()%_audioSourceArray.count;
    }else{
        //顺序上一首
        _indexItem --;
        
        if (_indexItem < 0) {
            _indexItem = _audioSourceArray.count - 1;//切换到最后一首
        }
    }
    
    [self playAudioItem];
}

///下一首
- (void)nextAudioPalay {
    
    if (_loopType == AudioPlayLoopType_random) {
        //随机
        _indexItem = arc4random()%_audioSourceArray.count;
    }else{
        //顺序下一首
        _indexItem ++;
        
        if (_indexItem > (_audioSourceArray.count - 1)) {
            _indexItem = 0;//切换到第一首
        }
    }
    
    [self playAudioItem];
}

///播放完内部自动切换触发下一首
- (void)autoPlayNextItem {
    
    switch (_loopType) {
        case AudioPlayLoopType_order:
            //依次顺序播放
        {
            _indexItem ++;
            
            if (_indexItem > (_audioSourceArray.count - 1)) {
                _indexItem = 0;//切换到第一首
            }
        }
            break;
        case AudioPlayLoopType_random:
            //随机播放
        {
            _indexItem = arc4random()%_audioSourceArray.count;
        }
            break;
        case AudioPlayLoopType_repet:
            //重复
            _playUrl = nil;
            break;
            
        default:
            break;
    }
    [self playAudioItem];
}

///播放Item
- (void)playAudioItem {
    
    APPAudioItem *item = [_audioSourceArray gf_getItemWithIndex:_indexItem];
    if (item) {
                
        if (_audioSourceArray.count == 1 || ![item.audioUrl isEqualToString:_playUrl]) {
            //一首歌 || 不同的URL
            
            _playUrl = item.audioUrl;
            
            [self playAudioFromoUrl:item.audioUrl];
            
            //切换当前播放的model
            _playItem.isPlaying = NO;//上一首
            _playItem = item;
            _playItem.isPlaying = YES;//当前正在播放
            
            [self setIsError:NO];
            
            //[APPNotificationCenter postNotificationName:_kGlobal_audioPlayNewItem object:nil];//通知外部播放新的item
        }
        
        //回调播放item
        if (self.delegate && [self.delegate respondsToSelector:@selector(currentPlayItem:)]) {
            [self.delegate currentPlayItem:item];//代理回调
        }
        
        if (_lockScreen) {
            [self setLockScreenNowPlayingInfo];//更新锁屏界面信息
            
            if (!_isConeectSysetemContorl) {
                _isConeectSysetemContorl = YES;
                [self createRemoteCommandCenter];//建立锁屏事件控制
            }
        }
    }
}

///指定位置播放
- (void)seekToPositon:(CGFloat)value {
    
    
    if ([self isPlaying]) {
        //正在播放
        FSStreamPosition position;
        
        if (value >= 1.0) {
            //播放结束
            value = 0.999;
            
            //position.position = value;
            //[self.audioStream seekToPosition:position];
            if (self.audioSourceArray.count) {
               [self nextAudioPalay];//播放下一首
            }
        }else{
            //赋值 ——> 跳到播放位置
            value = value == 0 ? 0.001 : value;
            position.position = value;
            
            [self.audioStream seekToPosition:position];
        }
        //0. 和 1.0 这个终端进度不能跳转播放，会播放失败，所以 播放0.001 ~ 0.999 之间
    }
}

///关闭播放器清除信息
- (void)closeAudioPlayerClearInfo {

    [self pauseAudio];
    [self stopAuido];
    
    _audioSourceArray = @[];
    _playItem = nil;
    _playUrl = @"";
    _indexItem = 0;
    self.delegate = nil;
    
    //清空锁屏
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:@{}];
    _isConeectSysetemContorl = NO;
    
    //[APPNotificationCenter postNotificationName:_kGlobal_audioPlayNewItem object:nil];//通知外部播放新的item
}

#pragma mark - ************************* 设置播放属性 *************************
- (void)setPlayRate:(CGFloat)playRate {
    if (playRate >= 0.2 && playRate <= 2.0) {
        _playRate = playRate;
        [self.audioStream setPlayRate:playRate];
    }
}


#pragma mark - ************************* 事件监控 && 定时器事件 *************************

///监听播放状态变化
- (void)addObserverAudioPlayStateChange {
    
    //播放完成回调
    WeakSelf(self);
    _audioStream.onCompletion = ^{
        if (weakSelf.playCompleteBlock) {
            weakSelf.playCompleteBlock(YES, @(weakSelf.indexItem));
        }
    };
    
    //各个状态改变
    _audioStream.onStateChange = ^(FSAudioStreamState state) {
        
        AudioPlayState playState = AudioPlayState_loading;
        
        switch (state) {
        
            case kFsAudioStreamRetrievingURL:       // 检索url
                NSLog(@"检索url");
                //加载
                break;
                
            case kFsAudioStreamStopped:              // 停止
                NSLog(@"播放停止");
                playState = AudioPlayState_stop;
                [weakSelf timerPause];//暂停定时器
                
                break;
                
            case kFsAudioStreamBuffering:           // 缓冲
                NSLog(@"缓冲中。。");
                //开始进行加载
                [weakSelf timerStart];//开启定时器
                
                break;
                
            case kFsAudioStreamPlaying:             // 播放
                NSLog(@"播放中。。");
                [weakSelf setIsError:NO];
                playState = AudioPlayState_playing;
                [weakSelf timerStart];//开启定时器
                if (weakSelf.lockScreen) {
                    [weakSelf setLookScreenCurrentTime];//修改锁屏上的当前播放时间
                }
                
                break;
                
            case kFsAudioStreamPaused:              // 暂停
                NSLog(@"播放暂停");
                playState = AudioPlayState_pause;
                [weakSelf timerPause];//暂停定时器
                
                break;
                
            case kFsAudioStreamSeeking:             // seek
                NSLog(@"seek中。。");
                //加载
                break;
                
            case kFSAudioStreamEndOfFile:           // 缓冲结束
                NSLog(@"缓冲结束");
                
                break;
                
            case kFsAudioStreamFailed:              // 播放失败
                NSLog(@"播放失败");
                playState = AudioPlayState_error;
                [weakSelf timerPause];//暂停定时器
                
                break;
                
            case kFsAudioStreamRetryingStarted:     // 检索开始
                NSLog(@"检索开始");

                break;
                
            case kFsAudioStreamRetryingSucceeded:   // 检索成功
                NSLog(@"检索成功");

                break;
            
            casekFsAudioStreamRetryingFailed:       // 检索失败
                NSLog(@"检索失败");
                playState = AudioPlayState_error;
                [weakSelf timerPause];//暂停定时器
                
                break;
            
            case kFsAudioStreamPlaybackCompleted:   // 播放完成
                NSLog(@"播放完成");
                playState = AudioPlayState_complete;
                if (weakSelf.autoPlayNext) {
                    //自动播放下一首
                    [weakSelf autoPlayNextItem];
                }
                
                break;
            
            case kFsAudioStreamUnknownState:       // 未知状态
                NSLog(@"未知状态");
                playState = AudioPlayState_error;
                [weakSelf timerPause];//暂停定时器
                
                break;
            
                
            default:
                break;
        }
        
        [weakSelf updatePlayState:playState];//更新状态
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(audioPlayStateChange:)]) {
            [weakSelf.delegate audioPlayStateChange:playState];
        }
    };
    
    _audioStream.onFailure = ^(FSAudioStreamError error, NSString *errorDescription) {
        
        [weakSelf pauseAudio];//暂停播放
        [weakSelf setIsError:YES];//出错
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(audioPlayError:)]) {
            
            NSString *errorInfo = @"播放错误";
            switch (error) {
                case kFsAudioStreamErrorNone:
                    
                    break;
                case kFsAudioStreamErrorOpen:
                    errorInfo = @"音频连接失败";
                    break;
                case kFsAudioStreamErrorStreamParse:
                    errorInfo = @"音频解析失败";
                    break;
                case kFsAudioStreamErrorNetwork:
                    errorInfo = @"网络错误";
                    break;
                case kFsAudioStreamErrorUnsupportedFormat:
                    errorInfo = @"不支持该音频播放";
                    break;
                case kFsAudioStreamErrorStreamBouncing:
                    errorInfo = @"网络繁忙";
                    break;
                case kFsAudioStreamErrorTerminated:
                    errorInfo = @"";
                    break;
                    
                default:
                    break;
            }
            NSLog(@"%@",errorInfo);
            [weakSelf.delegate audioPlayError:errorInfo];
        }
    };
}

///更新状态
- (void)updatePlayState:(AudioPlayState)playState {
    
    _playState = playState;//更新状态
}

///定时器事件
- (void)timerEvent {
    if (self.delegate) {
        
        //缓存进度回调
        if ([self.delegate respondsToSelector:@selector(audioBufferCacheProgress:)]) {
            
            //缓存监听
            float preBuffer      = (float)self.audioStream.prebufferedByteCount;
            float contentLength  = (float)self.audioStream.contentLength;
                
            // 这里获取的进度不能准确地获取到1
            float bufferProgress = contentLength > 0 ? preBuffer / contentLength : 0;
                
            //NSLog(@"缓冲进度%.2f", bufferProgress);
                
            // 为了能使进度准确的到1，这里做了一些处理
            CGFloat buffer = bufferProgress + 0.02;
                
            if (buffer > 1.) {
                buffer = 1.0;
            }
            
            [self.delegate audioBufferCacheProgress:buffer];
        }
        
        //播放时间变化
        if ([self.delegate respondsToSelector:@selector(audioCurrentPlayTime:cureentplayProgress:)]) {
            
            NSInteger playbackTime = self.audioStream.currentTimePlayed.playbackTimeInSeconds / 1;
            
            CGFloat progress = self.audioStream.currentTimePlayed.playbackTimeInSeconds / self.audioStream.duration.playbackTimeInSeconds;
            [self.delegate audioCurrentPlayTime:playbackTime cureentplayProgress:progress];
        }
    }
}

///当前播放时间
- (NSInteger)currentTimePlayed {
    NSInteger playbackTime = 0;
    if (_playItem) {
        playbackTime = self.audioStream.currentTimePlayed.playbackTimeInSeconds / 1;
    }
    return playbackTime;
}

///持续时间
- (NSInteger)durationTime {
    
    NSInteger duration = 0;
    
    if (_playItem) {
        duration = self.audioStream.duration.playbackTimeInSeconds / 1;
    }
    return duration;
}

///播放中断通知事件
- (void)audioSessionInterrupted:(NSNotification *)notification {
    NSLog(@"中断事件触发");
    //通知类型
    NSNumber *interruptionType = [notification.userInfo objectForKey:AVAudioSessionInterruptionTypeKey];
    AVAudioSessionInterruptionOptions options = [notification.userInfo[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
    switch (interruptionType.unsignedIntegerValue) {

        case AVAudioSessionInterruptionTypeBegan:
        {
            [self pauseAudio];//暂停
        }
            break;
        case AVAudioSessionInterruptionTypeEnded:
        {
            if (options == AVAudioSessionInterruptionOptionShouldResume) {
                //触发重新播放
                [self playAudio];//播放
            }
        }
            break;
        default:
            break;
    }
}

//通知方法的实现
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];

    dispatch_async(dispatch_get_main_queue(), ^{
        switch (routeChangeReason) {
            case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
                NSLog(@"耳机插入");
                
                break;
            case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
                NSLog(@"耳机拔出");
                [self pauseAudio];//暂停播放
                break;
            case AVAudioSessionRouteChangeReasonCategoryChange:
                // called at start - also when other audio wants to play

                break;
        }
    });
    
}


#pragma mark - ************************* 锁屏信息设置 *************************
///APP进入后台开始接受 外部控制事件
- (void)appEnterBackground {
    
    if (_lockScreen) {
        //设置并激活音频会话类别
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        //允许应用程序接收远程控制
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        //设置后台任务ID
        //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
        _bgTaskId = [self backgroundPlayerID:_bgTaskId];
        //其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
    }
}

- (UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId {
    
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId != UIBackgroundTaskInvalid && backTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

// 改变锁屏歌曲信息
- (void)setLockScreenNowPlayingInfo {

    //更新锁屏时的歌曲信息
    NSLog(@"锁屏界面");
    if (_playItem) {
        
        [self setLookScreenCurrentTime];
        
        //开启远程交互
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
}

///更改当前播放时间
- (void)setLookScreenCurrentTime {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    // 歌曲名
    [dict gf_setObject:self.playItem.title withKey:MPMediaItemPropertyTitle];
    // 演唱者
    [dict gf_setObject:self.playItem.subTitle withKey:MPMediaItemPropertyArtist];
    // 专辑名
    //[dict setObject:@"" forKey:MPMediaItemPropertyAlbumTitle];

    // 歌曲总时长   01:58  这行代码一定要放在播放音乐之后
    NSNumber *duration = [NSNumber numberWithInteger:[self getCureentAudioDuration]];
    [dict gf_setObject:duration withKey:MPMediaItemPropertyPlaybackDuration];
    
    //当前播放时间
    NSInteger playbackTime = self.audioStream.currentTimePlayed.playbackTimeInSeconds / 1;
    [dict gf_setObject:@(playbackTime) withKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //专辑缩略图 ——> 可以进行异步加载图片加载完后再次 ，把信息投送到锁屏界面
        UIImage *newImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL gf_URLWithString:self.playItem.imgUrl]]];
        if (newImage) {
           [dict gf_setObject:[[MPMediaItemArtwork alloc] initWithImage:newImage] withKey:MPMediaItemPropertyArtwork];
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            //设置锁屏状态下屏幕显示播放音乐信息
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        });
    });
}


#pragma mark - ************************* 锁屏外部控制事件处理 *************************

///iOS7.0版本之后的控制锁屏信息
- (void)createRemoteCommandCenter {
        
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
        
    //MPFeedbackCommand对象反映了当前App所播放的反馈状态. MPRemoteCommandCenter对象提供feedback对象用于对媒体文件进行喜欢, 不喜欢, 标记的操作. 效果类似于网易云音乐锁屏时的效果
    
    [commandCenter.togglePlayPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        if ([self isPlaying]) {
            [self pauseAudio];
        }else{
            [self playAudio];
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];//耳机线控的暂停/播放
    
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self pauseAudio];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
        
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self playAudio];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"上一首");
        [self upAudioPaly];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
        
    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"下一首");
        [self nextAudioPalay];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
        
    //快进
    MPSkipIntervalCommand *skipBackwardIntervalCommand = commandCenter.skipForwardCommand;
    skipBackwardIntervalCommand.preferredIntervals = @[@(54)];
    skipBackwardIntervalCommand.enabled = YES;
    //[skipBackwardIntervalCommand addTarget:self action:@selector(skipBackwardEvent:)];
        
    //在控制台拖动进度条调节进度
    if (@available(iOS 9.1, *)) {
        [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            
            NSUInteger totlaTime = [self getCureentAudioDuration];
            
            MPChangePlaybackPositionCommandEvent *playbackPositionEvent = (MPChangePlaybackPositionCommandEvent *)event;
            
            [self seekToPositon:(playbackPositionEvent.positionTime / totlaTime)];//跳进度
            
            return MPRemoteCommandHandlerStatusSuccess;
        }];
    } else {
        // Fallback on earlier versions
    }
}

/**
///iOS7之前 处理远程控制事件！
- (void)handleRemoteControlReceivedWithEvent:(UIEvent *)event {
    NSLog(@"远程控制");
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            {
                //点击播放按钮或者耳机线控中间那个按钮
                [self playAudio];
            }
                break;
            case UIEventSubtypeRemoteControlPause:
            {
                //点击暂停按钮
                [self pauseAudio];
            }
                break;
            case UIEventSubtypeRemoteControlStop :
            {
                //点击停止按钮
                [self stopAuido];
            }
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
            {
                //点击播放与暂停开关按钮(iphone抽屉中使用这个)  单击暂停键：103
                if ([self isPlaying]) {
                    [self pauseAudio];
                }else{
                    [self playAudio];
                }
            }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
            {
                //点击下一曲按钮或者耳机中间按钮两下  双击暂停键：104
                [self nextAudioPalay];
            }
                break;
            case  UIEventSubtypeRemoteControlPreviousTrack:
            {
                //点击上一曲按钮或者耳机中间按钮三下  三击暂停键：105
                [self upAudioPaly];
            }
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
            {
                //快退开始 点击耳机中间按钮三下不放开
            }
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
            {
                //快退结束 耳机快退控制松开后
            }
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
            {
                //开始快进 耳机中间按钮两下不放开  单击，再按下不放：10
            }
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
            {
                //快进结束 耳机快进操作松开后  单击，再按下不放，松开时：109
            }
                break;
                
            default:
                break;
        }
        
    }
}
 */

#pragma mark - ************************* 倒计时器功能 *************************
///开始进行倒计时
- (void)startCountDownTimeOfDuration:(NSInteger)duration {
    
    _countDownSeconds = duration;
    [self.countDownTime setFireDate:[NSDate distantPast]];//开启定时器
}

- (NSTimer *)countDownTime {
    
    if (!_countDownTime) {
        _countDownTime = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDownTimeEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_countDownTime forMode:NSRunLoopCommonModes];
        [_countDownTime setFireDate:[NSDate distantFuture]];//暂停定时器
    }
    return _countDownTime;
}

///倒计时事件
- (void)countDownTimeEvent {
    
    _countDownSeconds --;
    
    if (_countDownSeconds <= 0) {
        _countDownSeconds = 0;
        
        //倒计时为0 ——> 停止倒计时 ——> 停止播放
        if (_countDownTime) {
            [_countDownTime setFireDate:[NSDate distantFuture]];//暂停定时器
            //清空定时器
            [_countDownTime invalidate];
            _countDownTime = nil;
        }
        //停止播放
        if ([self isPlaying]) {
            [self pauseAudio];//暂停
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(countDownTimerSeconds:)]) {
        [self.delegate countDownTimerSeconds:_countDownSeconds];//回调剩余时间
    }
}

///获取当前歌词
+ (void)getCurrentAudioLyricsWithBlock:(APPBackBlock)blockResult {
    
    NSMutableDictionary *dicJson = [NSMutableDictionary dictionary];
    [dicJson gf_setObject:[APPAudioPlayer shareInstance].playItem.lyricsId withKey:@"yearId"];
    
    [APPHttpTool getRequestNetDicDataUrl:@"v2/front/singsongsword" params:dicJson WithBlock:^(BOOL result, id  _Nonnull idObject, NSInteger code) {
        
        if (result) {
            NSString *lyricsText = ((NSDictionary *)idObject)[@"lyrics"];
            [APPAudioPlayer shareInstance].playItem.audioLyrics = lyricsText;
            
            blockResult(YES,lyricsText);
        }else{
            blockResult(NO,(NSString *)idObject);
        }
    }];
}


@end
