//
//  APPAudioLocalPlayer.h
//  CleverBaby
//  专门播放本地音频
//  Created by 峰 on 2019/12/3.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPAudioLocalPlayer : NSObject

+ (instancetype)shareInstance;

///播放完毕
@property (nonatomic,copy) APPBackBlock blockComplte;

///播放出错
@property (nonatomic,copy) APPBackBlock blockError;

///播放停止
@property (nonatomic,copy) APPBackBlock blockStop;

///播放本地音频文件
- (void)playLocalAudio:(NSString *)audioName;

///播放音频
- (void)playAudioUrl:(NSString *)url;

///播放Data
- (void)playAudioData:(NSData *)audioData;

///暂停播放
- (void)stopPlay;

@end

NS_ASSUME_NONNULL_END
