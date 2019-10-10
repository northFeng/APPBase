//
//  APPBaseTableViewController.h
//  APPBase
//  APP内自带UITableView的VC
//  Created by 峰 on 2019/10/10.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPBaseController.h"

#import "FSPromptView.h"//占位图

NS_ASSUME_NONNULL_BEGIN

@interface APPBaseTableViewController : APPBaseController <UITableViewDelegate,UITableViewDataSource>

///tableView
@property (nonatomic,strong,nullable) UITableView *tableView;

///tableView的头部view
@property (nonatomic,strong,nullable) UIView *headView;

///标题label
@property (nonatomic,strong,nullable) UILabel *headTitleLabel;

///加载更多——页数
@property (nonatomic,assign) NSInteger page;

///无网提示图
@property (nonatomic,strong,nullable) FSPromptView *promptNonetView;

///空空视图
@property (nonatomic,strong,nullable) FSPromptView *promptEmptyView;


///创建tableView
- (void)createTableViewAndHeadView;

///创建tableView无HeadView
- (void)createTableViewNoHeadView;

///独立添加提示图
- (void)addPromptView;

///添加上拉刷新，下拉加载功能
- (void)addTableViewRefreshView;

/**
 *  滚动指定tableView的位置
 *
 *  @param section 组
 *  @param row 行
 *  @param position 上 中 下
*/
- (void)scrollTableViewToSection:(NSInteger)section row:(NSInteger)row position:(UITableViewScrollPosition)position;

/**
 *  获取指定的cell
 *
 *  @param section 组
 *  @param row 行
*/
- (UITableViewCell *)getOneCellWithSection:(NSInteger)section row:(NSInteger)row;

/**
 *  刷新指定的cell
 *
 *  @param section 组
 *  @param row 行
*/
- (void)reloadOneCellForSection:(NSInteger)section row:(NSInteger)row;


@end

NS_ASSUME_NONNULL_END
