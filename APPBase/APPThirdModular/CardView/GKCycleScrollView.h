//
//  GKCycleScrollView.h
//  GKCycleScrollViewDemo
//
//  Created by QuintGao on 2019/9/15.
//  Copyright © 2019 QuintGao. All rights reserved.
//  简书 https://www.jianshu.com/p/950ca713e6a9
//  gitHub https://github.com/QuintGao/GKCycleScrollView

#import <UIKit/UIKit.h>
#import "GKCycleScrollViewCell.h"

// 滚动方向
typedef NS_ENUM(NSUInteger, GKCycleScrollViewScrollDirection) {
    GKCycleScrollViewScrollDirectionHorizontal = 0, // 横向
    GKCycleScrollViewScrollDirectionVertical   = 1  // 纵向
};

@class GKCycleScrollView;

@protocol GKCycleScrollViewDataSource <NSObject>

- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView;

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index;

@end

@protocol GKCycleScrollViewDelegate <NSObject>

@optional
// 返回自定义cell尺寸
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView;

// cell滑动时调用
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index;

// cell点击时调用
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didSelectCellAtIndex:(NSInteger)index;

#pragma mark - UIScrollViewDelegate 相关
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView willBeginDragging:(UIScrollView *)scrollView;
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScroll:(UIScrollView *)scrollView;
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndDecelerating:(UIScrollView *)scrollView;
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndScrollingAnimation:(UIScrollView *)scrollView;

@end

@interface GKCycleScrollView : UIView

// 数据源
@property (nonatomic, weak) id<GKCycleScrollViewDataSource> dataSource;
// 代理
@property (nonatomic, weak) id<GKCycleScrollViewDelegate> delegate;

// 滚动方向，默认为横向
@property (nonatomic, assign) GKCycleScrollViewScrollDirection  direction;

// 滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;

// 外部传入，自行处理
@property (nonatomic, weak) UIPageControl *pageControl;

// 当前展示的cell
@property (nonatomic, strong, readonly) GKCycleScrollViewCell *currentCell;

// 当前显示的页码
@property (nonatomic, assign, readonly) NSInteger   currentSelectIndex;

// 默认选中的页码（默认：0）
@property (nonatomic, assign) NSInteger defaultSelectIndex;

// 是否自动滚动，默认YES
@property (nonatomic, assign) BOOL isAutoScroll;

// 是否无限循环，默认YES
@property (nonatomic, assign) BOOL isInfiniteLoop;

// 是否改变透明度，默认YES
@property (nonatomic, assign) BOOL isChangeAlpha;

// 非当前页cell的最小透明度，默认1.0f
@property (nonatomic, assign) CGFloat minimumCellAlpha;

// 左右间距，默认0
@property (nonatomic, assign) CGFloat leftRightMargin;

// 上下间距，默认0
@property (nonatomic, assign) CGFloat topBottomMargin;

// 自动滚动时间间隔，默认3s
@property (nonatomic, assign) CGFloat autoScrollTime;

/**
 刷新数据，必须调用此方法
 */
- (void)reloadData;

/**
 获取可重复使用的cell

 @return cell
 */
- (GKCycleScrollViewCell *)dequeueReusableCell;

/**
 滑动到指定cell

 @param index 指定cell的索引
 @param animated 是否动画
 */
- (void)scrollToCellAtIndex:(NSInteger)index animated:(BOOL)animated;

/**
 调整当前显示的cell的位置，防止出现滚动时卡住一半
 */
- (void)adjustCurrentCell;

/**
 开启定时器
 */
- (void)startTimer;

/**
 关闭定时器
 */
- (void)stopTimer;

@end


#pragma mark - ************************* 用法 *************************
/**
 //创建视图
 - (void)createView{
     
     self.backgroundColor = DynamicColor(APPColorFunction.tableBgColor, APPColorFunction.blackColor);
     
     
     // 缩放样式：Masonry布局，自定义尺寸，无限轮播
     _scorllView = [[GKCycleScrollView alloc] init];
     _scorllView.isAutoScroll = NO;//不自动滚动
     _scorllView.isInfiniteLoop = NO;//不无线循环
     _scorllView.dataSource = self;
     _scorllView.delegate = self;
     _scorllView.minimumCellAlpha = 0.0;
     _scorllView.leftRightMargin = FitIpad(20);//两边间隙
     _scorllView.topBottomMargin = FitIpad(20);//两边距离顶部/底部距离
     [self addSubview:_scorllView];
     _scorllView.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(self, kScaleH*23).heightIs(377*kScaleW);
     
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.scorllView reloadData];//必须刷新
     });
 }

 #pragma mark - ************************* 卡片代理 *************************
 - (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
     return 10;
 }

 - (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
     
     CBInvitePostersCell *cell = (CBInvitePostersCell *)[cycleScrollView dequeueReusableCell];
     if (!cell) {
         cell = [CBInvitePostersCell new];
         cell.layer.cornerRadius = FitIpad(20);
         cell.layer.masksToBounds = YES;
     }
     
     cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
     
     [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://t7.baidu.com/it/u=3616242789,1098670747&fm=79&app=86&f=JPEG?w=900&h=1350"]];
     
     return cell;
 }

 #pragma mark - GKCycleScrollViewDelegate
 - (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
     return CGSizeMake(212*kScaleW, 377*kScaleW);
 }


 - (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index {
     
 }

 - (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndDecelerating:(UIScrollView *)scrollView {
 }



 @end

 #pragma mark - ************************* 自定义卡片CBInvitePostersCell *************************
 @implementation CBInvitePostersCell
 {
     UIImageView *_userImg;
     
     UILabel *_nameLabel;
     
     UIImageView *_codeImg;
 }

 - (instancetype)initWithFrame:(CGRect)frame {
     
     if (self = [super initWithFrame:frame]) {
                 
         [self createView];
     }
     return self;
 }

 - (void)createView {
     
     _userImg = [APPViewTool view_createImageViewWithImageName:@"placeholder_icon"];
     _userImg.layer.cornerRadius = FitIpad(13);
     _userImg.layer.masksToBounds = YES;
     _userImg.layer.borderWidth = FitIpad(2);
     _userImg.layer.borderColor = APPColorFunction.whiteColor.CGColor;
     [self addSubview:_userImg];
     
     _nameLabel = [APPViewTool view_createLabelWithText:@"土豆君" font:kFontOfCustom(kMediumFont, FitIpad(10)) textColor:APPColorFunction.whiteColor textAlignment:(NSTextAlignmentLeft)];
     [self addSubview:_nameLabel];
     
     _codeImg = [APPViewTool view_createImageViewWithImageName:@"placeholder_icon"];
     _codeImg.layer.cornerRadius = FitIpad(8);
     _codeImg.layer.masksToBounds = YES;
     [self addSubview:_codeImg];
     
     _userImg.sd_layout.leftSpaceToView(self, 9*kScaleW).topSpaceToView(self, 9*kScaleW).widthIs(FitIpad(26)).heightIs(FitIpad(26));
     _nameLabel.sd_layout.centerYEqualToView(_userImg).leftSpaceToView(_userImg, 8*kScaleW).heightIs(FitIpad(15)).rightSpaceToView(self, 100);
     _codeImg.sd_layout.rightSpaceToView(self, 7*kScaleW).bottomSpaceToView(self, 10*kScaleW).widthIs(FitIpad(64)).heightIs(FitIpad(64));
 }




 @end

 */
