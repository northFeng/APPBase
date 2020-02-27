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


NS_ASSUME_NONNULL_END
