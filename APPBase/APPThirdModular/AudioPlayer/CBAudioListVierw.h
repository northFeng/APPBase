//
//  CBAudioListVierw.h
//  CleverBaby
//
//  Created by 峰 on 2019/12/19.
//  Copyright © 2019 小神童. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBAudioListVierw : UIView

///点击音频 && 视频
@property (nonatomic,copy) APPBackBlock blockClick;


/// 弹出音频列表
/// @param superView 父视图
/// @param titleType 标题
/// @param dataArray 数据
/// @param playIndex 播放位置
/// @param blockClick 回调
+ (CBAudioListVierw *)showAudioListOnView:(UIView *)superView title:(NSString *)titleType dataModel:(NSArray *)dataArray playIndex:(NSInteger)playIndex clickBlock:(APPBackBlock)blockClick;

///弹出列表
- (void)showListViewOnSuperView:(UIView *)superView playIndex:(NSInteger)playIndex;

///刷新列表
- (void)reloadListViewWithPlayIndex:(NSInteger)playIndex;


@end

///Cell
@interface CBAudioListCell : UITableViewCell

///位置
@property (nonatomic,assign) NSInteger cellIndex;

///回调
@property (nonatomic,copy) APPBackBlock blockVideo;

///播放标志
@property (nonatomic,strong) UIImageView *markImgview;

///标题
@property (nonatomic,strong) UILabel *titleLabel;

///视频按钮 home_songVideoPlay
@property (nonatomic,strong) UIButton *videoPlayBtn;

- (void)setCellModel:(APPAudioItem *)model;

@end

NS_ASSUME_NONNULL_END
