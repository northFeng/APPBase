//
//  APPAudioPlayerVM.h
//  CleverBaby
//  音乐播放器VM
//  Created by 峰 on 2020/3/4.
//  Copyright © 2020 小神童. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPAudioPlayerVM : NSObject

///定时器信号事件
@property (nonatomic,strong) RACSubject *timerAction;


///定时器
@property (nonatomic,strong) NSTimer *timer;

///销毁定时器
- (void)deallocTimer;

///开启定时器
- (void)timerStart;

///暂停定时器
- (void)timerPause;


//--------------------------------------- 按钮点击事件 ---------------------------------------
///分享事件
+ (void)shareActionWithThemeTitle:(NSString *)themeTitle;

///进行儿歌收藏
+ (void)collectionSongWithAcgtionBtn:(UIButton *)collectBtn;

//--------------------------------------------------------------------------------------------

///查询改儿歌收藏状态
+ (void)getSongCollectionStateWithButton:(UIButton *)collectBtn;


@end

NS_ASSUME_NONNULL_END
