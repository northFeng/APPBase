//
//  APPAudioPlayerController.m
//  CleverBaby
//
//  Created by 峰 on 2019/11/22.
//  Copyright © 2019 小神童. All rights reserved.
//

#import "APPAudioPlayerController.h"

#import "CBSlider.h"//自定义滑动条

#import "CBAudioListVierw.h"//弹框列表view
#import "APPVideoPlayerController.h"//视频
#import "APPAudioPlayerVM.h"//ViewModel

#import <WebKit/WebKit.h>

@interface APPAudioPlayerController () <APPAudioPlayerDelegate,CBSliderDelegate>

///VM
@property (nonatomic,strong) APPAudioPlayerVM *audioVM;


///上半身视图
@property (nonatomic,strong) UIView *upBgView;

///当前播放标题
@property (nonatomic,strong) UILabel *audioTitleLabel;

///副标题
@property (nonatomic,strong) UILabel *audioSubTitleLabel;

///歌词列表
@property (nonatomic,strong) WKWebView *audioTextView;

///音频图片 placeholder_baby
@property (nonatomic,strong) UIImageView *audioImgBtn;

///播放杆
@property (nonatomic,strong) UIImageView *audioGanImg;

///滑动条
@property (nonatomic,strong) CBSlider *slider;

///左边时间
@property (nonatomic,strong) UILabel *leftTimeLabel;

///右边时间
@property (nonatomic,strong) UILabel *rightTimeLabel;

///播放按钮
@property (nonatomic,strong) UIButton *playPauseBtn;

///播放顺序切换按钮
@property (nonatomic,strong) UIButton *orderBtn;

///弹框列表按钮
@property (nonatomic,strong) UIButton *listAlertBtn;

///旋转角度
@property (nonatomic,assign) CGFloat rotation;

///音频列表
@property (nonatomic,strong) CBAudioListVierw *audioListView;

///收藏按钮
@property (nonatomic,strong) UIButton *collectBtn;


@end

@implementation APPAudioPlayerController
{
    NSUInteger _duration;//当前音频持续时间
    
    BOOL _isPauseSeek;//是否暂停过程中 滑动进度
    
    BOOL _isSlidering;//是否正在滑动进度条
    
    BOOL _showText;//显示歌词
}

- (void)dealloc {
    //播放器死亡时 ——> 显示小弹框
    [[CBAudioSmallAlerView shareInstance] showSmallAudioAlertView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[CBAudioSmallAlerView shareInstance] hideSmallAudioAlertView];//隐藏弹框
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    ///销毁定时器
    [_audioVM deallocTimer];
}

#pragma mark - ************************* VC生命周期 && initData *************************
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarStyle];
    [self initData];
    [self createView];
    [self bindViewModel];
    
    
    [APPAudioPlayer shareInstance].delegate = self;//捕获代理
    
    
    if (_formType == 0) {
        //来自列表
        
        [APPAudioPlayer shareInstance].themeTitle = _themeTitle;
        [APPAudioPlayer shareInstance].autoPlayNext = YES;//自动播放下一首
        [APPAudioPlayer shareInstance].lockScreen = YES;
        
        [[APPAudioPlayer shareInstance] playAudioArray:_audioArray playIndex:_playIndex];
        self.playPauseBtn.selected = YES;
        [_audioVM timerStart];//开启定时器
    }else{
        //来自全局播放框
        _themeTitle = [APPAudioPlayer shareInstance].themeTitle;//主题
        [self currentPlayItem:[APPAudioPlayer shareInstance].playItem];//赋值当前播放数据
        if ([[APPAudioPlayer shareInstance] isPlaying]) {
            [_audioVM timerStart];//开启定时器
            self.playPauseBtn.selected = YES;
        }
    }
}

- (void)setNavigationBarStyle{
    
    [self.naviBar setRightFirstButtonWithImageName:@"public_share"];
}

///初始化数据
- (void)initData{
    
    self.audioVM = [[APPAudioPlayerVM alloc] init];
    
    _duration = 0;
    _isPauseSeek = NO;
    _isSlidering = NO;
    
    _showText = NO;
    _rotation = 0.;
    
}


#pragma mark - ************************* viewModel绑定 *************************
- (void)bindViewModel{
    
    @weakify(self);
    [_audioVM.timerAction subscribeNext:^(NSNumber *x) {
        @strongify(self);
        //旋转图片
        CGAffineTransform trans = self.audioImgBtn.transform;
        self.audioImgBtn.transform = CGAffineTransformRotate(trans, M_PI_2 / 200);
    }];
    
}

#pragma mark - ************************* Action && Event *************************
///右侧第一个按钮
- (void)rightFirstButtonClick{
    //分享
    [APPAudioPlayerVM shareActionWithThemeTitle:_themeTitle];
}

///点击收藏按钮
- (void)onClickBtnCollect {
    //进行儿歌收藏请求处理
    [APPAudioPlayerVM collectionSongWithAcgtionBtn:_collectBtn];
}

///点击上半视图——>显示 || 隐藏 歌词
- (void)onClickAudioImg {
    
    _showText = !_showText;
    
    if (_showText) {
        //显示歌词
        if ([APPAudioPlayer shareInstance].playItem.lyricsId.length) {
            //请求歌词 ——>
            if ([APPAudioPlayer shareInstance].playItem.audioLyrics.length) {
                //已下载歌词
                [self.audioTextView loadHTMLString:[APPAudioPlayer shareInstance].playItem.audioLyrics baseURL:[NSURL gf_URLWithString:@""]];
                [self showAudioText:YES];//显示歌词
            }else{
                //没有下载歌词
                AlertLoadingEnable(NO);
                [APPAudioPlayer getCurrentAudioLyricsWithBlock:^(BOOL result, id idObject) {
                    AlertHideLoading;
                    NSString *audioText = (NSString *)idObject;
                    if (result) {
                        if (audioText.length) {
                            [self.audioTextView loadHTMLString:audioText baseURL:[NSURL gf_URLWithString:@""]];
                            [self showAudioText:YES];//显示歌词
                        }else{
                            AlertMessage(@"暂无歌词");
                        }
                    }else{
                        AlertMessage((NSString *)idObject);
                    }
                }];
            }
        }else{
            AlertMessage(@"暂无歌词");
        }
    }else{
        [self showAudioText:NO];//隐藏歌词
    }
}

///歌词与其他控件显示&&隐藏
- (void)showAudioText:(BOOL)showText {
    
    if (showText) {
        //显示歌词
        _audioTitleLabel.hidden = YES;
        _audioSubTitleLabel.hidden = YES;
        _audioImgBtn.hidden = YES;
        _audioGanImg.hidden = YES;
        if (_collectBtn) {
           _collectBtn.hidden = YES;
        }
        _audioTextView.hidden = NO;
    }else{
        //隐藏歌词
        _audioTitleLabel.hidden = NO;
        _audioSubTitleLabel.hidden = NO;
        _audioImgBtn.hidden = NO;
        _audioGanImg.hidden = NO;
        if (_collectBtn) {
            _collectBtn.hidden = NO;
        }
        _audioTextView.hidden = YES;
    }
}

///开始播放
- (void)onClickBtnBegin {
    [APPAlertTool showAlertCustomTitle:@"提示" message:@"您当前正在使用移动网络,\n继续播放将消耗流量哦！" cancleBtnTitle:@"取消" okBtnTitle:@"播放" okBlock:^(BOOL result, id idObject) {
        //允许 手机网络播放
        [self gotoPlayAudio];
    }];
}

///允许播放
- (void)gotoPlayAudio {
    
    _playPauseBtn.selected = !_playPauseBtn.selected;
    
    if (_playPauseBtn.selected) {
        //播放
        [[APPAudioPlayer shareInstance] playAudio];
        
        if (_isPauseSeek) {
            //暂停 滑动过进度条
            _isPauseSeek = NO;
            [[APPAudioPlayer shareInstance] playAudioFromOffset:_slider.value];//从指定位置播放
        }
    }else{
        //暂停
        [[APPAudioPlayer shareInstance] pauseAudio];
    }
}

///上一首
- (void)onClickBtnUp {
    
    [[APPAudioPlayer shareInstance] upAudioPaly];
}

///下一首
- (void)onClickBtnNext {
    
    [[APPAudioPlayer shareInstance] nextAudioPalay];
}

///点击顺序按钮
- (void)onClickBtnOrder {
    
    _orderBtn.selected = !_orderBtn.selected;
    
    if (_orderBtn.selected) {
        AlertMessage(@"已切至单曲循环");
        [APPAudioPlayer shareInstance].loopType = AudioPlayLoopType_repet;
    }else{
        AlertMessage(@"已切至列表循环");
        [APPAudioPlayer shareInstance].loopType = AudioPlayLoopType_order;
    }
}

///点击列表按钮
- (void)onClickBtnList {
    
    //弹出音频列表
    if (_audioListView) {
        [_audioListView showListViewOnSuperView:self.view playIndex:[APPAudioPlayer shareInstance].indexItem];
    }else{
        WeakSelf(self);
        _audioListView = [CBAudioListVierw showAudioListOnView:self.view title:[APPAudioPlayer shareInstance].themeTitle dataModel:[APPAudioPlayer shareInstance].audioSourceArray playIndex:[APPAudioPlayer shareInstance].indexItem clickBlock:^(BOOL result, id idObject) {
            if (result) {
                //播放指定音频
                [[APPAudioPlayer shareInstance] playAudioOnIndex:((NSNumber *)idObject).integerValue];
            }else{
                //播放视频
                [weakSelf gotoVideoVCWithPlayIndex:((NSNumber *)idObject).integerValue];
            }
        }];
    }
}

///跳进视频播放
- (void)gotoVideoVCWithPlayIndex:(NSInteger)indexPlay {
    
    NSMutableArray *videoArray = [NSMutableArray array];
    for (APPAudioItem *model in _audioArray) {
        //CBHomeClassroomModel *model = _homeVM.classrommArray[indexPath.row];
        APPVideoItemModel *videoModel = [[APPVideoItemModel alloc] init];
        videoModel.videoName = model.subTitle;
        videoModel.videoUrl = model.videoUrl;
        videoModel.videoImgUrl = model.imgUrl;
        [videoArray addObject:videoModel];
    }
    [APPVideoPlayerController gotoVideoVCWithDataArray:[videoArray copy] playIndex:indexPlay fromSuperVC:self videoType:2];
}


#pragma mark - ************************* 播放器代理 *************************
///音乐当前item
- (void)currentPlayItem:(APPAudioItem *)playItem {
    _isPauseSeek = NO;//新的播放归0
    
    if (_showText) {
        [self onClickAudioImg];//隐藏歌词
    }
    
    _audioTitleLabel.text = playItem.title;
    _audioSubTitleLabel.text = playItem.subTitle;
    
    if ([_themeTitle isEqualToString:@"元宝爸讲故事"]) {
        [_audioImgBtn sd_setImageWithURL:[NSURL gf_URLWithString:playItem.imgUrl] placeholderImage:ImageNamed(@"audio_story")];
    }else{
        [_audioImgBtn sd_setImageWithURL:[NSURL gf_URLWithString:playItem.imgUrl] placeholderImage:ImageNamed(@"audio_song")];
    }
    
    //清理时间归0
    _leftTimeLabel.text = @"00:00";
    _rightTimeLabel.text = @"00:00";
    _duration = 0;//时长归零
    [_slider setValue:0.];
    
    //获取显示时间和进度
    NSInteger seconds = [APPAudioPlayer shareInstance].currentTimePlayed;
    self.leftTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)(seconds/60),(int)(seconds%60)];
    self.slider.value = seconds*1. / ([[APPAudioPlayer shareInstance] getCureentAudioDuration]*1.);
    [self getPlayTotalTime];//获取总时长
    
    if (_audioListView && !_audioListView.hidden) {
        [_audioListView reloadListViewWithPlayIndex:[APPAudioPlayer shareInstance].indexItem];
    }
    
    [APPAudioPlayerVM getSongCollectionStateWithButton:_collectBtn];//收藏状态更新
}

///获取播放总时长
- (void)getPlayTotalTime {
    
    NSUInteger duration = [[APPAudioPlayer shareInstance] getCureentAudioDuration];
    _duration = duration;
    self.rightTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)(duration/60),(int)(duration%60)];
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
            [_audioVM timerStart];//开启定时器
            self.playPauseBtn.selected = YES;
            
            [self getPlayTotalTime];//获取总时长
        }
            break;
        case AudioPlayState_pause:
            //暂停播放
            self.playPauseBtn.selected = NO;
            [_audioVM timerPause];//暂停定时器
            break;
        case AudioPlayState_stop:
            //停止播放
            self.playPauseBtn.selected = NO;
            [_audioVM timerPause];//暂停定时器
            
            break;
        case AudioPlayState_error:
            //播放出错
            self.playPauseBtn.selected = NO;
            [_audioVM timerPause];//暂停定时器
            
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
    
    if (!_isSlidering) {
        //没有滑动
        self.leftTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)(seconds/60),(int)(seconds%60)];
        
        self.slider.value = progress;
    }
}

///缓存进度回调 （范围0~1.0）
- (void)audioBufferCacheProgress:(CGFloat)bufferProgress {
    
    self.slider.cacheValue = bufferProgress;
}

///倒计时还剩余的时间
- (void)countDownTimerSeconds:(NSInteger)seconds {
    
}

///播放出错
- (void)audioPlayError:(NSString *)errorInfo {
    
    AlertMessage(errorInfo);
}


#pragma mark - ************************* 滑动条代理 *************************
///滑动块移动触发回调
- (void)sliderValue:(CGFloat)value {
    _isSlidering = YES;//正在滑动
    
    if (_duration > 0) {
        //改变时间
        NSUInteger cureentTime = (NSUInteger)(_duration * value);
        self.leftTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)(cureentTime/60),(int)(cureentTime%60)];
    }
}

///滑动块结束触发回调
- (void)sliderTrackEnd:(CGFloat)value {
    _isSlidering = NO;//结束滑动
    
    if (![[APPAudioPlayer shareInstance] isPlaying]) {
        //改变时间
        NSUInteger cureentTime = (NSUInteger)(_duration * value);
        self.leftTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)(cureentTime/60),(int)(cureentTime%60)];
        
        _isPauseSeek = YES;
    }
    
    [[APPAudioPlayer shareInstance] seekToPositon:value];
}


#pragma mark - ************************* 页面搭建 *************************
- (void)createView{
    
    self.view.backgroundColor = DynamicColor(COLOR(@"#F7FBFC"), APPColorFunction.blackColor);
    
    _upBgView = [[UIView alloc] init];
    [self.view addSubview:_upBgView];
    
    _audioTitleLabel = [APPViewTool view_createLabelWithText:@"" font:kFontOfCustom(kMediumFont, FitIpad(19)) textColor:DynamicColor(APPColorFunction.textBlackColor, APPColorFunction.lightTextColor) textAlignment:NSTextAlignmentCenter];
    [_upBgView addSubview:_audioTitleLabel];

    _audioSubTitleLabel = [APPViewTool view_createLabelWithText:@"" font:kFontOfCustom(kMediumFont, FitIpad(12)) textColor:DynamicColor(COLOR(@"#717B99"), APPColorFunction.lightTextColor) textAlignment:NSTextAlignmentCenter];
    [_upBgView addSubview:_audioSubTitleLabel];
    
    //添加文字显示
    [_upBgView addSubview:self.audioTextView];
    
    //图片
    _audioImgBtn = [APPViewTool view_createImageViewWithImageName:@"placeholder_baby"];
    [APPViewTool view_addBorderOnView:_audioImgBtn borderWidth:10 borderColor:COLOR(@"#D2E7F9") cornerRadius:111.];
    _audioImgBtn.layer.masksToBounds = YES;
    [_upBgView addSubview:_audioImgBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAudioImg)];
    [_upBgView addGestureRecognizer:tap];//添加点击手势
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAudioImg)];
    [_audioTextView addGestureRecognizer:tap2];
    
    //中间圈圈
    UIImageView *qqImgview = [APPViewTool view_createImageViewWithImageName:@"home_nulook"];
    [_audioImgBtn addSubview:qqImgview];
    //滑竿
    _audioGanImg = [APPViewTool view_createImageViewWithImageName:@"audio_gg"];
    [_upBgView addSubview:_audioGanImg];
    
    //添加收藏按钮
    if (![_themeTitle isEqualToString:@"元宝爸讲故事"]) {
        _collectBtn = [APPViewTool view_createButtonImageNormalImg:@"audio_collect_cancle" selectImg:@"audio_collect"];
        [_collectBtn addTarget:self action:@selector(onClickBtnCollect) forControlEvents:UIControlEventTouchUpInside];
        [_upBgView addSubview:_collectBtn];
    }

    //时间  左右时间label
    [self.view addSubview:self.leftTimeLabel];
    [self.view addSubview:self.rightTimeLabel];
    
    //进度条
    [self.view addSubview:self.slider];
    
    //控制按钮
    _playPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playPauseBtn setImage:ImageNamed(@"audio_play") forState:UIControlStateNormal];
    [_playPauseBtn setImage:ImageNamed(@"audio_pause") forState:UIControlStateSelected];
    _playPauseBtn.selected = NO;
    [self.view addSubview:_playPauseBtn];
    
    //上一个
    UIButton *btnUp = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnUp setImage:ImageNamed(@"audio_up") forState:UIControlStateNormal];
    [self.view addSubview:btnUp];
    
    //下一个
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNext setImage:ImageNamed(@"audio_next") forState:UIControlStateNormal];
    [self.view addSubview:btnNext];
    
    //播放顺序按钮
    _orderBtn = [APPViewTool view_createButtonImageNormalImg:@"audio_xh" selectImg:@"audio_dq"];
    [self.view addSubview:_orderBtn];
    
    //列表弹框view
    _listAlertBtn = [APPViewTool view_createButtonImage:@"audio_list"];
    [self.view addSubview:_listAlertBtn];
    
    
    [_playPauseBtn addTarget:self action:@selector(onClickBtnBegin) forControlEvents:UIControlEventTouchUpInside];
    [btnUp addTarget:self action:@selector(onClickBtnUp) forControlEvents:UIControlEventTouchUpInside];
    [btnNext addTarget:self action:@selector(onClickBtnNext) forControlEvents:UIControlEventTouchUpInside];
    
    [_orderBtn addTarget:self action:@selector(onClickBtnOrder) forControlEvents:UIControlEventTouchUpInside];
    [_listAlertBtn addTarget:self action:@selector(onClickBtnList) forControlEvents:UIControlEventTouchUpInside];
    
    
    //约束
    _audioTitleLabel.sd_layout.centerXEqualToView(_upBgView).topSpaceToView(_upBgView, 27*kScaleH).widthIs(kScreenWidth - 20).heightIs(FitIpad(26));
    _audioSubTitleLabel.sd_layout.centerXEqualToView(_audioTitleLabel).topSpaceToView(_audioTitleLabel, 5*kScaleH).widthIs(kScreenWidth - 30).heightIs(FitIpad(16));
    
    _audioImgBtn.frame = CGRectMake((kScreenWidth - 222)/2., 92*kScaleH + FitIpad(42), 222, 222);
    //_audioImgBtn.sd_layout.centerXEqualToView(_audioTitleLabel).topSpaceToView(_audioSubTitleLabel, 60*kScaleH).widthIs(222).heightIs(222);
    
    //qqImgview.sd_layout.centerYEqualToView(_audioImgBtn).centerXEqualToView(_audioImgBtn).widthIs(45).heightIs(45);
    qqImgview.frame = CGRectMake((222 - 45)/2., (222 - 45)/2., 45, 45);
    //_audioGanImg.sd_layout.rightEqualToView(_audioImgBtn).offset(-6).topEqualToView(_audioImgBtn).widthIs(82).heightIs(193.5);
    _audioGanImg.frame = CGRectMake(_audioImgBtn.gf_MaxX - 82, _audioImgBtn.gf_Y, 82, 193.5);
    
    if (_collectBtn) {
        _collectBtn.sd_layout.centerXEqualToView(_upBgView).bottomSpaceToView(_upBgView, 3*kScaleH).widthIs(FitIpad(27)).heightIs(FitIpad(27));
    }
    
    _audioTextView.sd_layout.leftSpaceToView(_upBgView, 60*kScaleW).rightSpaceToView(_upBgView, 60*kScaleW).topSpaceToView(_upBgView, 19*kScaleH).bottomSpaceToView(_upBgView, 19*kScaleH);
    
    
    //底部控制条
    [_playPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-23.5*kScaleH);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(89);
    }];
    [btnUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playPauseBtn);
        make.right.equalTo(self.playPauseBtn.mas_left).offset(-15*kScaleW);
        make.width.height.mas_equalTo(FitIpad(20));
    }];
    [btnNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playPauseBtn);
        make.left.equalTo(self.playPauseBtn.mas_right).offset(15*kScaleW);
        make.width.height.mas_equalTo(FitIpad(20));
    }];
    
    [_orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playPauseBtn);
        make.right.equalTo(btnUp.mas_left).offset(-39*kScaleW);
        make.width.height.mas_equalTo(FitIpad(27));
    }];
    
    [_listAlertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playPauseBtn);
        make.left.equalTo(btnNext.mas_right).offset(39*kScaleW);
        make.width.height.mas_equalTo(FitIpad(27));
    }];
    
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.playPauseBtn.mas_top).offset(-5*kScaleH);
        make.left.equalTo(self.view).offset(12*kScaleW);
        make.right.equalTo(self.view).offset(-12*kScaleW);
        make.height.mas_equalTo(8);
    }];
    
    [_leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slider);
        make.bottom.equalTo(self.slider.mas_top).offset(-4*kScaleH);
        make.height.mas_equalTo(FitIpad(14));
        make.width.mas_equalTo(100);
    }];
    [_rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.slider);
        make.bottom.equalTo(self.slider.mas_top).offset(-4*kScaleH);
        make.height.mas_equalTo(FitIpad(14));
        make.width.mas_equalTo(100);
    }];
    
    [_upBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kTopNaviBarHeight);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.slider.mas_top).offset(-37*kScaleH);
    }];
}

#pragma mark - ************************* getter && setter *************************
- (WKWebView *)audioTextView {
    if (!_audioTextView) {
        //js脚本（让文字显示适配viewport && 设置网页背景颜色）
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);document.body.style.backgroundColor = '#F7FBFC'";
        //注入
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        //配置对象
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = wkUController;
        
        _audioTextView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) configuration:configuration];
        _audioTextView.hidden = YES;
        _audioTextView.backgroundColor = [UIColor redColor];
    }
    return _audioTextView;
}

- (CBSlider *)slider {
    if (!_slider) {
        _slider = [[CBSlider alloc] init];
        _slider.leftTrakColor = APPColorFunction.textBlueColor;
        _slider.rightTrakColor = COLOR(@"#E6EAED");
        _slider.cacheProgressColor = COLOR(@"#E6EAED");
        _slider.sliderHeight = 6;
        [_slider setTrackNormalImage:ImageNamed(@"audio_silderImg") selectdImage:ImageNamed(@"")];
        _slider.delegate = self;
    }
    return _slider;
}

- (UILabel *)leftTimeLabel {
    if (!_leftTimeLabel) {
        _leftTimeLabel = [[UILabel alloc] init];
        _leftTimeLabel.font = kFontOfSystem(FitIpad(10));
        _leftTimeLabel.textColor = DynamicColor(COLOR(@"#717B99"), APPColorFunction.lightTextColor);
        _leftTimeLabel.textAlignment = NSTextAlignmentLeft;
        _leftTimeLabel.text = @"00:00";
    }
    return _leftTimeLabel;
}

- (UILabel *)rightTimeLabel {
    if (!_rightTimeLabel) {
        _rightTimeLabel = [[UILabel alloc] init];
        _rightTimeLabel.font = kFontOfSystem(FitIpad(10));
        _rightTimeLabel.textColor = DynamicColor(COLOR(@"#717B99"), APPColorFunction.lightTextColor);
        _rightTimeLabel.textAlignment = NSTextAlignmentRight;
        _rightTimeLabel.text = @"00:00";
    }
    return _rightTimeLabel;
}


@end
