//
//  APPWebHybridController.m
//  APPBase
//
//  Created by 峰 on 2020/2/27.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import "APPWebHybridController.h"

#import "CBJSModel.h"//JS交互model

@interface APPWebHybridController () <WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

///WebView
@property (nonatomic,strong) WKWebView *webView;

///webView的配置属性
@property (nonatomic,strong) WKWebViewConfiguration *configuration;

///代执行对象
@property (nonatomic,strong) WeakScriptMessageDelegate *weakScriptMesDele;

///关闭按钮
@property (nonatomic,strong) UIButton *cloaseBtn;

///进度条
@property (nonatomic,strong) UIProgressView *loadProgressBar;


@end

@implementation APPWebHybridController

- (void)dealloc {
    //移除
    [_configuration.userContentController removeScriptMessageHandlerForName:@"CBIos"];
    [APPNotificationCenter removeObserver:self];//移除通知监听
    //清除JS存储数据
    NSString *jsStr = [NSString stringWithFormat:@"sessionStorage.clear()"];
    [self OCToJSOneMethodWithJSString:jsStr];
}

- (instancetype)init {
    if (self = [super init]) {
        
        _showWebTitle = YES;//默认显示网页标题
    }
    return self;
}

#pragma mark - ************************* VC生命周期 && initData *************************
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createView];
    
    [self addProgressBarView];//添加进度条

    //注册JS交互监测
    [self JSToOCOneMethod];
    
    NSURL *url = [NSURL gf_URLWithString:_htmlUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    //加载
    [_webView loadRequest:request];
}

///初始化数据
- (void)initData{
    
    
}


- (void)setNaviBarStyle{
    
    //添加X号按钮
    if (_showCloseBtn) {
        UIButton *cloaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cloaseBtn setImage:ImageNamed(@"close") forState:UIControlStateNormal];
        [self.naviBar addSubview:cloaseBtn];
        [cloaseBtn addTarget:self action:@selector(onClickBtnClose) forControlEvents:UIControlEventTouchUpInside];
        cloaseBtn.sd_layout.leftSpaceToView(self.naviBar, 50).bottomSpaceToView(self.naviBar, 6).widthIs(30).heightIs(30);
        _cloaseBtn = cloaseBtn;
    }
}


#pragma mark - ************************* OC调用JS *************************
- (void)OCToJSOneMethodWithJSString:(NSString *)jsString{
    
    //NSString *jsString = [NSString stringWithFormat:@"changMarkPText('%@')",@"我是OC传过来的参数"];
    
    [_webView evaluateJavaScript:jsString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"OC执行了JS成功");
    }];
    
}

#pragma mark - JS调用OC
#pragma mark - 注册监听事件
- (void)JSToOCOneMethod{
    
    /**
     //HTML中JS写的代码必须用这个来调用OC
     //地理位置
     window.webkit.messageHandlers.fsLocal.postMessage({body: ''});
     iosSendLocalInfo('%@')
     
     //支付
     window.webkit.messageHandlers.wxPay.postMessage({body: '后台拼接字符串'});
     iosSendPayInfo('%@')
     
     */
    
    //注册交互对象
    [self.configuration.userContentController addScriptMessageHandler:self.weakScriptMesDele name:@"APPIos"];
}

///WKScriptMessageHandler协议
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"APPIos"]) {
        NSLog(@"JS调用OC成功：%@",message.body);
        NSDictionary *dicBody = (NSDictionary *)message.body;
        
        CBJSModel *model = [CBJSModel yy_modelWithJSON:dicBody[@"body"]];
        if (model) {
            //返回数据没问题 ——> 处理交互
            [CBJSModel handleModel:model webView:_webView];//处理交互数据
        }
    }
}


#pragma mark - ************************* Action && Event *************************
///左侧第一个按钮
- (void)leftFirstButtonClick{
    
    if (_showCloseBtn) {
        if ([_webView canGoBack]) {
            [_webView goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

///关闭
- (void)onClickBtnClose {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - ************************* 逻辑处理 *************************


#pragma mark - WKNavigationDelegate主要处理一些跳转、加载处理操作

// 1、页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"1开始加载");
    //AlertLoading;
    _loadProgressBar.progress = 0.;
    _loadProgressBar.alpha = 1.;
    
    [self.naviBar setRightFirstButtonWithImageName:@""];
}

// 2、当内容开始返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"2内容返回");
}

// 3、页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"3加载完");
    //AlertHideLoading;
    [UIView animateWithDuration:0.2 animations:^{
        self.loadProgressBar.alpha = 0.;
    }];
    
    if (_showWebTitle) {
        self.title = _webView.title;
    }
    
    //往Web中存储 H5需要参数
    NSString *jsStr1 = @"sessionStorage.setItem('token','1234567890')";//[NSString stringWithFormat:@"sessionStorage.setItem('payuserauth','%@')",APPManagerUserInfo.payuserauth];
    [self OCToJSOneMethodWithJSString:jsStr1];
}

// 4、页面加载失败时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error{
    NSLog(@"4加载失败");
    //AlertHideLoading;
    [UIView animateWithDuration:0.2 animations:^{
        self.loadProgressBar.alpha = 0.;
    }];
    
    AlertMessage(@"网络不给力...");
}

// 5、接收到服务器重定向 主机地址被重定向时调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
}

#pragma mark - 这里首先进行加载（在这里进行URL的拦截）
// 6、在发送请求之前，决定是否跳转:用户点击网页上的链接，需要 打开一个新的窗口来加载新页面 时，将先调用这个方法。
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *urlString = navigationAction.request.URL.absoluteString;
    NSLog(@"6加载新页面:%@",urlString);
    
    //统一进行跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 7、在收到响应后，决定是否跳转 //接收到相应数据后，决定是否跳转
-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"7收到响应后，决定是否跳:%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    //decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
    
    //navigationResponse.isForMainFrame判断要跳转的request是否在主页面上，为NO，则要打开新窗口，则取消打开
    if (!navigationResponse.isForMainFrame){
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else{
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

// 8、跳转链接失败
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"8跳转失败");
}

// 9、如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的(用不着不要写这个代理)
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
//
//}

// 10、web view的web内容进程终止 9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
}



#pragma mark - WKUIDelegate代理 处理JS脚本，确认框，警告框
///警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    //UIAlertController:supportedInterfaceOrientations was invoked recursively! 系统报的警告
    /**
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
     */
    
    [APPAlertTool showAlertCustom6Title:@"提示" message:message?message:@"" cancleBtnTitle:@"" okBtnTitle:@"确认" leftBlock:^(BOOL result, id idObject) {
        
    } rightBlock:^(BOOL result, id idObject) {
        completionHandler();
    }];
}

///确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    /**
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
     */
    
    [APPAlertTool showAlertCustom6Title:@"提示" message:message?message:@"" cancleBtnTitle:@"取消" okBtnTitle:@"确认" leftBlock:^(BOOL result, id idObject) {
        completionHandler(NO);
    } rightBlock:^(BOOL result, id idObject) {
        completionHandler(YES);
    }];
}

///输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}


///只有当  tFrame.mainFrame == NO；时，表明这个 WKNavigationAction 将会新开一个页面。
/// 创建一个新的WebView  设置这个协议的作用就是要求开发者新开一个webView(浏览器中打开一个新窗口)
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    /** 参数：
     webView 主网页
     configuration：主网页的配置
     navigationAction：导航链接的Action里面包含跳转的信息
     windowFeatures：新窗口的属性
     */
    
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    else{
        //在这里创建新的webView来加载这个request，给返回出去
    }
    return nil;
}

// webview关闭时回调
- (void)webViewDidClose:(WKWebView *)webView{
    
    
}


#pragma mark - ************************* 页面搭建 *************************
- (void)createView{
    
    self.weakScriptMesDele = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
    _configuration = [[WKWebViewConfiguration alloc] init];
    //禁止H5视屏自动播放,并且全屏
    _configuration.allowsInlineMediaPlayback = YES;
    
    CGRect rect = CGRectMake(0, kTopNaviBarHeight, kScreenWidth, kScreenHeight - kTopNaviBarHeight);
    
    _webView = [[WKWebView alloc] initWithFrame:rect configuration:_configuration];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    //允许滑动返回或前进网页
    _webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:_webView];
    _webView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(kTopNaviBarHeight, 0, 0, 0));
    
    //注册通知
    [APPNotificationCenter addObserver:self selector:@selector(notiJSNoti:) name:Web_Share_noti object:nil];
}

///添加进度条
- (void)addProgressBarView {
    
    //监听加载进度
    _loadProgressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _loadProgressBar.progress = 0.;
    _loadProgressBar.alpha = 0.;
    [self.view addSubview:_loadProgressBar];
    _loadProgressBar.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, kTopNaviBarHeight).heightIs(2);
    @weakify(self);
    [[self.webView rac_valuesForKeyPath:@"estimatedProgress" observer:self] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //NSLog(@"------->%@",x);
        NSNumber *number = (NSNumber *)x;
        self.loadProgressBar.progress = number.floatValue;
    }];
}

#pragma mark - ************************* JS交互通知处理 *************************
///分享通知
- (void)notiJSNoti:(NSNotification *)noti {
    
}

///右侧第一个按钮
- (void)rightFirstButtonClick{
   
}



@end


#pragma mark - ************************* 自定义代理对象 *************************

@implementation WeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate
{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    
}

@end

