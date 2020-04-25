//
//  APPAudioLocalPlayer.m
//  CleverBaby
//
//  Created by 峰 on 2019/12/3.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import "APPAudioLocalPlayer.h"

#import <AVFoundation/AVFoundation.h>

@interface APPAudioLocalPlayer () <AVAudioPlayerDelegate>

///系统播放器
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@end

@implementation APPAudioLocalPlayer


+ (instancetype)shareInstance {
    static APPAudioLocalPlayer *audioPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayer = [[APPAudioLocalPlayer alloc] init];
    });
    return audioPlayer;
}

- (void)deallocBlock {
    self.blockComplte = ^(BOOL result, id idObject) {
        
    };
    self.blockStop = ^(BOOL result, id idObject) {
        
    };
    self.blockError = ^(BOOL result, id idObject) {
        
    };
}

#pragma mark - 视图布局

///播放本地音频文件
- (void)playLocalAudio:(NSString *)audioName {
    
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:audioName ofType:@".mp3"];
    
    [self playAudioUrl:audioPath];
}

///播放音频
- (void)playAudioUrl:(NSString *)url {
    
    NSData *audioData;
    if ([url hasPrefix:@"http"]) {
        //网络
        audioData = [NSData dataWithContentsOfURL:[NSURL gf_URLWithString:url]];
    }else{
        //本地音频
        audioData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:url]];
    }
    
    if (audioData) {
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
        if (!error) {
            _audioPlayer.delegate = self;
            [_audioPlayer prepareToPlay];
            [_audioPlayer play];
        }else{
            if (self.blockError) {
                self.blockError(YES, @"播放错误");
            }
        }
    }else{
        if (self.blockError) {
            self.blockError(YES, @"播放错误");
        }
    }
}

///播放Data
- (void)playAudioData:(NSData *)audioData {
    
    if (audioData) {
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
        if (!error) {
            _audioPlayer.delegate = self;
            [_audioPlayer prepareToPlay];
            [_audioPlayer play];
        }else{
            if (self.blockError) {
                self.blockError(YES, @"播放错误");
            }
        }
    }else{
        if (self.blockError) {
            self.blockError(YES, @"播放错误");
        }
    }
}

///暂停播放
- (void)stopPlay {
    
    if (_audioPlayer) {
        [_audioPlayer stop];
        if (self.blockStop) {
            self.blockStop(YES, @0);
        }
    }
}


#pragma mark - 业务处理
/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    if (self.blockComplte) {
        self.blockComplte(YES, @0);
    }
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    if (self.blockError) {
        self.blockError(YES, @"播放错误");
    }
}

@end
