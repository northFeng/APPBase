//
//  CBJSModel.h
//  CleverBaby
//  解析JS交互数据
//  Created by 峰 on 2019/12/4.
//  Copyright © 2019 小神童. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WebKit/WebKit.h>



NS_ASSUME_NONNULL_BEGIN

extern NSString * const Web_Share_noti;

@interface CBJSModel : NSObject

///交互页面类型  0：明星宝贝秀列表   1:年课
@property (nonatomic,assign) NSInteger interactionViewType;

///页面交互类型
@property (nonatomic,assign) NSInteger interactionFuncType;

///交互数据
@property (nonatomic,copy) NSDictionary *interactionData;

///解析数据
+ (void)handleModel:(CBJSModel *)model webView:(WKWebView *)webView;

///分享成功回调JS
+ (void)shareSuccessBlockResult:(BOOL)success viewNum:(NSInteger)viewNum funcNum:(NSInteger)funcNum webView:(WKWebView *)webView;

@end

NS_ASSUME_NONNULL_END
