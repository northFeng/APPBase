//
//  APPAudioNetPlayer.m
//  CleverBaby
//
//  Created by 峰 on 2020/4/20.
//  Copyright © 2020 North_feng. All rights reserved.
//

#import "APPAudioNetPlayer.h"

#import <FreeStreamer/FSAudioStream.h>

@interface APPAudioNetPlayer ()

///音频播放对象
@property (nonatomic,strong) FSAudioStream *audioStream;

///定时器
@property (nonatomic,strong) NSTimer *timer;

///是否出错
@property (nonatomic,assign) BOOL isError;

///播放URL
@property (nonatomic,copy) NSString *playUrl;

@end

@implementation APPAudioNetPlayer

+ (instancetype)shareInstance {
    static APPAudioNetPlayer *audioPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayer = [[APPAudioNetPlayer alloc] init];
    });
    return audioPlayer;
}

- (instancetype)init {
    if (self = [super init]) {
        
        _isError = NO;
        _playUrl = @"";
    }
    return self;
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
}

- (FSAudioStream *)audioStream {
    if (!_audioStream) {
        FSStreamConfiguration *stramConfig = [[FSStreamConfiguration alloc] init];
        stramConfig.cacheEnabled = YES;//是否可以缓存
        stramConfig.seekingFromCacheEnabled = YES;//有缓存时，是否先播放缓存
        stramConfig.maxDiskCacheSize = 101000000; //最大缓存101 MB
        //stramConfig.cacheDirectory = [APPFileManager auidoCachePath];//缓存路径(默认Document文件)
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
    [self.timer setFireDate:[NSDate distantPast]];
}

///暂停定时器
- (void)timerPause {
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (BOOL)isPlaying {
    return [self.audioStream isPlaying];
}

///播放 音频URL
- (void)playAudioFromoUrl:(NSString *)url {
    _playUrl = url;
    if (url.length) {
        //先播放（否则切换会失败) (如果暂停播放了，切换上下首则播放器不会切换---在播放状态下，会切换！，这里必须先是播放中，再切换)
        if (![self isPlaying]) {
            [self.audioStream pause];
        }
        if ([url hasPrefix:@"http"]) {
            //网络
            [self.audioStream playFromURL:[NSURL gf_URLWithString:url]];
        }else{
            //本地
            [self.audioStream playFromURL:[NSURL fileURLWithPath:url]];
        }
    }else{
        //暂停播放
        [self pauseAudio];//暂停
        AlertMessage(@"音频错误");
    }
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

#pragma mark - ************************* 事件监控 && 定时器事件 *************************

///监听播放状态变化
- (void)addObserverAudioPlayStateChange {
    
    //播放完成回调
    WeakSelf(self);
    _audioStream.onCompletion = ^{
        //播放完成
        if (weakSelf.blockComplte) {
            weakSelf.blockComplte(YES, @0);
        }
    };
    
    //各个状态改变
    /**
    _audioStream.onStateChange = ^(FSAudioStreamState state) {
                
        switch (state) {
        
            case kFsAudioStreamRetrievingURL:       // 检索url
                NSLog(@"检索url");
                //加载
                break;
                
            case kFsAudioStreamStopped:              // 停止
                NSLog(@"播放停止");
                
                break;
                
            case kFsAudioStreamBuffering:           // 缓冲
                NSLog(@"缓冲中。。");
                
                break;
                
            case kFsAudioStreamPlaying:             // 播放
                NSLog(@"播放中。。");
                weakSelf.isError = NO;
                
                break;
                
            case kFsAudioStreamPaused:              // 暂停
                NSLog(@"播放暂停");
                
                
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
                
                break;
                
            case kFsAudioStreamRetryingStarted:     // 检索开始
                NSLog(@"检索开始");

                break;
                
            case kFsAudioStreamRetryingSucceeded:   // 检索成功
                NSLog(@"检索成功");

                break;
            
            casekFsAudioStreamRetryingFailed:       // 检索失败
                NSLog(@"检索失败");
                
                break;
            
            case kFsAudioStreamPlaybackCompleted:   // 播放完成
                NSLog(@"播放完成");
                
                break;
            
            case kFsAudioStreamUnknownState:       // 未知状态
                NSLog(@"未知状态");
                
                break;
            
                
            default:
                break;
        }
                
    };
     */
    
    _audioStream.onFailure = ^(FSAudioStreamError error, NSString *errorDescription) {
        weakSelf.isError = YES;
        
        if (weakSelf.blockError) {
            weakSelf.blockError(YES, @"播放错误");
        }
    };
}

///定时器事件
- (void)timerEvent {
    if (self.blockTime) {
        
        NSInteger playbackTime = self.audioStream.currentTimePlayed.playbackTimeInSeconds / 1;
        NSInteger totalTime = self.audioStream.duration.playbackTimeInSeconds / 1;
        
        self.blockTime(YES, @[@(playbackTime),@(totalTime)]);
    }
}


@end
