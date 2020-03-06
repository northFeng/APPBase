//
//  APPAudioPlayerController.h
//  CleverBaby
//  播放器界面VC
//  Created by 峰 on 2019/11/22.
//  Copyright © 2019 小神童. All rights reserved.
//

#import "APPBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface APPAudioPlayerController : APPBaseController

///播放列表list
@property (nonatomic,copy) NSArray <APPAudioItem *>*audioArray;

///播放位置
@property (nonatomic,assign) NSInteger playIndex;

///页面上一级来源  0:1 播放列表  2:播放器全局框
@property (nonatomic,assign) NSInteger formType;

///播放类型title
@property (nonatomic,copy) NSString *themeTitle;


@end

NS_ASSUME_NONNULL_END
