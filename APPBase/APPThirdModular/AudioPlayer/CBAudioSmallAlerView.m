//
//  CBAudioSmallAlerView.m
//  CleverBaby
//
//  Created by 峰 on 2019/12/21.
//  Copyright © 2019 小神童. All rights reserved.
//

#import "CBAudioSmallAlerView.h"

#import "APPAudioPlayerController.h"

/**
 *  小框状态
 */
typedef NS_ENUM(NSInteger,CBSmallAudioState) {
    /**
     *  隐藏
     */
    CBSmallAudioState_hide = 0,
    /**
     *  显示
     */
    CBSmallAudioState_show = 1,
    /**
     *  关闭
     */
    CBSmallAudioState_Close = 2,
};

@interface CBAudioSmallAlerView ()

///定时器
@property (nonatomic,strong) NSTimer *timer;

///状态
@property (nonatomic,assign) CBSmallAudioState smallState;


@end

@implementation CBAudioSmallAlerView
{
    UIImageView *_imgAudio;//音频头像
    
    UILabel *_titleLabel;//标题
    
    UIButton *_playBtn;//播放按钮
    
    UIButton *_closeBnt;//关闭按钮
}

///单利
+ (instancetype)shareInstance
{
    static CBAudioSmallAlerView *aletView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aletView = [[self alloc] init];
    });
    return aletView;
}

- (void)dealloc {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 视图布局
//初始化
- (instancetype)init {
    
    if (self = [super init]) {
        self.backgroundColor = COLOR(@"#6C757B");
        self.layer.cornerRadius = 11.5;
        [self createView];
    }
    return self;
}


//创建视图
- (void)createView{
    
    _smallState = CBSmallAudioState_hide;
    _closeAudio = YES;//默认关闭
    
    _imgAudio = [APPViewTool view_createImageViewWithImageName:@""];
    [APPViewTool view_addBorderOnView:_imgAudio borderWidth:2 borderColor:APPColorFunction.whiteColor cornerRadius:FitIpad(25)];
    _imgAudio.layer.masksToBounds = YES;
    [self addSubview:_imgAudio];
    
    _titleLabel = [APPViewTool view_createLabelWithText:@"" font:kFontOfCustom(kMediumFont, FitIpad(17)) textColor:APPColorFunction.whiteColor textAlignment:(NSTextAlignmentLeft)];
    [self addSubview:_titleLabel];
    
    _playBtn = [APPViewTool view_createButtonImageNormalImg:@"audio_play_small" selectImg:@"audio_play_pause"];
    _playBtn.selected = NO;
    [self addSubview:_playBtn];
    
    _closeBnt = [APPViewTool view_createButtonImage:@"audio_play_close"];
    [self addSubview:_closeBnt];
    
    //约束布局
    
    //_imgAudio.sd_layout.leftSpaceToView(self, 8*kScaleW).centerYEqualToView(self).widthIs(FitIpad(50)).heightIs(FitIpad(50));
    _imgAudio.frame = CGRectMake(8*kScaleW, (FitIpad(62) - FitIpad(50))/2., FitIpad(50), FitIpad(50));
    
    _closeBnt.sd_layout.rightSpaceToView(self, 10*kScaleW).centerYEqualToView(self).widthIs(FitIpad(26)).heightIs(FitIpad(26));
    _playBtn.sd_layout.rightSpaceToView(_closeBnt, 15*kScaleW).centerYEqualToView(_closeBnt).widthIs(FitIpad(26)).heightIs(FitIpad(26));
    
    _titleLabel.sd_layout.leftSpaceToView(self, 15*kScaleW + FitIpad(50)).centerYEqualToView(self).heightIs(FitIpad(24)).rightSpaceToView(_playBtn, 10*kScaleW);
    
    
    [_playBtn addTarget:self action:@selector(onClickBtnPlay) forControlEvents:UIControlEventTouchUpInside];
    [_closeBnt addTarget:self action:@selector(onClickBtnClose) forControlEvents:UIControlEventTouchUpInside];
    
    //添加点击手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickTapGrsture)];
    [self addGestureRecognizer:tapGes];
}

///点击播放
- (void)onClickBtnPlay {
    
    //允许 手机网络播放
    [self gotoPlayAudio];
}

///进行播放
- (void)gotoPlayAudio {
    
    _playBtn.selected = !_playBtn.selected;
    
    if (_playBtn.selected) {
        //播放
        [[APPAudioPlayer shareInstance] playAudio];
    }else{
        //暂停
        [[APPAudioPlayer shareInstance] pauseAudio];//暂停
    }
}


#pragma mark - ************************* 播放器代理 *************************
///音乐当前item
- (void)currentPlayItem:(APPAudioItem *)playItem {
    
    _titleLabel.text = playItem.title;
    [_imgAudio sd_setImageWithURL:[NSURL gf_URLWithString:playItem.imgUrl] placeholderImage:ImageNamed(@"placeholder_baby")];
}

///获取播放总时长
- (void)getPlayTotalTime {
    
}

///回调当前播放状态
- (void)audioPlayStateChange:(AudioPlayState)playState {
    
    switch (playState) {
        case AudioPlayState_loading:
            //加载中...
            
            break;
        case AudioPlayState_playing:
        {
            //开始播放
            [self timerStart];//开启定时器
            _playBtn.selected = YES;
            
            [self getPlayTotalTime];//获取总时长
        }
            break;
        case AudioPlayState_pause:
            //暂停播放
            _playBtn.selected = NO;
            [self timerPause];//暂停定时器
            break;
        case AudioPlayState_stop:
            //停止播放
            _playBtn.selected = NO;
            [self timerPause];//暂停定时器
            
            break;
        case AudioPlayState_error:
            //播放出错
            _playBtn.selected = NO;
            [self timerPause];//暂停定时器
            
            break;
        case AudioPlayState_complete:
            //播放完一首
            //[self onClickBtnNext];//进行下一首播放 (或者实现单利的block二选一！)
            break;
            
        default:
            break;
    }
}

///回调当前播放时间（单位秒）
- (void)audioCurrentPlayTime:(NSUInteger)seconds cureentplayProgress:(CGFloat)progress {
    
}

///缓存进度回调 （范围0~1.0）
- (void)audioBufferCacheProgress:(CGFloat)bufferProgress {
    
}

///倒计时还剩余的时间
- (void)countDownTimerSeconds:(NSInteger)seconds {
    
}

///播放出错
- (void)audioPlayError:(NSString *)errorInfo {
    
}

///定时器事件
- (void)timerEvent {
    //旋转图片
    CGAffineTransform trans = _imgAudio.transform;
    _imgAudio.transform = CGAffineTransformRotate(trans, M_PI_2 / 90);
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
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

#pragma mark - ************************* 业务逻辑 && 事件处理 *************************
///显示小播放器
- (void)showSmallAudioAlertView {
    _closeAudio = NO;
    
    if (_smallState != CBSmallAudioState_show) {
        self.hidden = NO;//显示弹框
        self.frame = CGRectMake(12*kScaleW, kScreenHeight - FitIpad(62) - kTabBarHeight - 5*kScaleW, kScreenWidth - 24*kScaleW, FitIpad(62));
        [[UIApplication sharedApplication].delegate.window addSubview:self];
        
        [APPAudioPlayer shareInstance].delegate = self;//夺回代理
        
        _smallState = CBSmallAudioState_show;//显示
    }
    
    //刷新页面数据
    [self currentPlayItem:[APPAudioPlayer shareInstance].playItem];//当前item
    if ([[APPAudioPlayer shareInstance] isPlaying]) {
        [self timerStart];//开启
        _playBtn.selected = YES;
    }else{
        [self timerPause];//关闭
        _playBtn.selected = NO;
    }
}

///隐藏小播放器
- (void)hideSmallAudioAlertView {
    
    [self timerPause];//关闭
    _playBtn.selected = NO;
    
    self.hidden = YES;
    
    [self removeFromSuperview];
    
    _smallState = CBSmallAudioState_hide;//隐藏
}

///点击关闭
- (void)onClickBtnClose {
    
    [[APPAudioPlayer shareInstance] closeAudioPlayerClearInfo];//关闭播放器
    
    [self timerPause];//暂停
    _playBtn.selected = NO;
    self.hidden = YES;//隐藏
    [self removeFromSuperview];//移除 ——> 清除锁屏界面信息
    
    _smallState = CBSmallAudioState_Close;//关闭
    
    _closeAudio = YES;
    
    //结束远程交互
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

///点击进入播放器
- (void)onClickTapGrsture {
    
    APPAudioPlayerController *audioVC = [[APPAudioPlayerController alloc] init];
    audioVC.formType = 2;
    [[APPAlertTool topViewControllerOfAPP].navigationController pushViewController:audioVC animated:YES];
}

///外部列表点击进行播放
- (void)clickAudioListToPlayAudioWithAudioArrayData:(NSArray *)audioArray index:(NSInteger)playIndex themeTitle:(NSString *)themeTitle {
    
    [APPAudioPlayer shareInstance].themeTitle = themeTitle;
    [APPAudioPlayer shareInstance].autoPlayNext = YES;//自动播放下一首
    [APPAudioPlayer shareInstance].lockScreen = YES;
    [APPAudioPlayer shareInstance].delegate = self;//捕获代理
    
    [[APPAudioPlayer shareInstance] playAudioArray:audioArray playIndex:playIndex];
    
    [self showSmallAudioAlertView];
}

@end
