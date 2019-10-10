//
//  APPBaseTableViewController.m
//  APPBase
//
//  Created by 峰 on 2019/10/10.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPBaseTableViewController.h"

@interface APPBaseTableViewController ()

@end

@implementation APPBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化一些数据
    self.page = 1;
}

#pragma mark - ************************* 创建tableView *************************
///创建tableView
- (void)createTableViewAndHeadView{
    
    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopNaviBarHeight, kScreenWidth, kScreenHeight - kTopNaviBarHeight) style:UITableViewStyleGrouped];
    //背景颜色
    self.tableView.backgroundColor = APPColor_White;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    //防止UITableView被状态栏压下20
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //self.tableView.adjustedContentInset =
    }
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    self.headView.backgroundColor = [UIColor clearColor];
    self.headTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 7, kScreenWidth - 36, 33*KSCALE)];
    self.headTitleLabel.textColor = APPColor_Black;
    self.headTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];
    self.headTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.headTitleLabel.text = self.title;
    [self.headView addSubview:self.headTitleLabel];
    self.tableView.tableHeaderView = self.headView;
}

///创建tableView无HeadView
- (void)createTableViewNoHeadView{
    
    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopNaviBarHeight, kScreenWidth, kScreenHeight - kTopNaviBarHeight) style:UITableViewStyleGrouped];
    //背景颜色
    self.tableView.backgroundColor = APPColor_White;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //防止UITableView被状态栏压下20
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //self.tableView.adjustedContentInset =
    }
}

///独立添加提示图
- (void)addPromptView{
    
    //创建提示图
    self.promptNonetView = [[FSPromptView alloc] init];
    [self.view addSubview:self.promptNonetView];
    [self.promptNonetView showDefaultPromptViewForNoNet];
    
    self.promptEmptyView = [[FSPromptView alloc] init];
    [self.view addSubview:self.promptEmptyView];
    [self.promptEmptyView showPromptImageName:@"tst_dd" promptText:@"暂无相关订单"];
    //全部隐藏
    self.promptNonetView.hidden = YES;
    self.promptEmptyView.hidden = YES;
    [self.promptNonetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight);
    }];
    [self.promptEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight);
    }];
}

///添加上拉刷新，下拉加载功能
- (void)addTableViewRefreshView{
    __weak typeof(self) weakSelf = self;
    
    //MJRefreshHeader && MJRefreshStateHeader && MJRefreshNormalHeader && MJRefreshGifHeader
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        //[weakSelf requestNetData];
    }];
    
    //MJRefreshAutoFooter && MJRefreshAutoNormalFooter && MJRefreshAutoGifFooter && MJRefreshAutoStateFooter && MJRefreshBackFooter && MJRefreshBackGifFooter MJRefreshBackNormalFooter
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ++weakSelf.page;
        //[weakSelf requestNetData];
    }];
    
    /**
    //占位图（没有刷新加载更多）
    self.tableView.mj_footer = [CFRefreshFooter footerWithRefreshingBlock:nil];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
     */
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - ************************* 代理 *************************
#pragma mark - UITableView&&代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return NULL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - ************************* tableView自定义方法 *************************
///滚动指定tableView的位置
- (void)scrollTableViewToSection:(NSInteger)section row:(NSInteger)row position:(UITableViewScrollPosition)position{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:YES];
}

///获取指定的cell
- (UITableViewCell *)getOneCellWithSection:(NSInteger)section row:(NSInteger)row{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

///刷新指定cell
- (void)reloadOneCellForSection:(NSInteger)section row:(NSInteger)row{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSArray *array = @[indexPath];
    
    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 特殊设置
/**
///滑动监测
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat y = self.tableView.contentOffset.y;
    
    if (y <= 40) {
        self.headTitleLabel.alpha = 1 - y/40.;
        self.naviBar.titleLabel.alpha = y/40.;
    }else{
        self.headTitleLabel.alpha = 0;
        self.naviBar.titleLabel.alpha = 1;
    }
}
 */

@end
