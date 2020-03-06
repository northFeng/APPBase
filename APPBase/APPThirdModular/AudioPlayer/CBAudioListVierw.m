//
//  CBAudioListVierw.m
//  CleverBaby
//
//  Created by 峰 on 2019/12/19.
//  Copyright © 2019 小神童. All rights reserved.
//

#import "CBAudioListVierw.h"

@interface CBAudioListVierw () <UITableViewDelegate,UITableViewDataSource>

///bgview
@property (nonatomic,strong) UIView *bgView;

///tableView
@property (nonatomic,strong) UITableView *tableView;

///标题
@property (nonatomic,strong) UILabel *titleLabel;

///高度
@property (nonatomic,assign) CGFloat bgHeight;

///数据
@property (nonatomic,copy) NSArray *dataArray;

@end

@implementation CBAudioListVierw

#pragma mark - 视图布局
//初始化
- (instancetype)init {
    
    if (self = [super init]) {
        self.backgroundColor = [COLOR(@"#222F3A") colorWithAlphaComponent:0.72];
        [self createView];
    }
    return self;
}


//创建视图
- (void)createView{
    
    _bgView = [APPViewTool view_createViewWithColor:DynamicColor(APPColorFunction.whiteColor, APPColorFunction.blackAlertColor)];
    _bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 391*kScaleH);
    [APPViewTool view_addRoundedCornersOnView:_bgView viewFrame:CGRectMake(0, 0, kScreenWidth, 391*kScaleH) cornersPosition:(UIRectCornerTopLeft | UIRectCornerTopRight) cornersWidth:20];
    [self addSubview:_bgView];
    
    _titleLabel = [APPViewTool view_createLabelWithText:@"" font:kFontOfCustom(kMediumFont, FitIpad(16)) textColor:DynamicColor(APPColorFunction.textBlackColor, APPColorFunction.lightTextColor) textAlignment:NSTextAlignmentLeft];
    [_bgView addSubview:_titleLabel];
    
    UIView *lineH = [APPViewTool view_createViewWithColor:[UIColor grayColor]];
    [_bgView addSubview:lineH];
    
    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    //背景颜色
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bgView addSubview:self.tableView];
    
    //注册cell
    [self.tableView registerClass:[CBAudioListCell class] forCellReuseIdentifier:@"CBAudioListCell"];//非Xib

    //约束布局
    
    _titleLabel.sd_layout.leftSpaceToView(_bgView, 22).topSpaceToView(_bgView, 15*kScaleW).rightSpaceToView(_bgView, 22*kScaleW).heightIs(FitIpad(22.5));
    lineH.sd_layout.leftEqualToView(_bgView).topSpaceToView(_titleLabel, 12*kScaleW).rightEqualToView(_bgView).heightIs(0.5);
    
    self.tableView.sd_layout.leftEqualToView(_bgView).topSpaceToView(_titleLabel, 13*kScaleW).rightEqualToView(_bgView).bottomEqualToView(_bgView);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //隐藏
    [self hideListView];
}

+ (CBAudioListVierw *)showAudioListOnView:(UIView *)superView title:(NSString *)titleType dataModel:(NSArray *)dataArray playIndex:(NSInteger)playIndex clickBlock:(APPBackBlock)blockClick {
    
    CBAudioListVierw *listView = [[CBAudioListVierw alloc] init];
    listView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    listView.blockClick = blockClick;
    [superView addSubview:listView];
    [listView showListWithDataArray:dataArray title:titleType playIndex:playIndex];
    
    return listView;
}

///展示列表
- (void)showListWithDataArray:(NSArray *)dataArray title:(NSString *)titleType playIndex:(NSInteger)playIndex {
    
    self.hidden = NO;
    
    _titleLabel.text = titleType;
    _dataArray = dataArray;
    [_tableView reloadData];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.frame = CGRectMake(0, kScreenHeight - 391*kScaleH, kScreenWidth, 391*kScaleH);
    } completion:^(BOOL finished) {
        if (self.dataArray.count && playIndex < self.dataArray.count) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:playIndex inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:NO];
        }
    }];
}

///弹出列表
- (void)showListViewOnSuperView:(UIView *)superView playIndex:(NSInteger)playIndex {
    [superView addSubview:self];
    
    self.hidden = NO;
    
    [_tableView reloadData];//刷新
    
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.frame = CGRectMake(0, kScreenHeight - 391*kScaleH, kScreenWidth, 391*kScaleH);
    } completion:^(BOOL finished) {
        if (self.dataArray.count && playIndex < self.dataArray.count) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:playIndex inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:NO];
        }
        
    }];
}

///刷新列表
- (void)reloadListViewWithPlayIndex:(NSInteger)playIndex {
    
    [_tableView reloadData];
    if (self.dataArray.count && playIndex < self.dataArray.count) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:playIndex inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:NO];
    }
}

///隐藏
- (void)hideListView {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 391*kScaleH);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}



#pragma mark - **************************** UITableView&&代理 ****************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CBAudioListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBAudioListCell" forIndexPath:indexPath];
    
    [cell setCellModel:_dataArray[indexPath.row]];
    
    cell.cellIndex = indexPath.row;
    
    WeakSelf(self);
    cell.blockVideo = ^(BOOL result, id idObject) {
        if (weakSelf.blockClick) {
            weakSelf.blockClick(NO, (NSNumber *)idObject);//播放视频
        }
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 24*kScaleW + FitIpad(21);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.blockClick) {
        self.blockClick(YES, @(indexPath.row));//播放音频
        [self hideListView];//弹出列表
    }
}


@end


#pragma mark - ************************* @implementation *************************
@implementation CBAudioListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
    }
    
    return self;
}

- (void)createView {
   
    ///播放标志
    _markImgview = [APPViewTool view_createImageViewWithImageName:@"audio_playmark"];
    [self.contentView addSubview:_markImgview];

    ///标题
    _titleLabel = [APPViewTool view_createLabelWithText:@"" font:kFontOfSystem(FitIpad(15)) textColor:DynamicColor(APPColorFunction.textBlackColor, APPColorFunction.lightTextColor) textAlignment:(NSTextAlignmentLeft)];
    [self.contentView addSubview:_titleLabel];
    
    ///视频按钮
    _videoPlayBtn = [APPViewTool view_createButtonImage:@"home_songVideoPlay"];
    [self.contentView addSubview:_videoPlayBtn];
    
    UIView *lineView = [APPViewTool view_createViewWithColor:UIColor.grayColor];
    [self.contentView addSubview:lineView];
    
    //约束
    _markImgview.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView, 25*kScaleW).widthIs(FitIpad(15)).heightIs(FitIpad(15));
    _titleLabel.sd_layout.centerYEqualToView(_markImgview).leftSpaceToView(_markImgview, 13*kScaleW).rightSpaceToView(self.contentView, 31*kScaleW + FitIpad(26)).heightIs(FitIpad(21));
    _videoPlayBtn.sd_layout.centerYEqualToView(_markImgview).rightSpaceToView(self.contentView, 21*kScaleW).widthIs(FitIpad(26)).heightIs(FitIpad(21));
    
    lineView.sd_layout.leftSpaceToView(self.contentView, 21*kScaleW).rightSpaceToView(self.contentView, FitIpad(21)).bottomEqualToView(self.contentView).heightIs(0.5);
    
    _markImgview.hidden = YES;
    [_videoPlayBtn addTarget:self action:@selector(onClickBtnVideoPlay) forControlEvents:UIControlEventTouchUpInside];
}

///点击播放按钮
- (void)onClickBtnVideoPlay {
    
    if (self.blockVideo) {
        self.blockVideo(YES, @(_cellIndex));
    }
}

- (void)setCellModel:(APPAudioItem *)model {
    
    _titleLabel.text = model.title;
    
    if (model.isPlaying) {
        _markImgview.hidden = NO;
        _titleLabel.textColor = APPColorFunction.textBlueColor;
    }else{
        _markImgview.hidden = YES;
        _titleLabel.textColor = DynamicColor(APPColorFunction.textBlackColor, APPColorFunction.lightTextColor);
    }
    
    if (model.videoUrl.length) {
        _videoPlayBtn.hidden = NO;
    }else{
        _videoPlayBtn.hidden = YES;
    }
}


@end
