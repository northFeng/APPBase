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
}

//MARK: ************************* 请求工具类 *************************
class APPNetTool {
    
    
    
}
