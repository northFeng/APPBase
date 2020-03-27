//
//  APPNetTool.swift
//  APPBase
//
//  Created by 峰 on 2020/3/14.
//  Copyright © 2020 ishansong. All rights reserved.
//

import Foundation

//MARK: ************************* Alamofire用法 *************************
//官方文档：https://github.com/Alamofire/Alamofire
//https://www.cnblogs.com/jukaiit/p/9283498.html
//简书翻译中文版：https://www.jianshu.com/p/4381fe8e10b6   高级用法：https://github.com/Lebron1992/learning-notes/blob/master/docs/alamofire5/03%20-%20Alamofire%205%20的使用%20-%20高级用法.md

//MARK: ************************* 学习记录 *************************
func AlamofireRequest() {
    
    //基本请求
    AF.request("https://httpbin.org/get").response { response in
        debugPrint(response)
    }
    
    //所有请求参数
    /**
     //第一个版本
     func request<Parameters: Encodable>(
         _ convertible: URLConvertible, //URL
         method: HTTPMethod = .get, //请求类型
         parameters: Parameters? = nil, //请求参数  public typealias Parameters = [String: Any]  Dictionary()类型
         encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default, //请求参数编码类型
         headers: HTTPHeaders? = nil, //请求头
         interceptor: RequestInterceptor? = nil //请求拦截器
     ) -> DataRequest
     
     //第二个版本
     open func request(
         _ urlRequest: URLRequestConvertible, //参数都封装在该参数中
         interceptor: RequestInterceptor? = nil
     ) -> DataRequest
     */
    
    /**
     1、URLSession 或 Alamofire 不支持在 GET 请求中传递 body 数据，并将返回错误。
     */
    
    struct Login: Encodable {
        let email: String
        let password: String
    }

    let login = Login(email: "test@test.test", password: "testPassword")

    AF.request("https://httpbin.org/post",
               method: .post,
               parameters: login,
               encoder: JSONParameterEncoder.default).response { response in
        
    }
    
    let parameters: [String: [String]] = [
        "foo": ["bar"],
        "baz": ["a", "b"],
        "qux": ["x", "y", "z"]
    ]

    //2、 下面三种方法都是等价的
    AF.request("https://httpbin.org/post", method: .post, parameters: parameters)
    AF.request("https://httpbin.org/post", method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
    AF.request("https://httpbin.org/post", method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .httpBody))
    
    /**
     从 Swift 4.2 开始，Swift 的 Dictionary 类型使用的随机算法在运行时产生一个  【随机的内部顺序】  ，并且在应用程序的每次启动都是不同的。这可能会导致已编码参数更改顺序，这可能会  【影响缓存和其他行为】。 【默认情况下，URLEncodedFormEncoder 将对其编码的键值对进行排序】 。虽然这会为所有 Encodable 类型生成常量输出，但它可能与该类型实现的实际编码顺序不匹配。您可以将 alphabetizeKeyValuePairs 设置为 false 以返回到实现的顺序，因此这将变成随机 Dictionary 顺序。
     
     您可以创建自己的 URLEncodedFormParameterEncoder，在初始化时，可以在 URLEncodedFormEncoder 参数中设置 alphabetizeKeyValuePairs 的值:
     */
    let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(alphabetizeKeyValuePairs: false))
    
    //MARK: ************************* HTTP Headers *************************
    /**  3、  HTTP Headers
     Alamofire 包含自己的 HTTPHeaders 类型，这是一种顺序保持且不区分大小写的 HTTP header name/value 对的表示。HTTPHeader 类型封装单个 name/value 对，并为常用的 headers 提供各种静态值。
     
     对于不会变的 HTTP headers，建议在 URLSessionConfiguration 上设置它们，以便让它们自动应用于底层 URLSession 创建的任何 URLSessionTask。
     
     默认的 Alamofire Session 为每个 Request 提供一组默认的 headers。其中包括：

     Accept-Encoding，默认为 br;q=1.0, gzip;q=0.8, deflate;q=0.6，根据 RFC 7230 §4.2.3。
     Accept-Language，默认为系统中最多 6 种首选语言，格式为 en;q=1.0，根据 RFC 7231 §5.3.5。
     User-Agent，其中包含有关当前应用程序的版本信息。例如：iOS Example/1.0 (com.alamofire.iOS-Example; build:1; iOS 13.0.0) Alamofire/5.0.0，根据 RFC 7231 §5.5.3。
     如果需要自定义这些 headers，则应创建自定义 URLSessionConfiguration，更新 defaultHTTPHeaders 属性，并将配置应用于新 Session 实例。使用URLSessionConfiguration.af.default 来自定义配置，会保留 Alamofire 的默认 headers。
     */
    //第一种HTTPHeader
    let headers: HTTPHeaders = [
        "Authorization": "Basic VXNlcm5hbWU6UGFzc3dvcmQ=",
        "Accept": "application/json"
    ]
    AF.request("https://httpbin.org/headers", headers: headers).responseJSON { response in
        debugPrint(response)
    }
    //第二种HTTPHeader
    AF.session.configuration.httpAdditionalHeaders = ["":""]
    AF.session.configuration.timeoutIntervalForRequest = 15;//请求超时15秒
    
    /**
     4、响应验证
     默认情况下，无论响应的内容如何，Alamofire 都会将任何已完成的请求视为成功。如果响应具有不可接受的状态代码或 MIME 类型，则在响应处理程序之前调用 validate() 将导致生成错误。
     */
    
    //自动验证  validate() API 自动验证状态代码是否在 200..<300 范围内，以及响应的 Content-Type header 是否与请求的 Accept 匹配（如果有提供）。
    AF.request("https://httpbin.org/get").validate().responseJSON { response in
        debugPrint(response)
    }
    
    AF.request("https://httpbin.org/get")
    .validate(statusCode: 200..<300)
    .validate(contentType: ["application/json"])
    .responseData { response in
        switch response.result {
        case .success:
            print("Validation Successful")
        case let .failure(error):
            print(error)
        }
    }
   
    
    //MARK: ************************* 请求响应 *************************
    /**
     5、响应处理  Alamofire 的网络请求是异步完成的
     */
    
}

//MARK: ************************* 请求工具类 *************************
class APPNetTool {
    
    
    
}
