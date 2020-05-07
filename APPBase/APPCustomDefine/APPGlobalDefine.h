//
//  APPGlobalDefine.h
//  APPBase
//  自定义全局宏
//  Created by 峰 on 2020/5/7.
//  Copyright © 2020 ishansong. All rights reserved.
//

#ifndef APPGlobalDefine_h
#define APPGlobalDefine_h

#pragma mark - APPManager常用宏
//APPManager单利
#define APPManagerObject [APPManager sharedInstance]

//APPManager用户信息
#define APPManagerUserInfo [APPManager sharedInstance].userInfo

//网络宏
#define HTTPURL(url) [NSString stringWithFormat:@"%@%@",[APPKeyInfo hostURL],url]

//空字符串处理
#define APPString(string) [string length] > 0 ? string : @""



#define kStatusBarHeight (APPManager.stateHeight)

///iPhone 1.  iPad 1.5
#define kIpadScale ([APPManager iPhoneAndIpadTextAdapter])
///适配iPad尺寸
#define FitIpad(num) ([APPManager iPhoneAndIpadTextAdapter:num])

//顶部条以及tabBar条的宽度，以及工具条距离安全区域的距离
#define kNaviBar_ItemBarHeight 44.
#define kTabBar_ItemsHeight 49.

#define kTopNaviBarHeight (kStatusBarHeight > 20 ? 88. : 64.)
#define kTabBarHeight (kStatusBarHeight > 20 ? 83. : 49.)
#define kTabBarBottomHeight (kStatusBarHeight > 20 ? 34. : 0.)

//结构体
#define kRect(x,y,width,height) CGRectMake(x, y, width, height)


#pragma mark - 颜色宏 && 动态颜色 && layer的CGColor
//设置color(传入16进制的颜色值)
#define COLORA(str,a) [APPColorFunction colorWithHexString:str alpha:a]
#define COLOR(str) COLORA(str,1.f)


//动态颜色
#define DynamicColor(lightcolor,darkcolor) [APPColorFunction dynamicColorWithLightColor:lightcolor darkColor:darkcolor]
///赋值layer的边框颜色
#define LayerBorderCGColor(supview,Layer,borderColor) [APPColorFunction layerSupView:supview layer:Layer dynamicBorderColor:borderColor]
///赋值layer的阴影颜色
#define LayerShadowColor(supview,Layer,shadowColor) [APPColorFunction layerSupView:supview layer:Layer dynamicShadowColor:shadowColor]
///赋值layer的背景颜色
#define LayerBackgroundColor(supview,Layer,backgrounColor) [APPColorFunction layerSupView:supview layer:Layer dynamicBackgrounColor:backgrounColor]


#pragma mark - 图片加载宏
///url转换
#define kURLString(url) [NSURL URLWithString:url]
//文件路径转换URL
#define kFilePathUrl(path) [NSURL fileURLWithPath:path]

///赋值图片
#define kImgViewSetImage(imgView,url,placeholderName) [imgView sd_setImageWithURL:kURLString(url) placeholderImage:[UIImage imageNamed:placeholderName] options:SDWebImageRetryFailed]
///赋值GIF图片
#define kImgViewSetGifImage(imgView,gifName) imgView.image = [UIImage sd_animatedGIFWithData:[[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"]]]


#pragma mark - ************************* 吐字 && 弹框 *************************
#define AlertMessage(msg) [APPAlertTool showMessage:msg]

#define AlertMsgView(msg,view) [APPAlertTool showMessage:msg onView:view]

//显示菊花&&文字
#define AlertLoadingMsg(msg,view) [APPAlertTool showLoadingWithMessage:msg onView:view]

//显示可以交互的 菊花
#define AlertLoading [APPAlertTool showLoading]

///显示菊花在指定view
#define AlertLoadingOnView(onView) [APPAlertTool showLoadingOnView:onView]

///是否可交互的菊花
#define AlertLoadingEnable(enable) [APPAlertTool showLoadingForInterEnabled:enable]

///隐藏当前view上的菊花
#define AlertHideLoading [APPAlertTool hideLoading]

///隐藏指定view上的菊花
#define AlertHideLoadingOnView(onView) [APPAlertTool hideLoadingOnView:onView]



#endif /* APPGlobalDefine_h */
