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
import SwiftyJSON//JSON墨香转换

//********************************* 定义常量 *********************************

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

//顶部条以及tabBar条的宽度，以及工具条距离安全区域的距离

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


//******************************** 定义颜色函数 *********************************
func COLOR(color:String) -> UIColor {
    return APPColorFunction.color(withHexString: color, alpha: 1.0)
}

//******************************** 定义动态颜色 *********************************

///动态颜色
func DynamicColor(lightStylecolor:UIColor, darkStylecolor:UIColor) -> UIColor {
    return APPColorFunction.dynamicColor(withLightColor: lightStylecolor, darkColor: darkStylecolor)
}

//******************************** 定义字体 *********************************
///系统字体
func kFontOfSystem(font:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: font)
}

///非系统字体
//func kFontOfCustom(name:String,font:CGFloat) -> UIFont {
//
//    //return UIFont(name: name, size: font)
//}

///标准字体
let kRegularFont = "PingFangSC-Regular"

///中等字体
let kMediumFont = "PingFangSC-Medium"

///半黑体
let kSemiboldFont = "PingFangSC-Semibold"





