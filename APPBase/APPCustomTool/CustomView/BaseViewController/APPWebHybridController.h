//
//  APPWebHybridController.h
//  APPBase
//  H5交互WebVC (WKWebView)
//  Created by 峰 on 2020/2/27.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import "APPBaseController.h"

//#import <WebKit/WebKit.h> //WebKit框架
#import <WebKit/WKWebView.h>
#import <WebKit/WKScriptMessageHandler.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPWebHybridController : APPBaseController

/** htmlUrl */
@property (nonatomic,copy) NSString *htmlUrl;

///是否显示关闭按钮（默认NO）
@property (nonatomic,assign) BOOL showCloseBtn;

///是否显示 webView 的标题 （默认YES）
@property (nonatomic,assign) BOOL showWebTitle;

@end

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

/** 创建带JS脚本的 WKWebView配置类
//js脚本（让文字显示适配viewport && 设置网页背景颜色）
NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);document.body.style.backgroundColor = '#F7FBFC'";
//注入
WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
WKUserContentController *wkUController = [[WKUserContentController alloc] init];
[wkUController addUserScript:wkUScript];

//配置对象
WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
configuration.userContentController = wkUController;

_audioTextView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) configuration:configuration];
_audioTextView.hidden = YES;
_audioTextView.backgroundColor = [UIColor redColor];
 */


NS_ASSUME_NONNULL_END
