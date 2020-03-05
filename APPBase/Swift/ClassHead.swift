//
//  ClassHead.swift
//  APPBase
//
//  Created by 峰 on 2020/1/20.
//  Copyright © 2020 ishansong. All rights reserved.
//

import UIKit

import SnapKit//布局
//import HanekeSwift
import Alamofire//网络请求
import SwiftyJSON//JSON数据转换

//MARK: ************************* 定义全局闭包函数 *************************
///常用回调
typealias APPBackClosure = (Bool, Any)->Void
///网络请求回调
typealias APPNetClosure = (Bool, Any, Int)->Void


//MARK: ********************************* 定义常量 *********************************

///屏幕宽
let kScreenWidth = UIScreen.main.bounds.size.width

///屏幕高
let kScreenHeight = UIScreen.main.bounds.size.height

///状态栏高度
let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height

///屏幕宽度比例
let KSCALE = UIScreen.main.bounds.size.width / 375.0

///比例高度
func kScaleHeight(x:Float, y:Float, width:Float) -> Float {
    return width * (x/y)
}

///屏幕宽度比例
let kScaleW = kScreenWidth/375.0

///屏幕高度比例
let kScaleH = kScreenHeight/667.0

///适配iPad比例 ( iPhone 1.  iPad 1.5)
let kIpadScale = APPViewTool.iPhoneAndIpadTextAdapter()

///适配iPad尺寸
func FitIpad(num:CGFloat) -> Float {
    return Float(APPViewTool.iPhoneAndIpadTextAdapter(num))
}

//MARK: 顶部条以及tabBar条的宽度，以及工具条距离安全区域的距离

///导航条ItemBar的高度
let kNaviBar_ItemBarHeight = 44.0

///底部TabBarItem的高度
let kTabBar_ItemsHeight = 49.0

///导航条高度
let kTopNaviBarHeight = kStatusBarHeight > 20 ? 88.0 : 64.0

///底部TabBar高度
let kTabBarHeight = kStatusBarHeight > 20 ? 83.0 : 49.0

///刘海屏手机 弧边安全高度
let kBottomSafeHeight = kStatusBarHeight > 20 ? 34.0 : 0.0


//MARK: ******************************** 定义颜色函数 *********************************
func COLOR(color:String) -> UIColor {
    return APPColorFunction.color(withHexString: color, alpha: 1.0)
}

//MARK: ******************************** 定义动态颜色 *********************************

///动态颜色
func DynamicColor(lightStylecolor:UIColor, darkStylecolor:UIColor) -> UIColor {
    return APPColorFunction.dynamicColor(withLightColor: lightStylecolor, darkColor: darkStylecolor)
}

//MARK: ******************************** 定义字体 *********************************
///系统字体
func kFontOfSystem(font:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: font)
}

///非系统字体
func kFontOfCustom(name:String,font:CGFloat) -> UIFont? {

    return UIFont(name: name, size: font)
}

///标准字体
let kRegularFont = "PingFangSC-Regular"

///中等字体
let kMediumFont = "PingFangSC-Medium"

///半黑体
let kSemiboldFont = "PingFangSC-Semibold"

//MARK: ************************* 吐字 && 弹框 *************************

///吐字
func AlertMessage(msg:String) {
    APPAlertTool.showMessage(msg)
}

///吐字在view上
func AlertMsgView(msg:String, view:UIView) {
    APPAlertTool.showMessage(msg, on: view)
}

///显示菊花&&文字
func AlertLoadingMsg(msg:String, view:UIView) {
    APPAlertTool.showLoading(withMessage: msg, on: view)
}

///显示可以交互的 菊花
func AlertLoading() {
    APPAlertTool.showLoading()
}

///显示菊花在指定view
func AlertLoadingOnView(view:UIView) {
    APPAlertTool.showLoading(on: view)
}

///是否可交互的菊花
func AlertLoadingEnable(enable:Bool) {
    APPAlertTool.showLoading(forInterEnabled: enable)
}

///隐藏当前view上的菊花
func AlertHideLoading() {
    APPAlertTool.hideLoading()
}

///隐藏指定view上的菊花
func AlertHideLoadingOnView(view:UIView) {
    APPAlertTool.hideLoading(on: view)
}

//MARK: ************************* 系统宏定义 *************************
///全局打印函数
func Print<T>(_ message:T, file:String = #file, funcName:String = #function, lineNum:Int = #line){
    
    //#if DEBUG
    let file = (file as NSString).lastPathComponent;
    
    print("\(file):(\(lineNum))--\(message)");
    
    //#endif
}

///小于iOS10
let IOSLess10:Bool = ((UIDevice.current.systemVersion as NSString).integerValue < 10)

///大于iOS13
let IOSAbove13:Bool = ((UIDevice.current.systemVersion as NSString).integerValue > 13)

///是否为手机（用来判断是iPhone && iPad）
let kIsiPhone:Bool = APPLoacalInfo.iPhoneOrIpad() as Bool

