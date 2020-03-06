//
//  APPVideoListView.m
//  CleverBaby
//
//  Created by 峰 on 2019/12/17.
//  Copyright © 2019 小神童. All rights reserved.
//

#import "APPVideoListView.h"

///model
@implementation APPVideoItemModel


@end


@interface APPVideoListView () <UITableViewDelegate,UITableViewDataSource>

///tableView
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation APPVideoListView

#pragma mark - 视图布局
//初始化
- (instancetype)init {
    
    if (self = [super init]) {
        self.backgroundColor = [COLOR(@"#1D1E20") colorWithAlphaComponent:0.62];
        [self createView];
    }
    return self;
}

//创建视图
- (void)createView{

    
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
    self.tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.tableView];
    
    //注册cell
    [self.tableView registerClass:[APPVideoCell class] forCellReuseIdentifier:@"APPVideoCell"];//非Xib
    
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(FitIpad(26), FitIpad(18), FitIpad(26), FitIpad(18)));
}

#pragma mark - **************************** UITableView&&代理 ****************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    APPVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APPVideoCell" forIndexPath:indexPath];
    
    
    APPVideoItemModel *model = [_dataArray gf_getItemWithIndex:indexPath.row];
    
    [cell setCellData:model.videoImgUrl titleStr:model.videoName image:model.imageName];
    
    if (_indexPlay == indexPath.row) {
        //正在播放
        [cell setStyleIsPlay:YES];
    }else{
        //未播放
        [cell setStyleIsPlay:NO];
    }
    
    cell.indexCell = indexPath.row;
    
    WeakSelf(self);
    cell.blockClick = ^(BOOL result, id idObject) {
        [weakSelf.cellSignal sendNext:idObject];//发送信号
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
    return APPVideoCell.cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (RACSubject *)cellSignal {
    if (!_cellSignal) {
        _cellSignal = [RACSubject subject];
    }
    return _cellSignal;
}

+ (CGFloat)viewWidth {
    
    return FitIpad(120) + FitIpad(36);
}


#pragma mark - 业务处理
- (void)showCellIndex:(NSInteger)index {
    
    if (index < _dataArray.count) {
        _indexPlay = index;
        [_tableView reloadData];//刷新
        if (self.dataArray.count && index < self.dataArray.count) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}


@end

#pragma mark - ************************* APPVideoCell *************************
@implementation APPVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
    }
    return self;
}


- (void)createView {
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));

    ///视频图片
    _imgView = [APPViewTool view_createImageViewWithImageName:@"placeholder_videoplayer"];
    _imgView.layer.cornerRadius = FitIpad(11);
    _imgView.layer.masksToBounds = YES;
    _imgView.layer.borderColor = APPColorFunction.textBlueColor.CGColor;
    _imgView.layer.borderWidth = 0.;
    [self.contentView addSubview:_imgView];

    ///视频名字
    _titleLabel = [APPViewTool view_createLabelWithText:@"" font:kFontOfSystem(FitIpad(11)) textColor:APPColorFunction.whiteColor textAlignment:NSTextAlignmentCenter];
    _titleLabel.backgroundColor = [COLOR(@"#0E2329") colorWithAlphaComponent:0.56];
    [_imgView addSubview:_titleLabel];
    
    //约束
    _imgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(FitIpad(8), 0, FitIpad(8), 0));
    _titleLabel.sd_layout.leftEqualToView(_imgView).rightEqualToView(_imgView).bottomEqualToView(_imgView).heightIs(FitIpad(20));
    
    _markImgview = [APPViewTool view_createImageViewWithImageName:@"video_playmark"];
    [_imgView addSubview:_markImgview];
    _markImgview.sd_layout.leftEqualToView(_imgView).topEqualToView(_imgView).widthIs(FitIpad(37)).heightIs(FitIpad(16));
    _markImgview.hidden = YES;
    
    _cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imgView addSubview:_cellBtn];
    _cellBtn.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    [_cellBtn addTarget:self action:@selector(onClickBtnCell) forControlEvents:UIControlEventTouchUpInside];
}

///
- (void)onClickBtnCell {
    
    if (self.blockClick) {
        self.blockClick(YES, @(_indexCell));
    }
}

- (void)setCellData:(NSString *)imgUrl titleStr:(NSString *)titleStr image:(NSString *)imageName {
    
    if (imgUrl.length) {
        [_imgView sd_setImageWithURL:[NSURL gf_URLWithString:imgUrl] placeholderImage:ImageNamed(@"placeholder_videoplayer")];
    }
    
    if (imageName.length) {
        _imgView.image = ImageNamed(imageName);
    }
    
    _titleLabel.text = titleStr;
}


- (void)setStyleIsPlay:(BOOL)isPlay {
    
    if (isPlay) {
        _markImgview.hidden = NO;
        _imgView.layer.borderWidth = 0.5;
    }else{
        _markImgview.hidden = YES;
        _imgView.layer.borderWidth = 0.;
    }
}


+ (CGFloat)cellHeight {
    
    return FitIpad(16) + FitIpad(120)*(69./120.);
}


@end
