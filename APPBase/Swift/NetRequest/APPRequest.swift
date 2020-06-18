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
    
    //子类可以重写该方法，进行key的 映射匹配
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        // 根据属性名来返回对应的key
        switch property.name {
            
        //1、模型的`nickName`属性 对应 JSON中的`nick_name`
        //case "nickName": return "nick_name" //采用枚举形式进行返回映射的key
            
        //2、模型剩下的其他属性，直接用属性名作为JSON的key（属性名和key保持一致）
        default: return property.name
            
        }
    }
    
    
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
class Person_Demo: Convertible {
    var name: String = ""
    var parent: Person_Demo?
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

//MARK: ************************* 二、JSON转Model_02_ 数据类型不同转换处理 (自动转换类型——>不管类型是否一致，KJ框架都会 去解析) *************************
/**
 官方文档 ：https://www.cnblogs.com/mjios/p/11355295.html
 0、解析失败，所以使用默认值(属性初始值)
 1、Int—> 字符串 true \ TRUE \ YES \ yes 都为1，字符串 false \ FALSE \ NO \ no 都为0
 2、Float—> 字符串 true \ TRUE \ YES \ yes 都为1.0，字符串 false \ FALSE \ NO \ no 都为0.0
 3、Double—>字符串 true \ TRUE \ YES \ yes 都为1.0，字符串 false \ FALSE \ NO \ no 都为0.0
 4、CGFloat—>同上
 5、Bool—> 数值0为false，数值非0都是true(注意！！！！！)  字符串  true \ TRUE \ YES \ yes  都为true  /  字符串  false \ FALSE \ NO \ no  都为false
 6、String—> 不管是String、NSString，还是NSMutableString，都是等效支持的    【数组或字典  相当于默认调用了数组、字典 的 description方法 】—>把数组和字典进行转换成字符串
 7、Decimal 、NSDecimalNumber
 9、NSNumber  解析成 Int、float 再转 NSNumber
 10、Optional  再多?都不是问题
 11、URL —> 支持URL和NSURL，默认会将 String 转为 URL \ NSURL
 12、Data—> 支持NSData 和 Data，默认会将 String 转为 Data \ NSData
 13、Date—> 支持Date 和 NSDate，默认会将  毫秒数  转为  Date \ NSDate  [ public typealias TimeInterval = Double —> 数值类型的 自动转 Date日期类型]
 14、Enum—> 遵守一下  ConvertibleEnum 协议   即可支持带有  RawValue  的Enum类型
 15、Enum数组  同上
 16、字典嵌套Enum 同上
 17、字典嵌套Enum数组 同上
 18、Array—> 支持Array、NSArray、NSMutableArray与Set、NSSet、NSMutableSet之间自动转换
 19、Set—> 支持Set、NSSet、NSMutableSet与Array、NSArray、NSMutableArray之间自动转换
 */

//MARK: ************************* 三、JSON转Model_03_ key不同的处理/路径key  重写kj_modelKey方法 *************************
//官方文档：https://www.cnblogs.com/mjios/p/11361397.html
struct Demo_key: Convertible {
    var nickName: String = ""
    var mostFavoriteNumber: Int = 0
    var birthday: String = ""
    
    //1、一般用法
    // 实现kj_modelKey方法
    // 会传入模型的属性`property`作为参数，返回值就是属性对应的key
    func kj_modelKey1(from property: Property) -> ModelPropertyKey {
        // 根据属性名来返回对应的key
        switch property.name {
            
        //1、模型的`nickName`属性 对应 JSON中的`nick_name`
        case "nickName": return "nick_name" //采用枚举形式进行返回映射的key
            
        // 模型的`mostFavoriteNumber `属性 对应 JSON中的`most_favorite_number `
        case "mostFavoriteNumber": return "most_favorite_number"
            
        //2、模型剩下的其他属性，直接用属性名作为JSON的key（属性名和key保持一致）
        default: return property.name
            
        }
    }
    
    //2、驼峰 ——>映射
    func kj_modelKey2(from property: Property) -> ModelPropertyKey {
        // 由于开发中可能经常遇到`驼峰`映射`下划线`的需求，KakaJSON已经内置了处理方法
        // 直接调用字符串的underlineCased方法就可以从`驼峰`转为`下划线`
        // `nickName` -> `nick_name`
        return property.name.kj.underlineCased()
    }
     
    
    //3、下划线 -> 驼峰
    // KakaJSON也给字符串内置了camelCased方法，可以由`下划线`转为`驼峰`
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        // `nick_name` -> `nickName`
        return property.name.kj.camelCased()
    }
    
    //4、2和3的 驼峰-下划线 ——> 父类实现了，子类可以继承父类的实现，子类不用再实现该方法
    
    //5、子类可以  重写  父类的kj_modelKey方法，在父类实现的基础上加一些自己的需求
    /**
     override func kj_modelKey5(from property: Property) -> ModelPropertyKey {
         // 调用了`super.kj_modelKey`，在父类的基础上加了对`score`的处理
         // `score` -> `_score_`，`name` -> `_name_`
         return property.name == "score" ? "_score_" : super.kj_modelKey(from: property)
     }
     */
    
    //6、子类可以  重写  父类的kj_modelKey方法，并 完全 覆盖 父类  的实现
    
    //7、全局配置
    /**
     一旦有需要进行`驼峰` -> `下划线`的映射，有可能整个项目的所有模型都需要进行映射，毕竟整个项目的命名规范是统一的
     假设项目中有100多个模型，那么就需要实现100多次`kj_modelKey`方法，调用100多次underlineCased方法
     KakaJSON内置了全局配置机制，可以1次配置，就能适用于所有的模型（不管是struct还是class，只要是遵守Convertible协议的模型）
     
     // 全局配置整个项目中只需要配置1次，建议在AppDelegate的didFinishLaunching中配置1次即可
     ConvertibleConfig.setModelKey { property in
         property.name.kj.underlineCased()
     }
     */
    
    //8、局部配置
    /**
     // 由于Student继承自Person，所以给Person做的配置，能适用在Student身上
     ConvertibleConfig.setModelKey(for: [Person.self, Car.self]) {
         property in
         property.name.kj.underlineCased()
     }
     */
    
    //9、多种配置执行顺序
    /*
    当配置了多处modelKey时，它们的优先级从高到低，如下所示（以Student类型为例）
    1. 使用Student的kj_modelKey的实现
    2. 如果没有1，使用Student的ConvertibleConfig配置
    3. 如果没有1\2，使用Student父类的ConvertibleConfig配置
    4. 如果没有1\2\3，使用Student父类的父类的ConvertibleConfig配置
    5. 如果没有1\2\3\4，使用Student父类的父类的父类的....ConvertibleConfig配置
    6. 如果没有1\2\3\4\5，使用全局的ConvertibleConfig配置
    */
    
    //11、复杂的key映射 (指定某个路径下的key)
    struct Toy: Convertible {
        var price: Double = 0.0
        var name: String = ""
    }
     
    struct Dog: Convertible {
        var name: String = ""
        var age: Int = 0
        var nickName: String?
        var toy: Toy?
        
        func kj_modelKey(from property: Property) -> ModelPropertyKey {
            switch property.name {
            // 对应dog["toy"]
            case "toy": return "dog.toy"
            // 对应data[1]["dog"]["name"]
            case "name": return "data.1.dog.name"
            // 会按顺序映射数组中的每一个key，直到成功为止
            // 先映射`nickName`，如果失败再映射`nick_name`
            // 如果失败再映射`dog["nickName"]`，如果失败再映射`dog["nick_name"]`
            case "nickName": return ["nickName", "nick_name", "dog.nickName", "dog.nick_name"]
            default: return property.name
            }
        }
    }
     
    let json: [String: Any] = [
        "data": [10, ["dog" : ["name": "Larry"]]],
        "age": 5,
        "nickName": "Jake1",
        "nick_name": "Jake2",
        "dog": [
            "nickName": "Jake3",
            "nick_name": "Jake4",
            "toy": ["name": "Bobbi", "price": 20.5]
        ]
    ]
     
    //let dog = json.kj.model(Dog.self)
    
}
/**
 let nick_name = "ErHa"
 let most_favorite_number = 666
 let birthday = "2011-10-12"
  
 let json: [String: Any] = [
     "nick_name": nick_name,
     "most_favorite_number": most_favorite_number,
     "birthday": birthday
 ]
  
 let student = json.kj.model(Demo_key.self)
 */

//MARK: ************************* 四、JSON转Model_04_ 值过滤  重写kj_modelValue方法(设置value类型) *************************
//官方文档：https://www.cnblogs.com/mjios/p/11365528.html
// 这2个DateFormatter仅仅为了举例子而写的，具体细节根据自己需求而定
//设置数据 转换 格式
private let date1Fmt: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd"
    return fmt
}()
 
private let date2Fmt: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return fmt
}()
 
struct Student_Demo: Convertible {
    var date1: Date?
    var date2: NSDate?
 
    //1、对 key 对应的JSON数据value，进行设置转换
    // 实现kj_modelValue方法
    // 会传入属性`property`以及这个属性对应的JSON值`jsonValue`
    // 返回值是你希望最后设置到模型属性上的值
    // 如果返回`jsonValue`，代表不做任何事，交给KakaJSON内部处理
    // 如果返回`nil`，代表忽略这个属性，KakaJSON不会给这个属性设值（属性会保留它的默认值）
    func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any? {
        switch property.name {
 
        // 如果jsonValue是字符串，就直接转成Date
        case "date1": return (jsonValue as? String).flatMap(date1Fmt.date)
 
        // 如果jsonValue是字符串，就直接转成Date
        // 由于NSDate与Date之间是可以桥接转换的，所以返回Date给NSDate属性也是没有问题的
        case "date2": return (jsonValue as? String).flatMap(date2Fmt.date)
 
        default: return jsonValue
 
        }
    }
    
    //2、不确定类型 参考文档
    // 有时候服务器返回的某个字段的内容类型可能是不确定的
    // 客户端可以先标记为 Any 类型 或者 AnyObject类型或者协议类型等不确定类型
    
}

//MARK: ************************* 五、JSON转Model_05_ 动态模型  重写kj_modelType方法 *************************
//官方文档：https://www.cnblogs.com/mjios/p/11367149.html
/**
 struct Book: Convertible {
     var name: String = ""
     var price: Double = 0.0
 }
  
 struct Car: Convertible {
     var name: String = ""
     var price: Double = 0.0
 }
  
 struct Pig: Convertible {
     var name: String = ""
     var height: Double = 0.0
 }
  
 struct Dog: Convertible {
     var name: String = ""
     var weight: Double = 0.0
 }
  
 struct Person: Convertible {
     var name: String = ""
     var pet: Any?
  
     // 这里用`NSArray`、`NSMutableArray`也行
     var toys: [Any]?
  
     // 这里用`NSDictionary`、`NSMutableDictionary`也行
     var foods: [String: Any]?
  
     func kj_modelType(from jsonValue: Any?, _ property: Property) -> Convertible.Type? {
         switch property.name {
         case "toys": return Car.self  // `toys`数组存放`Car`模型
         case "foods": return Book.self  // `foods`字典存放`Book`模型
         case "pet":
             if let pet = jsonValue as? [String: Any], let _ = pet["height"] {
                 // 如果`pet`属性的`jsonValue`是个字典，并且有`height`这个key，就转为`Pig`模型
                 return Pig.self
             }
             // 将`jsonValue`转为`Dog`模型赋值给`pet`属性
             return Dog.self
         default: return nil
         }
     }
 }
 */

//MARK: ************************* 六、06_ Model转JSON   ( 1>JSONObject(from: car)->字典 / 2>JSONString(from: car)->字符串  / 3>返回指定的key 重写kj_JSONKey方法) / 4>Enum  遵守`ConvertibleEnum`协议 *************************
//官方文档：https://www.cnblogs.com/mjios/p/11370361.html
struct Car_demo: Convertible {
     var name: String = "Bently"
     var new: Bool = true
     var age: Int = 10
     var area: Float = 0.12345678
     var weight: Double = 0.1234567890123456
     var height: Decimal = 0.123456789012345678901234567890123456789
     var price: NSDecimalNumber = NSDecimalNumber(string: "0.123456789012345678901234567890123456789")
     var minSpeed: Double = 66.66
     var maxSpeed: NSNumber = 77.77
     var capacity: CGFloat = 88.88
     var birthday: Date = Date(timeIntervalSince1970: 1565922866)
     var url: URL? = URL(string: "http://520suanfa.com")
}

//1、model ——> 生成 JSON对象(数组、字典) 和 JSONString
let car = Car_demo()
// 将模型实例car转为JSON
let json1 = car.kj.JSONObject()
// 也可以调用全局函数`JSONObject(from:)`
let json2 = JSONObject(from: car)
 
// 将模型实例car转为JSONString
let jsonString1 = car.kj.JSONString()
// 也可以调用全局函数`JSONString(from:)`
let jsonString2 = JSONString(from: car)
 
//2、可选类型的问号?并不会影响JSON或者JSONString的生成

//3、Enum  遵守了`ConvertibleEnum`协议、带有RawValue的Enum，能自动将RawValue转为JSON
/**
 struct Student: Convertible {
     var grade1: Grade = .great
     var grade2: Grade = .bad
 }
  
 let jsonString = Student().kj.JSONString()
 
 /* {"grade2":"D","grade1":"B"} */
 */

//4、模型嵌套 ——> 直接使用 JSONObject(from: car)->字典 / JSONString(from: car)->字符串

//5、Any ——> 同上

//6、Model数组 直接使用 JSONObject(from: models)->字典 / JSONString(from: models)->字符串
/**
 struct Car: Convertible {
     var name: String = ""
     var price: Double = 0.0
 }
  
 // `models`也可以是NSArray\NSMutableArray
 let models:[Car] / Set<Car> =  [
     Car(name: "BMW", price: 100.0),
     Car(name: "Audi", price: 70.0),
     Car(name: "Bently", price: 300.0)
 ]
  
 let jsonString = models.kj.JSONString()
 let jsonString = JSONString(from: models)
 */

//7、Set集合 同上

//8、Key处理
struct Demo_json8: Convertible {
    var nickName: String = "Wang"
    var price: Double = 100.6
    
    // 可以通过实现`kj_JSONKey`方法自定义最终生成JSON的key
    func kj_JSONKey(from property: Property) -> JSONPropertyKey {
        switch property.name {
        case "nickName": return "_nick_name_"
        default: return property.name
        }
    }
    
    // 当Model即将开始转换为JSON时调用
    func kj_willConvertToJSON() {
        print("Car - kj_willConvertToJSON")
    }
    
    // 当Model转换JSON完毕时调用
    func kj_didConvertToJSON(json: [String: Any]) {
        print("Car - kj_didConvertToJSON", json)
    }
}
//let jsonString = Dog().kj.JSONString()
/* {"price":100.6,"_nick_name_":"Wang"} */

//9、值过滤 （用法参考官方文档）

//10、监听 ： 8中的代码 实现方法  1>func kj_willConvertToJSON()  2>func kj_didConvertToJSON(json: [String: Any])

//MARK: ************************* 七、JSON转Model_07_ Codeing归档+解档  写入数据:write(string1, to: file) / 读取数据：read(String.self, from: file) *************************
//官方文档：https://www.cnblogs.com/mjios/p/11395195.html
//一行代码将常用数据进行归档\解档
class Demo_coding:BaseModel {
     
    //用法  write / read 方法用在 方法中触发的
    func modelCodingToFile() {

        write("",to: "filePath")
        let data:Any? = read(Demo_coding.self,from: "filePath")
    }
    // 文件路径（String或者URL都可以）
    let file = "/Users/mj/Desktop/test.data"

    //1、字符串
    let string1 = "123"
    // 将字符串写入文件
    //write(string1, to: file)
    // 从文件中读取字符串
    //let string2 = read(String.self, from: file)

    //2、Date 日期
    let date1 = Date(timeIntervalSince1970: 1565922866)
    // 将Date写入文件
    //write(date1, to: file)
     
    // 从文件中读取Date
    //let date2 = read(Date.self, from: file)
    
    //3、数组
    let array1 = ["Jack", "Rose"]
    // 将数组写入文件
    //write(array1, to: file)
     
    // 从文件中读取数组
    //let array2 = read([String].self, from: file)
    
    //4、Model
    // 将模型写入文件
    //write(Demo_coding(), to: file)
     
    // 从文件中读取模型
    //let person = read(Demo_coding.self, from: file)
    
    //5、Model Array
    // 将模型数组写入文件
    //write(models1, to: file)
     
    // 从文件中读取模型数组
    //let models2 = read([Car].self, from: file)
    
    //6、Model Set
//    let models1: Set<Any> = [
//        Demo_coding(),
//        Demo_coding()
//    ]
     
    // 将模型Set写入文件
    //write(models1, to: file)
     
    // 从文件中读取模型Set
    //let models2 = read(Set<Car>.self, from: file)!
    
    //7、Model Dictionary
    let models2 = [
        "car0": Demo_coding(),
        "car1": Demo_coding()
    ]
     
    // 将模型字典写入文件
    //write(models2, to: file)
     
    // 从文件中读取模型字典
    //let models2 = read([String: Car].self, from: file)
}

//MARK: ************************* 八、JSON转Model_08_ 其他用法 *************************
class Demo_08 {
    
    //1、遍历属性
    
}
