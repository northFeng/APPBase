//
//  CBJSModel.m
//  CleverBaby
//
//  Created by 峰 on 2019/12/4.
//  Copyright © 2019 小神童. All rights reserved.
//

#import "CBJSModel.h"

NSString * const Web_Share_noti = @"Web_Share_noti";

@implementation CBJSModel

///解析数据
+ (void)handleModel:(CBJSModel *)model webView:(WKWebView *)webView {
    
    // 解析哪个页面
    switch (model.interactionViewType) {
        case 0:
        {
            //明星宝贝秀 ——>跳到宝贝视频
        
        }
            break;
        case 1:
        {
            //年课
            [self handleYearClassFunc:model webView:webView];
        }
            break;
        case 2:
        {
            //banner进入webView
            [self handleBannerFunc:model webView:webView];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - ************************* 年课交互功能 *************************
///解析年课交互功能
+ (void)handleYearClassFunc:(CBJSModel *)model webView:(WKWebView *)webView {
    
    ///解析 页面下的 哪个操作
    switch (model.interactionFuncType) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {

        }
            break;
            
        default:
            break;
    }
}



///分享成功回调JS
+ (void)shareSuccessBlockResult:(BOOL)success viewNum:(NSInteger)viewNum funcNum:(NSInteger)funcNum webView:(WKWebView *)webView {
    
    NSMutableDictionary *dicBack = [self getBackJSDataDicWithViewType:viewNum funcType:funcNum];
    NSMutableDictionary *dicData = dicBack[@"interactionData"];
    if (success) {
        [dicData gf_setObject:@"1" withKey:@"success"];
    }else{
        [dicData gf_setObject:@"0" withKey:@"success"];
    }
    [self backJSWithDicData:dicBack webView:webView];
}

///获取返回数据基本格式
+ (NSMutableDictionary *)getBackJSDataDicWithViewType:(NSInteger)viewType funcType:(NSInteger)funcType {
    
    NSMutableDictionary *dicBack = [NSMutableDictionary dictionary];
    [dicBack gf_setObject:@(viewType) withKey:@"interactionViewType"];
    [dicBack gf_setObject:@(funcType) withKey:@"interactionFuncType"];
    
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    [dicBack gf_setObject:dicData withKey:@"interactionData"];
    
    return dicBack;
}

///回调JS数据
+ (void)backJSWithDicData:(NSDictionary *)dicBackJs webView:(WKWebView *)webView {
    
    NSString *jsString = [NSString stringWithFormat:@"appToH5(%@)",[dicBackJs yy_modelToJSONString]];
    //回调JS告知开始录音
    [webView evaluateJavaScript:jsString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"回调JS失败：%@",error.description);
        }else{
            NSLog(@"回调JS成功");
        }
    }];
}

#pragma mark - ************************* banner交互 *************************
///处理banner交互
+ (void)handleBannerFunc:(CBJSModel *)model webView:(WKWebView *)webView {
    
    switch (model.interactionFuncType) {
        case 0:
        {
            //分享
            [APPNotificationCenter postNotificationName:Web_Share_noti object:model];
        }
            break;
            
        default:
            break;
    }
}

@end
