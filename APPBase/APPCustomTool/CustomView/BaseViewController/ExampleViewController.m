//
//  ExampleViewController.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/8/24.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "ExampleViewController.h"

@interface ExampleViewController ()

@end

@implementation ExampleViewController

- (void)dealloc{
    NSLog(@"视图释放了");
}

#pragma mark - 页面初始化 && 基本页面设置
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建其他视图
    [self createView];
    
    //[self.tableView.mj_header beginRefreshing];
    
}

//初始化界面基础数据
- (void)initData {
    
    
}



///设置导航栏样式
- (void)setNaviBarStyle{
    //设置状态栏样式
    [self setStatusBarStyleLight];
    //设置状态栏是否隐藏
    //[self setStatusBarIsHide:YES];
    
    //设置导航条
    self.naviBarTitle = @"标题";
    [self.naviBar setLeftFirstButtonWithTitleName:@"返回"];
    
    self.naviBar.backgroundColor = [UIColor darkGrayColor];
}

#pragma mark - Network Request  网络请求
- (void)requestNetData{
    NSLog(@"请求数据");
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //可使用的
    [params setObject:[NSNumber numberWithInteger:self.page]  forKey:@"pageNo"];
    //一次拉取10条
    [params setObject:[NSNumber numberWithInt:10]  forKey:@"pageSize"];
    
    
    //网络请求
    //[self requestNetDataUrl:nil params:params];
}


///请求成功数据处理  (这个方法要重写！！！)
- (void)requestNetDataSuccess:(id)dicData{
    
    if (self.page == 1) {
        //上拉刷新
        [self.arrayDataList removeAllObjects];
    }
    
    //分页请求示例
    if (kObjectEntity(dicData)) {
        NSArray *arrayList = [(NSDictionary *)dicData objectForKey:@"list"];
        NSDictionary *dicJson = (NSDictionary *)dicData;
        if(dicJson.count>0){
            
            for (NSDictionary *itemModel in arrayList) {
                
                if (itemModel == nil || [itemModel isKindOfClass:[NSNull class]]) {
                    
                    continue;
                }
                //            CFDiscoverHomeModel *model = [[CFDiscoverHomeModel alloc] init];
                //            [model yy_modelSetWithDictionary:itemModel];
                
                //[self.arrayDataList addObject:model];
            }
            
            if (arrayList.count >= 10) {
                self.tableView.mj_footer.hidden = NO;
            }else{
                self.tableView.mj_footer.hidden = YES;
            }
            
        }else{
            self.tableView.mj_footer.hidden = YES;
        }
    }else{
        //数据为空
        self.tableView.mj_footer.hidden = YES;
    }
    
    ///数据为空展示无数据占位图
    if (self.arrayDataList.count == 0) {
        //数据为空展示占位图
        [self showPromptEmptyView];
    }else{
        [self hidePromptView];
    }
    //刷新数据&&处理页面
    [self.tableView reloadData];
}

///请求数据失败处理
- (void)requestNetDataFail{
    
    
}




#pragma mark - UITableView&&代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    //[cell setCellModel:array[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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


#pragma mark - 特殊设置
///滑动监测
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat y = self.tableView.contentOffset.y;
    
    if (y <= 40) {
        self.headLabelTitle.alpha = 1 - y/40.;
        self.naviBar.titleLabel.alpha = y/40.;
    }else{
        self.headLabelTitle.alpha = 0;
        self.naviBar.titleLabel.alpha = 1;
    }
}


#pragma mark - 按钮点击事件


#pragma mark - 逻辑处理



#pragma mark - Init View  初始化一些视图之类的
- (void)createView{
    
    //创建tableView
    [self createTableView];
    //添加上拉下拉
    [self addTableViewRefreshView];
    
    //特别设置tableView和提示图
    
    //    self.tableView.frame = CGRectMake(0, KTopHeight, kScreenWidth, kScreenHeight - KTopHeight);
    //    self.tableView.backgroundColor = APPColor_White;
    
    //重写headView
    //self.headView.frame = CGRectMake(0, 0, kScreenWidth, 275*KSCALE);
    
    
    //注册cell
    //[self.tableView registerClass:[FSOrderCell class] forCellReuseIdentifier:@"FSOrderCell"];//非Xib
    //[self.tableView registerNib:[UINib nibWithNibName:@"CFTradeCell" bundle:nil] forCellReuseIdentifier:@"tradeCell"];//Xib
    
    
    //移除旧的占位图 && 添加新的占位图
    [self.promptEmptyView removeFromSuperview];
    self.promptEmptyView = nil;
    self.promptEmptyView = [[FSPromptView alloc] init];
    [self.tableView addSubview:self.promptEmptyView];
    //全部隐藏
    self.promptEmptyView.hidden = YES;
    self.promptEmptyView.sd_layout.leftEqualToView(self.tableView).rightEqualToView(self.tableView).topSpaceToView(self.tableView, 61*KSCALE).heightIs(216);
    
    //自定义无内容占位图
    UIView *emptyView = [[UIView alloc] init];
    emptyView.backgroundColor = [UIColor clearColor];
    emptyView.frame = CGRectMake(0, 0, kScreenWidth, 216);
    UIImageView *imgQS = [[UIImageView alloc] init];
    imgQS.image = ImageNamed(@"home_qs");
    [emptyView addSubview:imgQS];
    imgQS.sd_layout.centerXEqualToView(emptyView).topEqualToView(emptyView).widthIs(141).heightIs(137);
    UILabel *label = [APPFunctionMethod view_createLabelWith:@"很抱歉，暂未找到您搜索的地址，建议您扩 大关键词进行搜索" font:14 textColor:APPColor_Gray textAlignment:NSTextAlignmentCenter textWight:0];
    label.numberOfLines = 2;
    [emptyView addSubview:label];
    label.sd_layout.centerXEqualToView(emptyView).bottomEqualToView(emptyView).widthIs(266).heightIs(40);
    
    [self.promptEmptyView addCoustomBackView:emptyView];
    
}



#pragma mark - 导航条&&协议方法
///左侧第一个按钮
- (void)leftFirstButtonClick:(nullable UIButton *)button{
    
    //默认这个为返回按钮
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 登录状态变化发生处理事件
- (void)loginStateChange{
    
    NSLog(@"登录状态发生变化");
    
}



#pragma mark - 其他视图的 事件协议代理处理方法
//命名规则
- (void)XXXView_OnClickXXXBtn:(id)sender{
    
    NSLog(@"点击XXXView上的XXX按钮");
    
    //ViewModel来处理 数据业务
    
}





@end
