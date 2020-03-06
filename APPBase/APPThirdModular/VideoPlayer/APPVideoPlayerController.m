//
//  APPVideoPlayerController.m
//  CleverBaby
//
//  Created by 峰 on 2019/11/19.
//  Copyright © 2019 小神童. All rights reserved.
//

#import "APPVideoPlayerController.h"

#import "APPBaseController+ScreenRotation.h"//分类

#import "APPVideoPlayer.h"//视频播放器
#import "CBSlider.h"//进度条
#import "APPVideoInfoView.h"//显示亮度&&音量
#import <MediaPlayer/MediaPlayer.h>
#import "APPVideoPromptView.h"//亮度&音量提示

///视频VC
@interface APPVideoPlayerController () <APPVideoPlayerDelegate,CBSliderDelegate,UIGestureRecognizerDelegate>

///播放器
@property (nonatomic,strong) APPVideoPlayer *viderPlayer;

///播放画面view
@property (nonatomic,strong) UIView *playView;

///视频顶上按钮条
@property (nonatomic,strong) APPVideoHeaderView *headView;

///视频底部按钮条
@property (nonatomic,strong) APPViderBottomView *bottomView;

///按钮锁
@property (nonatomic,strong) UIButton *lockBtn;

///视频列表
@property (nonatomic,strong) APPVideoListView *listView;


///是否搜索到设备
@property (nonatomic,assign) BOOL isSearchScreen;

///亮度视图
@property (nonatomic,strong) APPVideoInfoView *brightView;

///音量视图
@property (nonatomic,strong) APPVideoInfoView *volueView;

///系统音量控制条
@property (nonatomic,strong) UISlider *volueSystemSlider;

///提示图
@property (nonatomic,strong) APPVideoPromptView *promptView;

@end

@implementation APPVideoPlayerController
{
    NSInteger _duration;//当前音频持续时间
    
    BOOL _isSlidering;//是否正在滑动进度条
    
    CGFloat _screenWidth;
    CGFloat _screenHeight;
    
    BOOL _showControl;//是否显示控制条
    
    NSInteger _downTime;//倒计时
    
    UITapGestureRecognizer *_tapGesture;//点击手势
    UIGestureRecognizer *_gestureList;//列表手势
    
    CGFloat _oldBright;//进来前的亮度
    CGPoint _currentPoint;//开始触摸点
    
    CGFloat _beginBrightValue;//开始滑动亮度
    CGFloat _beginVolueValue;//开始滑动声音
}

///进入视频播放页面
+ (void)gotoVideoVCWithDataArray:(NSArray <APPVideoItemModel *>*)videoArray playIndex:(NSInteger)indexPlay fromSuperVC:(UIViewController *)superVC videoType:(NSInteger)videoType {
    
    APPVideoPlayerController *videoVC = [[APPVideoPlayerController alloc] init];
    videoVC.videoType = videoType;//视频类型
    
    videoVC.dataArray = videoArray;
    videoVC.indexVideo = indexPlay;
    
    //隐藏播放器小框 && 暂停播放
    [[CBAudioSmallAlerView shareInstance] hideSmallAudioAlertView];
    if ([[APPAudioPlayer shareInstance] isPlaying]) {
        [[APPAudioPlayer shareInstance] pauseAudio];//暂停播放
    }
    [superVC.navigationController pushViewController:videoVC animated:YES];
}

#pragma mark - ************************* VC生命周期 && initData *************************

- (void)dealloc {
    [_playView removeFromSuperview];
    _playView = nil;
    [_viderPlayer deallocObserve];
    
    [APPNotificationCenter removeObserver:self];//移除观察
    
    if (![CBAudioSmallAlerView shareInstance].closeAudio) {
        [[CBAudioSmallAlerView shareInstance] showSmallAudioAlertView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setNavigationBarStyle];
    [self initData];
    [self createView];
    [self bindViewModel];
    
    _viderPlayer.delegate = self;
    
    [self setVideoDataWithIndex:_indexVideo];//进行播放视频
    
    //接收网络状态变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityNetStateChanged:) name:_kGlobal_NetworkingReachabilityChangeNotification object:nil];
    [APPNotificationCenter addObserver:self selector:@selector(appDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)setNavigationBarStyle{
    
    self.naviBar.hidden = YES;
    [self setStatusBarStyleLight];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self removeBackGesture];//移除返回手势
    self.allowScreenRotate = YES;//设置该VC可旋转
    [UIApplication sharedApplication].idleTimerDisabled = YES;//禁止自动锁屏
    
    //隐藏控制条
    if (_showControl) {
        [self afterHideVideoControl];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setScreenInterfaceOrientationRight];//让视频向右旋转
    });
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.allowScreenRotate = NO;
    
    [_viderPlayer pauseVideo];//暂停播放
    [self resumeBackGesture];//回复返回手势

    [UIApplication sharedApplication].idleTimerDisabled = NO;//恢复自动锁屏
    
    [UIScreen mainScreen].brightness = _oldBright;//恢复之前的亮度
}

///初始化数据
- (void)initData{
    _duration = 0;
    _isSlidering = NO;
    _screenWidth = kScreenWidth;
    _screenHeight = kScreenHeight;
    
    _showControl = YES;
    _downTime = 4;
    
    _isSearchScreen = NO;
    
    _oldBright = [UIScreen mainScreen].brightness;
}


#pragma mark - ************************* viewModel绑定 *************************
- (void)bindViewModel{
    WeakSelf(self);

    _bottomView.blockPlay = ^(BOOL result, id idObject) {
        [weakSelf changePlayState:result];
    };
    
    ///列表点击信息
    @weakify(self);
    [_listView.cellSignal subscribeNext:^(NSNumber *x) {
        @strongify(self);
        [UIView animateWithDuration:0.2 animations:^{
            self.listView.frame = CGRectMake(self->_screenHeight, 0, APPVideoListView.viewWidth, self->_screenWidth);
        } completion:^(BOOL finished) {
            self.listView.hidden = YES;
            [self setVideoDataWithIndex:x.integerValue];
        }];
    }];
    
    //添加滑动手势
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDown:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    
    [self.brightView setValue:[UIScreen mainScreen].brightness];
    [self.volueView setValue:(CGFloat)(_volueSystemSlider.value)];
}

///点击播放按钮——>修改播放状态
- (void)changePlayState:(BOOL)playPause {
    
    if (playPause) {
        //播放
        //可以播放
        [self playBtnToPlayOrPause:playPause];
    }else{
        //暂停
        [self playBtnToPlayOrPause:playPause];
    }
    
}
///按钮事件进行播放 && 暂停
- (void)playBtnToPlayOrPause:(BOOL)playPause {
    
    _downTime = 4;//倒计时满时
    if (playPause) {
        //播放
        [_viderPlayer playVideo];
    }else{
        //暂停
        [_viderPlayer pauseVideo];
    }
}

///切换视频进行播放——>修改页面数据
- (void)setVideoDataWithIndex:(NSInteger)index {
    
    //可以播放
    [self gotoPlayVideoWithIndex:index];
}

///进行播放
- (void)gotoPlayVideoWithIndex:(NSInteger)indexPlay {
    
    APPVideoItemModel *model = [_dataArray gf_getItemWithIndex:indexPlay];
    if (model) {
        _videoUrl = model.videoUrl;
        _indexVideo = indexPlay;
        
        [_headView setVideoTitle:model.videoName];
        [_bottomView setTimeShowString:@"00:00/00:00"];
        [_bottomView setSliderProgress:0.];
        
        //没有处于投屏中
        if (!_playView) {
            _playView = [_viderPlayer playVideoWithUrl:model.videoUrl];//播放新视频
            _playView.backgroundColor = [UIColor clearColor];//无色
            [self.view addSubview:_playView];
            [self.view sendSubviewToBack:_playView];
            
            [_playView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.view);
                make.width.mas_equalTo(kScreenWidth);
                make.height.mas_equalTo(kScreenWidth*(9./16.));
            }];
        }else{
            [_viderPlayer playVideoWithUrl:model.videoUrl];//播放新视频
        }
        
        if (!_listView.hidden) {
            [_listView showCellIndex:_indexVideo];//刷新到播放位置
        }
    }
    //http://vfx.mtime.cn/Video/2019/03/21/mp4/190321153853126488.mp4
    //http://vfx.mtime.cn/Video/2019/03/19/mp4/190319212559089721.mp4
    //http://vfx.mtime.cn/Video/2019/03/18/mp4/190318231014076505.mp4
    //@"http://vfx.mtime.cn/Video/2019/03/18/mp4/190318231014076505.mp4"
}

#pragma mark - ************************* 通知处理 *************************

///APP从后台进入前端
- (void)appDidBecomeActiveNotification {
    
    [self setScreenInterfaceOrientationRight];//让视频向右旋转
}

///网络状态发生变化触发事件
- (void)reachabilityNetStateChanged:(NSNotification *)noti{
    
    /**
    StatusUnknown           = -1, //未知网络
    StatusNotReachable      = 0,    //没有网络
    StatusReachableViaWWAN  = 1,    //手机自带网络
    StatusReachableViaWiFi  = 2     //wifi
     */
    
    //暂停
    [_viderPlayer pauseVideo];
}

#pragma mark - ************************* Action && Event *************************
///点击返回按钮
- (void)onClickBackBtn {
    [self resumeBackGesture];//回复返回手势
    [self setScreenInterfaceOrientationDefault];//回到竖屏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

///点击手势
- (void)onClickTapGesture {

    if (!_listView.hidden) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.listView.frame = CGRectMake(self->_screenHeight, 0, APPVideoListView.viewWidth, self->_screenWidth);
        } completion:^(BOOL finished) {
            self.listView.hidden = YES;
        }];
    }else{
        if (_showControl) {
            //隐藏
            //_lockBtn.hidden = YES;
            
            //if (!_lockBtn.selected) {
                [self hideControlBarView];
            //}
        }else{
            //显示
            //_lockBtn.hidden = NO;
            
            //if (!_lockBtn.selected) {
                [self showControlBarView];
            //}
            
            if (_downTime > 0 && _downTime < 4) {
                _downTime = 4;//倒计时中
            }else{
                [self afterHideVideoControl];//延迟隐藏
            }
        }
        _showControl = !_showControl;
    }
}

///双击手势
- (void)onDoubleClickTapGesture {
    
    //if (!_lockBtn.selected) {
        //没锁
        if (_viderPlayer.isPlaying) {
            [_viderPlayer pauseVideo];//暂停
        }else{
            [_viderPlayer playVideo];//播放
        }
    //}
}

/////点击锁按钮
//- (void)onClickBtnLook {
//    _lockBtn.selected = !_lockBtn.selected;
//    if (_lockBtn.selected) {
//        //锁着
//        [self hideControlBarView];
//    }else{
//        //打开
//        [self showControlBarView];
//    }
//
//    if (_downTime > 0 && _downTime < 4) {
//        _downTime = 4;//倒计时中
//    }else{
//        [self afterHideVideoControl];//延迟隐藏
//    }
//}

///点击视频列表按钮
- (void)onClickBtnList {
    
    [self hideControlBarView];//隐藏头底视图
    
    _listView.hidden = NO;
    [_listView showCellIndex:_indexVideo];//滑动到播放位置
    [UIView animateWithDuration:0.2 animations:^{
        self.listView.frame = CGRectMake(self->_screenHeight - APPVideoListView.viewWidth, 0, APPVideoListView.viewWidth, self->_screenWidth);
    }];
}

#pragma mark - 滑动手势处理
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    _currentPoint = [[touches anyObject] locationInView:self.view];
    
    _beginBrightValue = self.brightView.value;
    _beginVolueValue = _volueSystemSlider.value;
}

///滑动手势
- (void)panGestureDown:(UIPanGestureRecognizer *)sender {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        // 只有横屏才可以添加手势
        return;
    }
    
    CGPoint point = [sender locationInView:self.view];// 上下控制点
    //CGPoint tranPoint = [sender translationInView:self.view];//播放进度
    
    typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
        UIPanGestureRecognizerDirectionUndefined,
        UIPanGestureRecognizerDirectionUp,
        UIPanGestureRecognizerDirectionDown,
        UIPanGestureRecognizerDirectionLeft,
        UIPanGestureRecognizerDirectionRight
    };
    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            
            if (direction == UIPanGestureRecognizerDirectionUndefined) {
                
                CGPoint velocity = [sender velocityInView:self.view];//速度
                
                BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
                if (isVerticalGesture) {
                    //垂直滑动
                    if (velocity.y > 0) {
                        direction = UIPanGestureRecognizerDirectionDown;//向下滑
                    } else {
                        direction = UIPanGestureRecognizerDirectionUp;//向上滑
                    }
                }else {
                    //水平滑动
                    if (velocity.x > 0) {
                        direction = UIPanGestureRecognizerDirectionRight;//向右滑
                    } else {
                        direction = UIPanGestureRecognizerDirectionLeft;//向左滑
                    }
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            switch (direction) {
                case UIPanGestureRecognizerDirectionUp: {
                    //向上滑动
                    float dy = point.y - _currentPoint.y;
                    int index = (int)dy;
                    NSLog(@"向上滑:%d",index);
                    [self handlePanResultWithPanIndex:index];
                    
                    break;
                }
                case UIPanGestureRecognizerDirectionDown: {
                    //向下滑动
                    float dy = point.y - _currentPoint.y;
                    int index = (int)dy;
                    NSLog(@"向下滑：%d",index);
                    [self handlePanResultWithPanIndex:index];
                    
                    break;
                }
                case UIPanGestureRecognizerDirectionLeft: {
                   
                    break;
                }
                case UIPanGestureRecognizerDirectionRight: {
                    
                    break;
                }
                default: {
                    break;
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            direction = UIPanGestureRecognizerDirectionUndefined;
            self.brightView.hidden = YES;
            self.volueView.hidden = YES;
            
            break;
        }
        default:
            break;
    }
}

///处理滑动结果
- (void)handlePanResultWithPanIndex:(int)index {
    
    CGFloat scale = index / (self.view.size.height / 2.);//滑动占的比例来设置亮度
    
    if(_currentPoint.x < self.view.size.width / 2){
        // 左侧 上下改变亮度
        self.brightView.hidden = NO;
        
        [UIScreen mainScreen].brightness = _beginBrightValue - scale;
        [self.brightView setValue:[UIScreen mainScreen].brightness];
    }else{
        // 右侧上下改变声音
        self.volueView.hidden = NO;
    
        _volueSystemSlider.value = _beginVolueValue - scale;
        [self.volueView setValue:_volueSystemSlider.value];
    }
}

#pragma mark - ************************* APPVideoPlayerDelegate *************************
///视频开始加载完后回调 视频流的宽高
- (void)videoSizeForWidth:(int)width height:(int)height {
   
    [self updateLayoutSubView];//刷新布局
}

///视频缓存回调进度（0 ~ 1.0）
- (void)videoCacheLoadedProgress:(CGFloat)progress {
    
    [_bottomView setBufferProgress:progress];
}

///视频播放状态
- (void)videoPlayState:(VideoPlayState)state {
    
    switch (state) {
        case VideoPlayState_loading:
            //加载中
            AlertLoading;//加载菊花
            break;
        case videoPlayState_playing:
            //播放中
            AlertHideLoading;//隐藏菊花
            [_bottomView setPlayBtnState:YES];
            
            break;
        case videoPlayState_pasuse:
            //暂停
            AlertHideLoading;//隐藏菊花
            [_bottomView setPlayBtnState:NO];
            
            break;
        case videoPlayState_stop:
            //停止
            AlertHideLoading;//隐藏菊花
            [_bottomView setPlayBtnState:NO];
            
            break;
        case videoPlayState_error:
            //出错
            AlertHideLoading;//隐藏菊花
            [_bottomView setPlayBtnState:NO];
            
            break;
        case videoPlayState_completed:
            //播放完成
            AlertHideLoading;//隐藏菊花
            
            [_bottomView setPlayBtnState:NO];
            //播放完成——>自动播放下一个视频
            if (_headView.switchType == 0) {
                //顺序播放
                _indexVideo ++;
                if (_indexVideo > (_dataArray.count - 1)) {
                    _indexVideo = 0;//切换到第一首
                }
            }else{
                //循环播放
            }
            
            [self setVideoDataWithIndex:_indexVideo];
            
            break;
            
        default:
            break;
    }
}

///视频播放 当前时间 && 视频持续时间
- (void)videoCureentPlayTime:(NSInteger)cureentPlayTime durationTime:(NSInteger)duration {
    
    _duration = duration;
    
    if (!_isSlidering) {
        //当前时间/总时间  00:10/12:00
        NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld",cureentPlayTime/60,cureentPlayTime%60,duration/60,duration%60];
        
        [_bottomView setTimeShowString:timeString];
        
        [_bottomView setSliderProgress:cureentPlayTime*1./duration];
    }
}

///播放出错
- (void)playError:(NSString *)errorInfo {
    AlertMessage(errorInfo);
}

#pragma mark - ************************* 进度条代理 *************************
///滑动块移动触发回调
- (void)sliderValue:(CGFloat)value {
    _isSlidering = YES;//正在滑动
    
    _downTime = 4;//倒计时满时
    
    if (_duration > 0) {
        //改变时间
        NSInteger cureentTime = _duration * value;
        NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld",cureentTime/60,cureentTime%60,_duration/60,_duration%60];
        [_bottomView setTimeShowString:timeString];
    }
}

///滑动块结束触发回调
- (void)sliderTrackEnd:(CGFloat)value {
    _isSlidering = NO;//结束滑动
    
    //跳到指定播放进度
    [_viderPlayer seekToPlaySeconds:(NSInteger)(value*_duration)];
}

#pragma mark - ************************* 投屏代理 *************************

///开始搜索周围投屏设备
- (void)startSearchForScreen {
    
}

#pragma mark - ************************* 布局处理 *************************
/*iOS8以上，旋转控制器后会调用*/
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    //屏幕发生旋转后在这里进行重写布局
    
    /**
    有3种方式可以获取到“当前interfaceOrientation”：

    controller.interfaceOrientation，获取特定controller的方向

    [[UIApplication sharedApplication] statusBarOrientation] 获取状态条相关的方向

    [[UIDevice currentDevice] orientation] 获取当前设备的方向
     */
    //Xcode11.3版本 ——>导致旋转有问题 ——>改成延时0.1s再判断方向
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateLayoutSubView];
    });
}

///处理旋转屏幕布局
- (void)updateLayoutSubView {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    NSLog(@"------>旋转屏幕：%ld",orientation);
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        if (_promptView) {
            //未点击
            _promptView.hidden = NO;
            [self.view bringSubviewToFront:_promptView];
        }
        
        //向左 || 向右
        CGFloat videoWidth  = 0.;
        CGFloat videoHeight = 0.;
        if (_screenWidth * _viderPlayer.videoScale > _screenHeight) {
            //长度超出屏幕
            videoWidth = _screenHeight;
            videoHeight = _screenHeight *1. / _viderPlayer.videoScale;
        }else{
            //长度没有超过屏幕
            videoHeight = _screenWidth;
            videoWidth = _screenWidth * _viderPlayer.videoScale;
        }
        
        
        [_playView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(videoWidth);
            make.height.mas_equalTo(videoHeight);
        }];
        
        //更新头底视图frame
        [self setHeadAndBottomFrameWithViewWidth:_screenHeight viewHeight:_screenWidth];
        if (!_showControl) {
            [self setStatusBarIsHide:YES];//隐藏状态栏
        }
        
        //视频列表
        if (_dataArray.count > 1) {
            _bottomView.listBtn.hidden = NO;//隐藏列表
        }
        
    } else if (orientation == UIInterfaceOrientationPortrait) {
        if (_promptView) {
            _promptView.hidden = YES;
        }
        
        //竖直方向
        [self setStatusBarIsHide:NO];//显示状态栏
        
        [_playView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self->_screenWidth);
            make.height.mas_equalTo(self->_screenWidth*1./_viderPlayer.videoScale);
        }];
        
        //更新头底视图frame
        [self setHeadAndBottomFrameWithViewWidth:_screenWidth viewHeight:_screenHeight];
        
        _bottomView.listBtn.hidden = YES;//隐藏列表
        _listView.frame = CGRectMake(self->_screenHeight, 0, APPVideoListView.viewWidth, self->_screenWidth);
    }
}

///旋转更新头底视图frame
- (void)setHeadAndBottomFrameWithViewWidth:(CGFloat)width viewHeight:(CGFloat)height {
    
    if (_showControl) {
        //显示
        _headView.frame = CGRectMake(0, 0, width, _headView.viewHeight);
        _bottomView.frame = CGRectMake(0, height - _bottomView.height, width, _bottomView.height);
    }else{
        //隐藏
        _headView.frame = CGRectMake(0, -_headView.viewHeight, width, _headView.viewHeight);
        _bottomView.frame = CGRectMake(0, height, width, _bottomView.height);
    }
}

///隐藏上下控制条
- (void)afterHideVideoControl {
    
    _downTime--;
    
    if (_downTime <= 0) {
        //隐藏
        //_lockBtn.hidden = YES;//隐藏锁
        [self hideControlBarView];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self afterHideVideoControl];
        });
    }
    
}

///隐藏控制条
- (void)hideControlBarView {
    _downTime = 4;
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        //向左 || 向右
        [UIView animateWithDuration:0.5 animations:^{
            //更新头底视图frame
            [self hideViewWithViewWidth:self->_screenHeight viewHeight:self->_screenWidth];
        } completion:^(BOOL finished) {
            self.headView.hidden = YES;
            self.bottomView.hidden = YES;
        }];
        [self setStatusBarIsHide:YES];//隐藏状态栏
        
    } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
        
        [UIView animateWithDuration:0.5 animations:^{
            //更新头底视图frame
            [self hideViewWithViewWidth:self->_screenWidth viewHeight:self->_screenHeight];
        } completion:^(BOOL finished) {
            self.headView.hidden = YES;
            self.bottomView.hidden = YES;
        }];
    }
}

///隐藏
- (void)hideViewWithViewWidth:(CGFloat)width viewHeight:(CGFloat)height {
    
    self.headView.frame = CGRectMake(0, -_headView.viewHeight, width, _headView.viewHeight);
    self.bottomView.frame = CGRectMake(0, height, width, _bottomView.height);
}

///显示
- (void)showViewWithViewWidth:(CGFloat)width viewHeight:(CGFloat)height {
    
    self.headView.frame = CGRectMake(0, 0, width, _headView.viewHeight);
    self.bottomView.frame = CGRectMake(0, height - _bottomView.height, width, _bottomView.height);
}

///显示
- (void)showControlBarView {
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        //向左 || 向右
        self.headView.hidden = NO;
        self.bottomView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            //更新头底视图frame
            [self showViewWithViewWidth:self->_screenHeight viewHeight:self->_screenWidth];
        }];
        
        [self setStatusBarIsHide:NO];//显示状态栏
    } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
        //竖屏
        self.headView.hidden = NO;
        self.bottomView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            //更新头底视图frame
            [self showViewWithViewWidth:self->_screenWidth viewHeight:self->_screenHeight];
        }];
    }
}

///控制头底部视图的frame
- (void)updateHeadAndBottomFrame {
    
    
}

#pragma mark - ************************* 页面搭建 *************************
- (void)createView{
    
    _viderPlayer = [[APPVideoPlayer alloc] init];

    //顶部按钮条
    _headView = [APPVideoHeaderView buttonWithType:UIButtonTypeCustom];
    _headView.tvBtn.hidden = YES;
    WeakSelf(self);
    _headView.blockBack = ^(BOOL result, id idObject) {
        switch (((NSNumber *)idObject).integerValue) {
            case 0:
                //点击返回
                [weakSelf onClickBackBtn];
                break;
            case 1:
                //点击投屏
                //[weakSelf onClickBackTV];
                break;
                
            default:
                break;
        }
        
    };
    [self.view addSubview:_headView];
    
    //底部按钮条
    _bottomView = [[APPViderBottomView alloc] init];
    _bottomView.backgroundColor = [UIColor clearColor];
    [_bottomView setSliderDelegate:self];
    if (_dataArray.count == 1) {
        _bottomView.listBtn.hidden = YES;//隐藏
    }
    [self.view addSubview:_bottomView];
    [_bottomView.listBtn addTarget:self action:@selector(onClickBtnList) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateLayoutSubView];//更新布局
    
    
//    _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_lockBtn setTitle:@"锁着" forState:UIControlStateNormal];
//    [_lockBtn setTitle:@"打开" forState:UIControlStateSelected];
//    _lockBtn.selected = NO;
//    [self.view addSubview:_lockBtn];
//
//    [_lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.view);
//        make.left.equalTo(self.view).offset(20);
//        make.width.height.mas_equalTo(40);
//    }];
//
//    [_lockBtn addTarget:self action:@selector(onClickBtnLook) forControlEvents:UIControlEventTouchUpInside];
    
    
    _listView = [[APPVideoListView alloc] init];
    _listView.dataArray = _dataArray;
    _listView.indexPlay = _indexVideo;
    _listView.frame = CGRectMake(_screenHeight, 0, APPVideoListView.viewWidth, _screenWidth);
    [self.view addSubview:_listView];
    _listView.hidden = YES;
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickTapGesture)];
    _tapGesture.delegate = self;
    [self.view addGestureRecognizer:_tapGesture];
    
    UITapGestureRecognizer *tapGestureTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleClickTapGesture)];
    tapGestureTwo.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGestureTwo];
    
    [self.view addSubview:self.brightView];
    [self.view addSubview:self.volueView];
    self.brightView.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(FitIpad(200)).heightIs(FitIpad(40));
    self.volueView.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(FitIpad(200)).heightIs(FitIpad(40));
    self.brightView.hidden = YES;
    self.volueView.hidden = YES;
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    for (UIView *view in [volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            _volueSystemSlider = (UISlider *)view;
            break;
        }
    }
    volumeView.frame = CGRectMake(-1000, -1000, 100, 100);//不能设置隐藏或者透明，只有设置位置出局
    [self.view addSubview:volumeView];
    
    _promptView = [APPVideoPromptView showAlertFromView:self.view];
    if (_promptView) {
        _promptView.hidden = YES;
    }
}

- (APPVideoInfoView *)brightView {
    if (!_brightView) {
        _brightView = [[APPVideoInfoView alloc] initWithBcImg:@"video_ty"];
     }
    return _brightView;
}

- (APPVideoInfoView *)volueView {
    if (!_volueView) {
        _volueView = [[APPVideoInfoView alloc] initWithBcImg:@"video_yl"];
    }
    return _volueView;
}



@end


#pragma mark - ************************* 头部按钮视图 *************************
@implementation APPVideoHeaderView
{
    UIButton *_backBtn;//返回按钮
    UILabel *_titleLabel;//视频标题
    UIButton *_switchBtn;//顺序播放按钮
}

#pragma mark - 视图布局

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    APPVideoHeaderView *headView = [super buttonWithType:buttonType];
    [headView createView];
    
    return headView;
}


//创建视图
- (void)createView{
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:ImageNamed(@"video_back") forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(onClickBtnBack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(24*kScaleW);
        //make.top.equalTo(self).offset(kStatusBarHeight + 10);
        make.bottom.equalTo(self);
        make.width.height.mas_equalTo(FitIpad(38));
    }];
    
    _tvBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tvBtn setImage:ImageNamed(@"video_tv") forState:UIControlStateNormal];
    [self addSubview:_tvBtn];
    [_tvBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self->_backBtn);
        make.right.equalTo(self).offset(-24*kScaleW);
        make.width.height.mas_equalTo(FitIpad(38));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = kFontOfSystem(FitIpad(20));
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"";
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self->_backBtn);
        make.left.equalTo(self->_backBtn.mas_right).offset(12*kScaleW);
        make.right.equalTo(self->_tvBtn.mas_left).offset(-20*kScaleW);
        make.height.mas_equalTo(FitIpad(28));
    }];
    
    [_tvBtn addTarget:self action:@selector(onClickBtnTV) forControlEvents:UIControlEventTouchUpInside];
    
    _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_switchBtn setImage:ImageNamed(@"video_switch_order") forState:UIControlStateNormal];
    [_switchBtn setImage:ImageNamed(@"video_switch_one") forState:UIControlStateSelected];
    _switchBtn.selected = NO;
    [_switchBtn addTarget:self action:@selector(onClickBtnSwitch) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_switchBtn];
    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self->_tvBtn);
        //make.right.equalTo(self->_tvBtn.mas_left).offset(-24*kScaleW);
        make.right.equalTo(self).offset(-24*kScaleW);
        make.width.height.mas_equalTo(FitIpad(38));
    }];
}

- (CGFloat)viewHeight {
    
    CGFloat height = 0.;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
        //竖屏
        height = kStatusBarHeight + 5 + FitIpad(38);
    }else{
        height = 20 + FitIpad(38);
    }
    return height;
}

#pragma mark - ************************* 头部按钮条 按钮点击事件 *************************
///点击返回事件
- (void)onClickBtnBack {
    
    if (self.blockBack) {
        self.blockBack(YES, @0);
    }
}

///点击投屏
- (void)onClickBtnTV {
    
  if (self.blockBack) {
        self.blockBack(YES, @1);
    }
}

///播放顺序切换
- (void)onClickBtnSwitch {
    
    _switchBtn.selected = !_switchBtn.selected;
    
    if (_switchBtn.selected) {
        _switchType = 1;//单曲循环播放
    }else{
        _switchType = 0;//顺序播放
    }
}

#pragma mark - 业务处理
///赋值标题
- (void)setVideoTitle:(NSString *)title {
    
    _titleLabel.text = title;
}


@end

#pragma mark - ************************* 底部按钮视图 *************************
@implementation APPViderBottomView
{
    ///进度条
    CBSlider *_slider;//滑动条
    
    UIButton *_playBtn;//播放按钮
    
    UILabel *_timeLabel;//时间
}

#pragma mark - 视图布局
//初始化
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}


//创建视图
- (void)createView{
    _slider = [[CBSlider alloc] init];
    _slider.leftTrakColor = APPColorFunction.textBlueColor;
    _slider.rightTrakColor = APPColorFunction.whiteColor;
    _slider.cacheProgressColor = UIColor.grayColor;
    _slider.sliderHeight = 6;
    [_slider setTrackNormalImage:ImageNamed(@"video_thumb") selectdImage:ImageNamed(@"")];
    
    [self addSubview:_slider];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(24);
        make.top.equalTo(self).offset(11.5);
        make.right.equalTo(self).offset(-24);
        make.height.mas_equalTo(10);
    }];
    
    //播放按钮
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setImage:ImageNamed(@"video_play") forState:UIControlStateNormal];
    [_playBtn setImage:ImageNamed(@"video_pause") forState:UIControlStateSelected];
    _playBtn.selected = NO;
    [_playBtn addTarget:self action:@selector(onClickBtnPlayBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playBtn];
    
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_slider);
        make.top.equalTo(self->_slider.mas_bottom).offset(12.5);
        make.width.height.mas_equalTo(FitIpad(38));
    }];
    
    //时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = kFontOfSystem(FitIpad(14));
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.text = @"00:00/00:00";
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self->_playBtn);
        make.left.equalTo(self->_playBtn.mas_right).offset(15*kScaleW);
        make.height.mas_equalTo(FitIpad(20));
        make.width.mas_equalTo(FitIpad(120));
    }];
    
    //列表按钮
    _listBtn = [APPViewTool view_createButtonTitle:@"动画列表" textColor:APPColorFunction.whiteColor textFont:kFontOfSystem(FitIpad(14)) bgColor:[UIColor clearColor]];
    [APPViewTool view_addBorderOnView:_listBtn borderWidth:0.5 borderColor:APPColorFunction.whiteColor cornerRadius:FitIpad(5)];
    [self addSubview:_listBtn];
    [_listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-24);
        make.centerY.equalTo(self->_playBtn);
        make.width.mas_equalTo(FitIpad(74));
        make.height.mas_equalTo(FitIpad(22));
    }];
    
}

- (CGFloat)height {
    return 21.5 + 12.5 + FitIpad(38) + 30;
}

#pragma mark - 按钮事件

- (void)onClickBtnPlayBtn {
    
    _playBtn.selected = !_playBtn.selected;
    if (self.blockPlay) {
        self.blockPlay(_playBtn.selected, @(0));
    }
}

///当前播放进度
- (CGFloat)progressValue {
    
    return _slider.value;
}

#pragma mark - 业务处理
///设置播放按钮状态
- (void)setPlayBtnState:(BOOL)play {
    
    _playBtn.selected = play;
}

///设置滑动条代理
- (void)setSliderDelegate:(id)delegate {
    
    _slider.delegate = delegate;
}

///设置时间
- (void)setTimeShowString:(NSString *)timeString {
    
    _timeLabel.text = timeString;
}

///设置缓存进度
- (void)setBufferProgress:(CGFloat)bufferProgress {
    
    _slider.cacheValue = bufferProgress;
}

///设置播放进度
- (void)setSliderProgress:(CGFloat)progress {
    
    _slider.value = progress;
}

///点击列表
- (void)onClickBtnList {
    
    
}


@end
