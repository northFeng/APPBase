//
//  APPRequest.swift
//  APPBase
//  Swift请求
//  Created by 峰 on 2020/3/5.
//  Copyright © 2020 ishansong. All rights reserved.
//

import Foundation

//MARK: ************************* Swift中model类都集成这个基类 *************************
class BaseModel: Convertible {
    
    //类的属性，最后直接初始化一个值！
    //var name: String = ""
    //var age: Int = 0
    
    // 由于Swift初始化机制的原因，`Convertible`协议强制要求实现init初始化器
    // 这样框架内部才可以完整初始化一个实例
    required init() {} //所有继承 BaseModel的类，则不用写这个方法了
}

///结构体 两种情况：1、属性已初始化，不用写 init方法  2、属性没初始化，必须写init方法！ ——> 属性必须初始化！！！
struct BaseStruct: Convertible {
    //一、
    // 由于编译器自动帮结构体类型生成了一个init初始化器
    // 所以不需要自己再实现init初始化器
    //var weight: Double = 0.0
    //var name: String = ""
    
    //二、
    var weight: Double
    var name: String
    // 如果没有在定义属性的同时指定初始值，编译器是不会为结构体生成init初始化器的
    // 所以需要自己实现init初始化器
    init() {
        name = ""
        weight = 0.0
    }
    
}
