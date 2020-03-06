//
//  APPVideoPlayerController.h
//  CleverBaby
//  视频播放VC
//  Created by 峰 on 2019/11/19.
//  Copyright © 2019 小神童. All rights reserved.
//

#import "APPBaseController.h"

#import "APPVideoListView.h"//列表view

NS_ASSUME_NONNULL_BEGIN

@interface APPVideoPlayerController : APPBaseController

///播放类型  0不标记  1亲子小课堂  2儿歌视频  3H5视频
@property (nonatomic,assign) NSInteger videoType;

///视频数据
@property (nonatomic,copy) NSArray <APPVideoItemModel *>*dataArray;

///视频列表位置
@property (nonatomic,assign) NSInteger indexVideo;

///当前视频URL
@property (nonatomic,copy) NSString *videoUrl;

///进入视频播放页面   视频类型： 0不标记  1亲子小课堂  2儿歌视频  3H5视频
+ (void)gotoVideoVCWithDataArray:(NSArray <APPVideoItemModel *>*)videoArray playIndex:(NSInteger)indexPlay fromSuperVC:(UIViewController *)superVC videoType:(NSInteger)videoType;

@end


///视频头部视图
@interface APPVideoHeaderView : UIButton

///视频切换模式 0:顺序循环播放(默认模式)  1:单首循环播放
@property (nonatomic,assign) NSInteger switchType;

///投屏电视按钮
@property (nonatomic,strong) UIButton *tvBtn;

///返回block
@property (nonatomic,copy) APPBackBlock blockBack;

///赋值标题
- (void)setVideoTitle:(NSString *)title;

- (CGFloat)viewHeight;

@end


///视频底部按钮条
@interface APPViderBottomView : UIView

///列表按钮
@property (nonatomic,strong) UIButton *listBtn;

///播放按钮点击回调
@property (nonatomic,copy) APPBackBlock blockPlay;

///设置播放按钮状态
- (void)setPlayBtnState:(BOOL)play;

///设置滑动条代理
- (void)setSliderDelegate:(id)delegate;

///设置时间
- (void)setTimeShowString:(NSString *)timeString;

///设置缓存进度
- (void)setBufferProgress:(CGFloat)bufferProgress;

///设置播放进度
- (void)setSliderProgress:(CGFloat)progress;

///当前播放进度
- (CGFloat)progressValue;

- (CGFloat)height;


@end

NS_ASSUME_NONNULL_END
