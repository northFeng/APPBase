//
//  APPBaseViewController.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/8/24.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "APPBaseViewController.h"

#import "MBProgressHUDTool.h"//文字提示

#import "AppDelegate.h"//代理

#import "APPAlertView.h"//提示弹框

@interface APPBaseViewController ()

///执行回调事件
@property (nonatomic,copy) APPBackBlock blockSEL;

@end

@implementation APPBaseViewController
{
    UIStatusBarStyle _statusStyle;
    BOOL _statusIsHide;
}



- (instancetype)init {
    self = [super init];
    if (self) {
        //...配置
    }
    return self;
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//tabBar的控制页面 在 点方法中设置标题
- (void)setNaviBarTitle:(NSString *)naviBarTitle{
    
    _naviBarTitle = naviBarTitle;
    self.naviBar.title = _naviBarTitle;
    //要在这里进行修改
    self.headLabelTitle.text = _naviBarTitle;
}

#pragma mark - 创建视图&&初始化数据
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /** 设置视图不自动压低tableview
     self.automaticallyAdjustsScrollViewInsets = NO;
     self.edgesForExtendedLayout = UIRectEdgeNone;
     */
    
    //注册登录通知
    [APPNotificationCenter addObserver:self selector:@selector(loginStateChange) name:_kGlobal_LoginStateChange object:nil];
    
    //接收网络状态变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityNetStateChanged:) name:_kGlobal_NetworkingReachabilityChangeNotification object:nil];
    
    //统一视图背景颜色
    self.view.backgroundColor = APPColor_White;
    
    //设置状态栏状态数据初始状态(默认为黑色，不隐藏)
    _statusStyle = UIStatusBarStyleDefault;
    _statusIsHide = NO;
    
    //初始化一些数据
    self.page = 1;
    self.arrayDataList = [NSMutableArray array];//分页请求存储数据数组
    
    //创建导航条
    self.naviBar = [[GFNavigationBarView alloc] init];
    self.naviBar.title = self.naviBarTitle;
    self.naviBar.titleLabel.alpha = 0;
    self.naviBar.delegate = self;
    [self.view addSubview:self.naviBar];
    //导航条约束
    [self.naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view);
        make.height.mas_equalTo(kTopNaviBarHeight);
    }];
    
    if (self.navigationController.viewControllers.count > 1) {
        // 设置返回按钮
        [self.naviBar setLeftFirstButtonWithImageName:@"back_s2"];
    }
    
    //请求数据
    [self initData];
    
    //设置状态栏样式
    [self setNaviBarStyle];
    
    //创建界面  自己在子视图中自己定义加载位置
    //[self createTableView];
    //[self createView];
    
}

#pragma mark - 初始化界面基础数据
- (void)initData {
    
    
}

///设置导航栏样式
- (void)setNaviBarStyle{
    
    
}

#pragma mark - Init View  初始化一些视图之类的
- (void)createView{
    
    
}


///创建tableView
- (void)createTableView{
    
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
    self.headLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, 7, kScreenWidth - 36, 33*KSCALE)];
    self.headLabelTitle.textColor = APPColor_Black;
    self.headLabelTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];
    self.headLabelTitle.textAlignment = NSTextAlignmentLeft;
    self.headLabelTitle.text = self.naviBarTitle;
    [self.headView addSubview:self.headLabelTitle];
    self.tableView.tableHeaderView = self.headView;
    
    
    //创建提示图
    self.promptNonetView = [[FSPromptView alloc] init];
    [self.tableView addSubview:self.promptNonetView];
    [self.promptNonetView showDefaultPromptViewForNoNet];
    
    self.promptEmptyView = [[FSPromptView alloc] init];
    [self.tableView addSubview:self.promptEmptyView];
    [self.promptEmptyView showPromptImageName:@"tst_dd" promptText:@"暂无相关内容"];
    //全部隐藏
    self.promptNonetView.hidden = YES;
    self.promptEmptyView.hidden = YES;
    //在tableView没有内容时！SDLayout没有Masony好用
    [self.promptNonetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(132*KSCALE);
    }];
    [self.promptEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(132*KSCALE);
    }];
    

    //创建等待视图
    [self addWaitingView];
    
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
    
    
    //创建提示图
    self.promptNonetView = [[FSPromptView alloc] init];
    [self.tableView addSubview:self.promptNonetView];
    [self.promptNonetView showDefaultPromptViewForNoNet];
    
    self.promptEmptyView = [[FSPromptView alloc] init];
    [self.tableView addSubview:self.promptEmptyView];
    [self.promptEmptyView showPromptImageName:@"tst_dd" promptText:@"暂无相关内容"];
    //全部隐藏
    self.promptNonetView.hidden = YES;
    self.promptEmptyView.hidden = YES;
    [self.promptNonetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(132*KSCALE);
    }];
    [self.promptEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(132*KSCALE);
    }];
    
    
    //创建等待视图
    [self addWaitingView];
}

///添加标题视图
- (void)addHeadTitleView{
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopNaviBarHeight, kScreenWidth, 70)];
    self.headView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.headView];
    
    //标题
    self.headLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, 7, kScreenWidth - 36, 33*KSCALE)];
    self.headLabelTitle.textColor = APPColor_Black;
    self.headLabelTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];
    self.headLabelTitle.textAlignment = NSTextAlignmentLeft;
    self.headLabelTitle.text = self.naviBarTitle;
    [self.headView addSubview:self.headLabelTitle];
}

///单独添加网络请求等待视图
- (void)addWaitingView{
    
    if (!self.waitingView) {
        //创建等待视图
        self.waitingView = [[APPLoadWaitView alloc] init];
        self.waitingView.frame = CGRectMake(0, 0, 121, 121);
        self.waitingView.center = CGPointMake(kScreenWidth/2., kScreenHeight/2.);
        self.waitingView.layer.cornerRadius = 4;
        self.waitingView.layer.masksToBounds = YES;
        [self.view addSubview:self.waitingView];
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
        make.height.mas_equalTo(132*KSCALE);
    }];
    [self.promptEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(132*KSCALE);
    }];
    
}

///添加上拉刷新，下拉加载功能
- (void)addTableViewRefreshView{
    __weak typeof(self) weakSelf = self;
    
    //MJRefreshHeader && MJRefreshStateHeader && MJRefreshNormalHeader && MJRefreshGifHeader
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestNetData];
    }];
    
    //MJRefreshAutoFooter && MJRefreshAutoNormalFooter && MJRefreshAutoGifFooter && MJRefreshAutoStateFooter && MJRefreshBackFooter && MJRefreshBackGifFooter MJRefreshBackNormalFooter
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ++weakSelf.page;
        [weakSelf requestNetData];
    }];
    
    /**
    //占位图（没有刷新加载更多）
    self.tableView.mj_footer = [CFRefreshFooter footerWithRefreshingBlock:nil];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
     */
    
    self.tableView.mj_footer.hidden = YES;
    
}



#pragma mark - Network Request  网络请求
- (void)requestNetData{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //可使用的
    [params setObject:[NSNumber numberWithInteger:self.page]  forKey:@"pageNo"];
    //一次拉取10条
    [params setObject:[NSNumber numberWithInt:10]  forKey:@"pageSize"];
    
    //[self requestDataWithUrl:@"url" params:params odelClass:[Class class]];
    
    //简版
    //[self requestNetDataUrl:@"" params:params];
}

///请求成功数据处理  (这个方法要重写！！！)
- (void)requestNetDataSuccess:(id)dicData{
    
    //解析数据
    
    //刷新数据
}

///处理占位图显示 && 刷新cell
- (void)refreshTableViewHandlePromptView{
    
    ///数据为空展示无数据占位图
    if (self.arrayDataList.count) {
        [self hidePromptView];
    }else{
        //数据为空展示占位图
        [self showPromptEmptyView];
    }
    
    //刷新数据&&处理页面
    [self.tableView reloadData];
}

///请求数据失败处理
- (void)requestNetDataFail{
    //特殊处理
    if (self.arrayDataList.count) {
        
        [self hidePromptView];
    }
}

#pragma mark - 简版网络请求
//************************* 简版网络请求 *************************
///请求网络数据(分页请求)
- (void)requestTableViewNetPageData:(NSString *)url params:(NSDictionary *)params{
    
    __weak typeof(self) weakSelf = self;
    [self startWaitingAnimating];
    self.tableView.userInteractionEnabled = NO;
    [APPHttpTool postWithUrl:HTTPURL(url) params:params success:^(id response, NSInteger code) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.tableView.userInteractionEnabled = YES;
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        NSString *message = [response objectForKey:@"msg"];
        id dataDic = [response objectForKey:@"data"];
        
        if (code == 200) {
            //请求成功
            
            //隐藏无网&&无内容提示图
            [weakSelf hidePromptView];
            
            //处理数组数据
            [weakSelf requestNetDataSuccess:dataDic];
            
        }else{
            weakSelf.page --;
            // 错误处理
            [weakSelf showMessage:message];
            [weakSelf requestNetDataFail];
        }
        
    } fail:^(NSError *error) {
        
        weakSelf.page --;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.tableView.userInteractionEnabled = YES;
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorNotConnectedToInternet) {
            [weakSelf showMessage:@"网络连接失败..."];
    
        }else{
            [weakSelf showMessage:@"网络不给力..."];
        }
        
        //weakSelf.placeholderView.hidden = YES;
        if (weakSelf.arrayDataList.count > 0) {
            //隐藏无网占位图
            [weakSelf hidePromptView];
        }else{
            //显示无网占位图
            [weakSelf showPromptNonetView];
        }
        
        [weakSelf requestNetDataFail];
        
    }];
    
}



///请求一个tableView字典
- (void)requestTableViewNetDicDataUrl:(NSString *)url params:(NSDictionary *)params{
    
    __weak typeof(self) weakSelf = self;
    [self startWaitingAnimating];
    self.tableView.userInteractionEnabled = NO;

    [APPHttpTool postWithUrl:HTTPURL(url) params:params success:^(id response, NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.userInteractionEnabled = YES;
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        NSString *message = [response objectForKey:@"msg"];
        id dataDic = [response objectForKey:@"data"];
        
        if (code == 200) {
            //请求成功
            //隐藏无网占位图
            [weakSelf hidePromptView];
            
            [weakSelf requestNetDataSuccess:dataDic];
        }else{
            // 错误处理
            [weakSelf showMessage:message];
            [weakSelf requestNetDataFail];
        }
        
    } fail:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.userInteractionEnabled = YES;
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorNotConnectedToInternet) {
            [weakSelf showMessage:@"网络连接失败..."];
        }else{
            [weakSelf showMessage:@"网络不给力..."];
        }
        
        //显示无网占位图
        [weakSelf showPromptNonetView];
        
        [weakSelf requestNetDataFail];
    }];
}

///请求一个字典
- (void)requestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params{
    
    __weak typeof(self) weakSelf = self;
    [self startWaitingAnimating];

    [APPHttpTool postWithUrl:HTTPURL(url) params:params success:^(id response, NSInteger code) {
        
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        NSString *message = [response objectForKey:@"msg"];
        id dataDic = [response objectForKey:@"data"];
        
        if (code == 200) {
            //请求成功
            [weakSelf requestNetDataSuccess:dataDic];
        }else{
            // 错误处理
            [weakSelf showMessage:message];
            [weakSelf requestNetDataFail];
        }
        
    } fail:^(NSError *error) {
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorNotConnectedToInternet) {
            [weakSelf showMessage:@"网络连接失败..."];
        }else{
            [weakSelf showMessage:@"网络不给力..."];
        }
        
        [weakSelf requestNetDataFail];
    }];
}

///get请求一个字典
- (void)requestGetNetDicDataUrl:(NSString *)url params:(NSDictionary *)params{
    
    __weak typeof(self) weakSelf = self;
    [self startWaitingAnimating];
    
    [APPHttpTool getWithUrl:HTTPURL(url) params:params success:^(id response, NSInteger code) {
        
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        NSString *message = [response objectForKey:@"msg"];
        id dataDic = [response objectForKey:@"data"];
        
        if (code == 200) {
            //请求成功
            [weakSelf requestNetDataSuccess:dataDic];
        }else{
            // 错误处理
            [weakSelf showMessage:message];
            [weakSelf requestNetDataFail];
        }
        
    } fail:^(NSError *error) {
        
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorNotConnectedToInternet) {
            [weakSelf showMessage:@"网络连接失败..."];
        }else{
            [weakSelf showMessage:@"网络不给力..."];
        }
        
        [weakSelf requestNetDataFail];
        
    }];
}

///请求一个字典 && 不带等待视图
- (void)requestNetDicDataNoWatingViewUrl:(NSString *)url params:(NSDictionary *)params{
    
    __weak typeof(self) weakSelf = self;
    [APPHttpTool postWithUrl:HTTPURL(url) params:params success:^(id response, NSInteger code) {
        
        //NSString *message = [response objectForKey:@"msg"];
        id dataDic = [response objectForKey:@"data"];
        
        if (code == 200) {
            //请求成功
            [weakSelf requestNetDataSuccess:dataDic];
        }else{
            // 错误处理
            //[weakSelf showMessage:message];
            [weakSelf requestNetDataFail];
        }
        
    } fail:^(NSError *error) {
        
        [weakSelf requestNetDataFail];
    }];
}



#pragma mark - 消息提示弹框

///开启等待视图
- (void)startWaitingAnimating{
    
    [self.view bringSubviewToFront:self.waitingView];
    [self.waitingView startAnimation];
}
///关闭等待视图
- (void)stopWaitingAnimating{
    
    [self.waitingView stopAnimation];
}

///开启等待视图
- (void)startWaitingAnimatingWithTitle:(NSString *)title{
    
    [self.view bringSubviewToFront:self.waitingView];
    [self.waitingView startAnimationWithTitle:title];
}
///关闭等待视图
- (void)stopWaitingAnimatingWithTitle:(NSString *)title{
    
    [self.waitingView stopAnimationWithTitle:title];
}

///关闭等待视图——>执行block
- (void)stopWaitingAnimatingWithTitle:(NSString *)title block:(APPBackBlock)block{
    
    [self.waitingView stopAnimationWithTitle:title];
    
    if (block) {
        block(YES,nil);
    }
}

///消息提示弹框
- (void)showMessage:(NSString *)message{
    //默认设置两秒
    [[MBProgressHUDTool sharedMBProgressHUDTool] showTextToastView:message view:self.view];
}

///消息提示弹框 && 执行block
- (void)showMessage:(NSString *)message block:(APPBackBlock)block{
    
    //默认设置两秒
    [[MBProgressHUDTool sharedMBProgressHUDTool] showTextToastView:message view:self.view];
    
    self.blockSEL = block;
    [self performSelector:@selector(performBlock) withObject:nil afterDelay:1];
}

///执行block
- (void)performBlock{
    
    if (self.blockSEL) {
        self.blockSEL(YES, nil);
    }
}

/**
 *  @brief 消息提示框（显示在本控制器上，多个提示框不会重叠）
 *
 *  @param message 消息默认显示在self.view上
 *
 */
- (void)showMessage:(NSString *)message onView:(UIView *)subView{
    //默认设置两秒
    [[MBProgressHUDTool sharedMBProgressHUDTool] showTextToastView:message view:subView];
}


///自定义消息确定框
- (void)showAlertCustomMessage:(NSString *)message okBlock:(APPBackBlock)block{
    
    APPAlertView *fsAlert = [[APPAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:message withBlock:block];
}

///自定义弹框——>自定义标题
- (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message okBlock:(APPBackBlock)block{
    
    APPAlertView *fsAlert = [[APPAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:title brif:message withBlock:block];
}

///自定义弹框——>自定义标题——>自定义按钮文字
- (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message cancleBtnTitle:(NSString *)cancleTitle okBtnTitle:(NSString *)okTitle okBlock:(APPBackBlock)block{
    
    APPAlertView *fsAlert = [[APPAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:title brif:message leftBtnTitle:cancleTitle rightBtnTitle:okTitle withBlock:block];
}

///自定义弹框——>自定义标题——>自定义按钮文字 ——>左右按钮事件
- (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message cancleBtnTitle:(NSString *)cancleTitle okBtnTitle:(NSString *)okTitle leftBlock:(APPBackBlock)blockLeft rightBlock:(APPBackBlock)blockRight{
    
    APPAlertView *fsAlert = [[APPAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:title brif:message leftBtnTitle:cancleTitle rightBtnTitle:okTitle blockleft:blockRight blockRight:blockLeft];
}

///消息确定框
- (void)showAlertMessage:(NSString *)message title:(NSString *)title{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancleAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

///消息提示框
- (void)showAlertMessage:(NSString *)message title:(NSString *)title btnTitle:(NSString *)btnTitle block:(Block)block{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //执行block
        if (block) {
            block();
        }
    }];
    [alertController addAction:cancleAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

///消息提示框 && 处理block
- (void)showAlertMessage:(NSString *)message title:(NSString *)title btnLeftTitle:(NSString *)leftTitle leftBlock:(Block)leftBlock btnRightTitle:(NSString *)rightTitle rightBlock:(Block)rightBlock{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //执行block
        if (leftBlock) {
            leftBlock();
        }
    }];
    [alertController addAction:leftAction];
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //执行block
        if (rightBlock) {
            rightBlock();
        }
    }];
    [alertController addAction:rightAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


///提示无网
- (void)showPromptNonetView{
    self.promptNonetView.hidden = NO;
    self.promptEmptyView.hidden = YES;
}

///提示无内容
- (void)showPromptEmptyView{
    self.promptNonetView.hidden = YES;
    self.promptEmptyView.hidden = NO;
}

//隐藏无网&&无内容提示图
- (void)hidePromptView{
    self.promptNonetView.hidden = YES;
    self.promptEmptyView.hidden = YES;
}


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

#pragma mark - tableView的 滚动 && 获取 && 刷新 cell
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
    
    NSIndexPath *zkIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSArray *array = @[zkIndexPath];
    
    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
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

#pragma mark - 导航条&&协议方法

///左侧第一个按钮
- (void)leftFirstButtonClick:(nullable UIButton *)button{
    
    //默认这个为返回按钮
    [self.navigationController popViewControllerAnimated:YES];
}

///右侧第一个按钮
- (void)rightFirstButtonClick:(nullable UIButton *)button{
    
}

///右侧第二个按钮
- (void)rightSecondButtonClick:(nullable UIButton *)button{
    
    
}

#pragma mark - 设置状态栏
///设置状态栏是否隐藏
- (void)setStatusBarIsHide:(BOOL)isHide{
    _statusIsHide = isHide;
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
}
///设置状态栏样式为默认
- (void)setStatusBarStyleDefault{
    _statusStyle = UIStatusBarStyleDefault;
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
}
///设置状态栏样式为白色
- (void)setStatusBarStyleLight{
    _statusStyle = UIStatusBarStyleLightContent;
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
}

//是否隐藏
- (BOOL)prefersStatusBarHidden{
    return _statusIsHide;
}
//状态栏样式
/**
 typedef NS_ENUM(NSInteger, UIStatusBarStyle) {
 UIStatusBarStyleDefault                                     = 0, // Dark content, for use on light backgrounds
 UIStatusBarStyleLightContent     NS_ENUM_AVAILABLE_IOS(7_0) = 1, // Light content, for use on dark backgrounds
 
 UIStatusBarStyleBlackTranslucent NS_ENUM_DEPRECATED_IOS(2_0, 7_0, "Use UIStatusBarStyleLightContent") = 1,
 UIStatusBarStyleBlackOpaque      NS_ENUM_DEPRECATED_IOS(2_0, 7_0, "Use UIStatusBarStyleLightContent") = 2,
 } __TVOS_PROHIBITED;
 */
//状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return _statusStyle;
}
/**
 typedef NS_ENUM(NSInteger, UIStatusBarAnimation) {
 UIStatusBarAnimationNone,
 UIStatusBarAnimationFade NS_ENUM_AVAILABLE_IOS(3_2),
 UIStatusBarAnimationSlide NS_ENUM_AVAILABLE_IOS(3_2),
 }
 */
//状态栏隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationSlide;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"*************内存警告*************");
}




#pragma mark - 登录状态变化发生处理事件
- (void)loginStateChange{
    
    NSLog(@"登录状态发生变化");
    
}

#pragma mark - 网络状态发生变化触发事件
- (void)reachabilityNetStateChanged:(NSNotification *)noti{
    
    /**
    StatusUnknown           = -1, //未知网络
    StatusNotReachable      = 0,    //没有网络
    StatusReachableViaWWAN  = 1,    //手机自带网络
    StatusReachableViaWiFi  = 2     //wifi
     */
    
    switch ([APPHttpTool sharedNetworking].networkStats) {
        case StatusUnknown:
            [self showMessage:@"未知网络"];
            break;
        case StatusNotReachable:
            [self showMessage:@"网络连接断开"];
            break;
        case StatusReachableViaWWAN:
            //[self showMessage:@"您正在使用2G/3G/4G网络"];
            break;
        case StatusReachableViaWiFi:
            //[self showMessage:@"您正在使用WiFi网络"];
            break;
            
        default:
            break;
    }
}



#pragma mark - 右滑返回手势的 开启  && 禁止
///禁止返回手势
- (void)removeBackGesture{
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

/**
 * 恢复返回手势
 */
- (void)resumeBackGesture{
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


#pragma mark - 视图推进封装
///推进视图 && Xib
- (void)pushViewControllerWithNibClassString:(NSString *)classString pageTitle:(NSString *)title{
    
    Class ClassViewController = NSClassFromString(classString);
    
    APPBaseViewController *pushVC = [[ClassViewController alloc] initWithNibName:classString bundle:nil];
    
    if (title) {
        pushVC.naviBarTitle = title;
    }
    
    [self.navigationController pushViewController:pushVC animated:YES];
}

///推进视图
- (void)pushViewControllerWithClassString:(NSString *)classString pageTitle:(NSString *)title{
    
    Class ClassViewController = NSClassFromString(classString);
    
    APPBaseViewController *pushVC = [[ClassViewController alloc] init];
    
    if (title) {
        pushVC.naviBarTitle = title;
    }
    
    [self.navigationController pushViewController:pushVC animated:YES];
}


#pragma mark - 弹出模态视图


///弹出模态视图
- (void)presentViewController:(APPBaseViewController *)presentVC{
    
    presentVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:presentVC animated:YES completion:nil];
}

///弹出模态视图
- (void)presentViewController:(APPBaseViewController *)presentVC presentStyle:(UIModalTransitionStyle)presentStyle completionBlock:(void (^)(void))completion{
    
    presentVC.modalTransitionStyle = presentStyle;
    
    [self presentViewController:presentVC animated:YES completion:completion];
}


#pragma mark - 系统UIButton方法自动添加

///给按钮添加事件
- (void)btnAddEventControlWithBtn:(UIButton *)button action:(SEL)action{
    
    //- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}

///给按钮添加显示(默认状态)
- (void)btnAddTitleWithBtn:(UIButton *)button title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color{
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    [button setAttributedTitle:attrString forState:UIControlStateNormal];
}

///给按钮添加显示——设置状态
- (void)btnAddTitleWithBtn:(UIButton *)button title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color state:(UIControlState)state{
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    [button setAttributedTitle:attrString forState:state];
}



#pragma mark - 延时器执行方法

///延时几秒执行事件
- (void)performDelayerEventWithTimeOut:(NSInteger)timeOut block:(APPBackBlock)block{
    
    self.blockSEL = block;
    [self performSelector:@selector(performBlock) withObject:nil afterDelay:timeOut];
    
}

///延时几秒执行事件 + 传参对象
- (void)performDelayerEventWithTimeOut:(NSInteger)timeOut block:(APPBackBlock)block withObject:(nullable id)object{
    
    self.blockSEL = block;
    [self performSelector:@selector(handleDelayerEvent:) withObject:object afterDelay:timeOut];
    
}


///延时器执行事件
- (void)handleDelayerEvent:(id)object{
    
    if (self.blockSEL) {
        self.blockSEL(YES, object);
    }
}



@end
