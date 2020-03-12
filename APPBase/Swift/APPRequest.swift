//
//  APPRequest.swift
//  APPBase
//  Swift请求
//  Created by 峰 on 2020/3/5.
//  Copyright © 2020 ishansong. All rights reserved.
//

import Foundation

//MARK: ************************* Swift中model类都集成这个基类 *************************
//官方用法教程：https://www.cnblogs.com/mjios/category/1526581.html
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
 3、var books:Set<BaseStruct>?    Set 要求存放的元素 【遵守Hashable协议】
 4、递归解析
 5、泛型  let response1 = json1.kj.model(NetResponse<User>.self)
 6、解析数组  let cars = json.kj.modelArray(Car.self)   modelArray(from:jsonData, Car.self)
 7、字典里套数组 （跟普通解析一样）不用遵守Hashable协议，只是Set<>集合才遵守
 8、已有的model实例 ， 直接把json数据赋值给model实例  var cat = Cat() cat.kj_m.convert(json)
 9、监听json数据转换 前后事件   func kj_willConvertToModel(){}    func kj_didConvertToModel(){}
 */

/**
 为了方便起见：所有的model的属性全部直接初始化！
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
    //var data: NSNull?
    
    //Set要求存放的元素 【遵守Hashable协议】
    //var books:Set<BaseStruct>?
    
    
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
/**
struct NetResponse<Element>: Convertible {
    let data: Element? = nil
    let msg: String = ""
    private(set) var code: Int = 0
}
 
struct User: Convertible {
    let id: String = ""
    let nickName: String = ""
}

let response2 = json2.kj.model(NetResponse<[User]>.self)
*/

//MARK: ************************* 6、数组 *************************
/**
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
let cars = json.kj.modelArray(Car.self)
 */

//MARK: ************************* 7、字典里套数组 *************************
/**
class Student:BaseModel {
    
    var name:String = ""
    
    var weight:Double = 0.0
    
    var demos:[Demo]?
    
    
    func aaa() {
        name = "哈哈哈"
        weight = 8.2
    }
}

class Demo:BaseModel {
    
    var name:String = ""
    
    var weight:Double = 0.0
}

let jsonStr:[String:Any] = ["name":"张三","weight":6.66,"demos":[["name":"小猫","weight":6.66],["name":"小狗","weight":7.66]]]

let one1 = jsonStr.kj.model(Student.self) //调用json的model方法，传入模型类型，返回模型实例
 */

//MARK: ************************* 8、把JSON数据转换到原本已经创建好的模型实例上 *************************
/**
struct Cat: Convertible {
    var name: String = ""
    var weight: Double = 0.0
}
 
let json: [String: Any] = [
    "name": "Miaomiao",
    "weight": 6.66
]
 
var cat = Cat()
// .kj_m是.kj的mutable版本，牵扯到修改实例本身都是.kj_m开头
cat.kj_m.convert(json)
 */

//MARK: ************************* 9、监听json数据转换 前后事件 *************************
// 有时候可能想在JSON转模型之前、之后做一些额外的操作
// KakaJSON会在JSON转模型之前调用模型的kj_willConvertToModel方法
// KakaJSON会在JSON转模型之后调用模型的kj_didConvertToModel方法
/**
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
 */

//MARK: ************************* 二、JSON转Model_02_ 数据类型(自动转换类型——>不管类型是否一致，KJ框架都会 去解析) *************************
/**
 0、解析失败，所以使用默认值(属性初始值)
 1、Int—> 字符串 true \ TRUE \ YES \ yes 都为1，字符串 false \ FALSE \ NO \ no 都为0
 2、Float—> 字符串 true \ TRUE \ YES \ ye 都为1.0，字符串 false \ FALSE \ NO \ no 都为0.0
 3、Double—>字符串 true \ TRUE \ YES \ ye 都为1.0，字符串 false \ FALSE \ NO \ no 都为0.0
 4、CGFloat—>同上
 5、Bool—> 数值0为false，数值非0都是true(注意)  字符串  true \ TRUE \ YES \ ye  都为true  /  字符串  false \ FALSE \ NO \ no  都为false
 6、String—> 不管是String、NSString，还是NSMutableString，都是等效支持的    【数组或字典  相当于默认调用了数组、字典 的 description方法 】—>把数组和字典进行转换成字符串
 7、Decimal 、NSDecimalNumber
 9、NSNumber  解析成 Int、float 再转 NSNumber
 10、Optional  再多?都不是问题
 11、URL —> 支持URL和NSURL，默认会将 String 转为 URL \ NSURL
 12、Data—> 支持NSData 和 Data，默认会将 String 转为 Data \ NSData
 13、Date—> 支持Date 和 NSDate，默认会将  毫秒数  转为  Date \ NSDate  [ public typealias TimeInterval = Double —> 数值类型的 自动转 Date日期类型]
 14、Enum—> 遵守一下  ConvertibleEnum 协议   即可支持带有  RawValue  的Enum类型
 15、Enum数组  同上
 16、
 */
