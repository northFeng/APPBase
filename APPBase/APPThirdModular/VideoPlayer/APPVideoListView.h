//
//  APPVideoListView.h
//  CleverBaby
//  视频列表View 
//  Created by 峰 on 2019/12/17.
//  Copyright © 2019 小神童. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///视频model
@interface APPVideoItemModel : NSObject

///视频名字
@property (nonatomic,copy) NSString *videoName;

///视频链接
@property (nonatomic,copy) NSString *videoUrl;

///视频image本地图片
@property (nonatomic,copy) NSString *imageName;

///视频图片
@property (nonatomic,copy) NSString *videoImgUrl;


@end



@interface APPVideoListView : UIView

///视频列表
@property (nonatomic,copy) NSArray *dataArray;

///正在播放的位置
@property (nonatomic,assign) NSInteger indexPlay;

///点击列表信号
@property (nonatomic,strong) RACSubject *cellSignal;

///让当前正在播放的排在第一个
- (void)showCellIndex:(NSInteger)index;

+ (CGFloat)viewWidth;


@end

@interface APPVideoCell : UITableViewCell

///视频图片
@property (nonatomic,strong) UIImageView *imgView;

///视频名字
@property (nonatomic,strong) UILabel *titleLabel;

///图片标志
@property (nonatomic,strong) UIImageView *markImgview;

///点击按钮
@property (nonatomic,strong) UIButton *cellBtn;

///位置
@property (nonatomic,assign) NSInteger indexCell;

@property (nonatomic,copy) APPBackBlock blockClick;


- (void)setCellData:(NSString *)imgUrl titleStr:(NSString *)titleStr image:(NSString *)imageName;


///是否正在播放
- (void)setStyleIsPlay:(BOOL)isPlay;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
