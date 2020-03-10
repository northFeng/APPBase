//
//  APPRequest.swift
//  APPBase
//  Swift请求
//  Created by 峰 on 2020/3/5.
//  Copyright © 2020 ishansong. All rights reserved.
//

import Foundation

//MARK: ************************* Swift中model类都集成这个基类 *************************
//官方用法教程：https://www.cnblogs.com/mjios/p/11352776.html
/**
 1、 jsonString也可以是NSString、NSMutableString类型、字典类型、NSData、NSMutableData类型
 let jsonData = """
 {
     "name": "Miaomiao",
     "weight": 6.66
 }
 """.data(using: .utf8)!
 let cat1 = jsonData.kj.model(Cat.self)   、  let cat2 = model(from:jsonData, Cat.self)
 
 2、Model嵌套1 ：// 让需要进行转换的模型【都遵守】`Convertible`协议
 3、var books:Set<BaseStruct>?    Set、数组 要求存放的元素 【遵守Hashable协议】
 4、递归解析
 5、泛型  let response1 = json1.kj.model(NetResponse<User>.self)
 6、解析数据
 7、字典里套数组
 8、已有的model实例 ， 直接把json数据赋值给model实例
 */
class BaseModel: Convertible {
    
    //类的属性，最后直接初始化一个值！
    //var name: String = ""
    //var age: Int = 0
    
    // 测试表明：在真机release模式下，对数字类型的let限制比较严格
    // 值虽然修改成功了（可以打印Cat结构体发现weight已经改掉了），但get出来还是0.0
    // 所以建议使用`private(set) var`取代`let`
    //private(set) var weight: Double = 0.0
    
    //NSNull类型
    var data: NSNull?
    
    //Set、数组 要求存放的元素 【遵守Hashable协议】
    var books:Set<BaseStruct>?
    
    
    // 由于Swift初始化机制的原因，`Convertible`协议强制要求实现init初始化器
    // 这样框架内部才可以完整初始化一个实例
    required init() {} //所有继承 BaseModel的类，则不用写这个方法了
}

// 继承自NSObject的类也是一样的用法
class BaseModelOC: NSObject, Convertible {
    //var name: String = ""
    //var age: Int = 0
    // 由于NSObject内部已经有init，因此Person算是重载init，需再加上`override`
    required override init() {}
}

///结构体 两种情况：1、属性已初始化，不用写 init方法  2、属性没初始化，必须写init方法！ ——> 属性必须初始化！！！
struct BaseStruct: Convertible,Hashable {
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


//MARK: ************************* 4、递归解析 *************************
//let json: [String: Any] = [
//    "name": "Jack",
//    "parent": ["name": "Jim"]
//]
class Person: Convertible {
    var name: String = ""
    var parent: Person?
    required init() {}
}

//MARK: ************************* 5、泛型 *************************
struct NetResponse<Element>: Convertible {
    let data: Element? = nil
    let msg: String = ""
    private(set) var code: Int = 0
}
 
struct User: Convertible {
    let id: String = ""
    let nickName: String = ""
}

//let response2 = json2.kj.model(NetResponse<[Goods]>.self)

//MARK: ************************* 6、数组 *************************
struct Car: Convertible {
    var name: String = ""
    var price: Double = 0.0
}
 
// json数组可以是Array<[String: Any]>、NSArray、NSMutableArray
let jsonCar: [[String: Any]] = [
    ["name": "Benz", "price": 98.6],
    ["name": "Bently", "price": 305.7],
    ["name": "Audi", "price": 64.7]
]

// 调用json数组的modelArray方法即可
//let cars = json.kj.modelArray(Car.self)

//MARK: ************************* 8、把JSON数据转换到原本已经创建好的模型实例上 *************************
struct Cat: Convertible {
    var name: String = ""
    var weight: Double = 0.0
}
 
//let json: [String: Any] = [
//    "name": "Miaomiao",
//    "weight": 6.66
//]
 
var cat = Cat()
// .kj_m是.kj的mutable版本，牵扯到修改实例本身都是.kj_m开头
//cat.kj_m.convert(json)

//MARK: ************************* 9、监听json数据转换 前后事件 *************************
// 有时候可能想在JSON转模型之前、之后做一些额外的操作
// KakaJSON会在JSON转模型之前调用模型的kj_willConvertToModel方法
// KakaJSON会在JSON转模型之后调用模型的kj_didConvertToModel方法
 
struct CarB: Convertible {
    var name: String = ""
    var age: Int = 0
    
    mutating func kj_willConvertToModel(from json: [String: Any]) {
        print("Car - kj_willConvertToModel")
    }
    
    mutating func kj_didConvertToModel(from json: [String: Any]) {
        print("Car - kj_didConvertToModel")
    }
}
