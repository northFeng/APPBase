//
//  APPNetTool.swift
//  APPBase
//
//  Created by 峰 on 2020/3/14.
//  Copyright © 2020 ishansong. All rights reserved.
//

import Foundation

import Alamofire//网络请求

//MARK: ************************* Alamofire用法 *************************
//官方文档：https://github.com/Alamofire/Alamofire
//https://www.cnblogs.com/jukaiit/p/9283498.html
//简书翻译中文版：https://www.jianshu.com/p/4381fe8e10b6   高级用法：https://github.com/Lebron1992/learning-notes/blob/master/docs/alamofire5/03%20-%20Alamofire%205%20的使用%20-%20高级用法.md

//MARK: ************************* 学习记录 *************************
func AlamofireRequest() {
    
    //MARK: ************************* 1、基本用法 *************************
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
    
    //MARK: ************************* 3、HTTP Headers *************************
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
    AF.sessionConfiguration.httpAdditionalHeaders = ["":""]
    AF.sessionConfiguration.timeoutIntervalForRequest = 15;//请求超时15秒
    
    //MARK: ************************* 4、响应验证 *************************
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
   
    
    //MARK: ************************* 5、请求响应 *************************
    /**
     5、响应处理  Alamofire 的网络请求是异步完成的
     
     如果未指定编码，Alamofire 将使用服务器 HTTPURLResponse 中指定的文本编码。如果服务器响应无法确定文本编码，则默认为 .isoLatin1。
     */
    //1> 响应 Handler -> 不计算任何响应数据。它只是直接从 URLSessionDelegate 转发所有信息
    AF.request("https://httpbin.org/get").response { response in
        debugPrint("Response: \(response)")
    }
    //2> 响应Data Handler -> 使用 DataResponseSerializer 提取并验证服务器返回的数据
    AF.request("https://httpbin.org/get").responseData { response in
        debugPrint("Response: \(response)")
    }
    //3> 响应 String Handler -> 使用 StringResponseSerializer 将服务器返回的数据转换为具有指定编码的 String。
    AF.request("https://httpbin.org/get").responseString { response in
        debugPrint("Response: \(response)")
    }
    //4> 响应 JSON Handler -> 使用 JSONResponseSerializer 使用指定的 JSONSerialization.ReadingOptions 将服务器返回的数据转换为 Any 类型。如果没有出现错误，并且服务器数据成功序列化为 JSON 对象，则响应 AFResult 将为 .success，值将为 Any 类型。
    AF.request("https://httpbin.org/get").responseJSON { response in
        debugPrint("Response: \(response)")
    }
    //4> 响应 Decodable Handler ->使用 DecodableResponseSerializer 和 指定的 DataDecoder（Decoder 的协议抽象，可以从 Data 解码）将服务器返回的数据转换为传递进来的 Decodable 类型。如果没有发生错误，并且服务器数据已成功解码为 Decodable 类型，则响应 Result 将为 .success，并且 value 将为传递进来的类型。
    struct HTTPBinResponse: Decodable {
        let url: String
    }
    AF.request("https://httpbin.org/get").responseDecodable(of: HTTPBinResponse.self) { response in
        debugPrint("Response: \(response)")
    }
    //5> 链式响应 handlers -> 响应 handlers 还可以连接起来：
    AF.request("https://httpbin.org/get").responseString { response in
        
        print("Response String: \(String(describing: response.value))")
    }.responseJSON { response in
        
        print("Response JSON: \(String(describing: response.value))")
    }
    //6> 响应 Handler 队列 -> 默认情况下，传递给响应 handler 的闭包在 .main 队列上执行，但可以传递一个指定的 DispatchQueue 来执行闭包。实际的序列化工作（将 Data 转换为其他类型）总是在后台队列上执行。
    let utilityQueue = DispatchQueue.global(qos: .utility)//创建一个队列
    AF.request("https://httpbin.org/get").responseJSON(queue: utilityQueue) { response in
        print("Executed on utility queue.")
        debugPrint(response)
    }
    
    //MARK: ************************* 6、响应缓存 *************************
    /**
     响应缓存使用系统自带的 URLCache 处理。它提供了内存和磁盘上的复合缓存，并允许您管理用于缓存的内存和磁盘的大小。
     默认情况下，Alamofire 利用 URLCache.shared 实例。
     */
    
    //MARK: ************************* 7、身份验证 *************************
    /**
     身份验证使用系统自带的 URLCredential 和 URLAuthenticationChallenge 处理。
     支持的身份验证方案：
     HTTP Basic
     HTTP Digest
     Kerberos
     NTLM
     */
    //1、HTTP Basic 身份验证
    let user = "user"
    let password = "password"

    AF.request("https://httpbin.org/basic-auth/\(user)/\(password)")
        .authenticate(username: user, password: password)
        .responseJSON { response in
            debugPrint(response)
        }
    //2、URLCredential 进行验证  -> 需要注意的是，当使用 URLCredential 进行身份验证时，如果服务器发出质询，底层 URLSession 实际上将发出两个请求。第一个请求将不包括“可能”触发服务器质询的 credential。然后，Alamofire 接收质询，追加 credential，并由底层 URLSession 重试请求.
    let credential = URLCredential(user: user, password: password, persistence: .forSession)
    AF.request("https://httpbin.org/basic-auth/\(user)/\(password)")
        .authenticate(with: credential)
        .responseJSON { response in
            debugPrint(response)
        }
    //3、手动验证 -> 把身份验证 放进 header中
    let headersInfo: HTTPHeaders = [.authorization(username: user, password: password)]
    AF.request("https://httpbin.org/basic-auth/user/password", headers: headersInfo)
        .responseJSON { response in
            debugPrint(response)
        }
    
    AF.download("https://httpbin.org/image/png").responseData { response in
        if let data = response.value {
            let image = UIImage(data: data)
        }
    }
    
    //MARK: ************************* 高级用法 *************************
    //一、Session -> 创建自定义的 Session 实例
    /**
     public convenience init(
         configuration: URLSessionConfiguration = URLSessionConfiguration.af.default, //设置 配置参数（header、请求时长 等等）
         delegate: SessionDelegate = SessionDelegate(), //
         rootQueue: DispatchQueue = DispatchQueue(label: "org.alamofire.session.rootQueue"),
         startRequestsImmediately: Bool = true,// 默认情况下，Session 将在添加至少一个响应 handler 后立即对 Request 调用 resume()。将 startRequestsImmediately 设置为 false 需要手动调用所有请求的 resume() 方法。
         requestQueue: DispatchQueue? = nil, //线程  此队列必须是 【串行队列】，它必须具有备用 DispatchQueue，并且必须将该 DispatchQueue 作为其 rootQueue 传递给 Session。
         serializationQueue: DispatchQueue? = nil,
         interceptor: RequestInterceptor? = nil,
         serverTrustManager: ServerTrustManager? = nil,
         redirectHandler: RedirectHandler? = nil,
         cachedResponseHandler: CachedResponseHandler? = nil, //Alamofire 的 CachedResponseHandler 协议定制了响应的缓存，可以在 Session 和 Request 层级使用。Alamofire 包含 ResponseCacher 类型
         eventMonitors: [EventMonitor] = []
     )
     */
    let configuration = URLSessionConfiguration.af.default
    configuration.allowsCellularAccess = false
    configuration.timeoutIntervalForRequest = 15;//请求时长15秒
    //let session = Session(configuration: configuration)
    
}

//MARK: ************************* 请求工具类 *************************

///网络请求回调
typealias NetSuccess = (Any?, Int)->Void
typealias NetFailure = (Error)->Void
typealias NetResultData = (Bool, Any?, Int)->Void

class APPNetTool {
    
    //创建一个静态或者全局变量，保存当前单例实例值
    private static let singleInstance = APPNetTool()
    
    ///获取单利实例
    class func defaultSingleInstance() -> APPNetTool {
        return singleInstance
    }
    
    //MARK: ************************* 网络请求失败常用语 *************************
    static let HTTPErrorCancleMessage = "请求被取消"
    static let HTTPErrorTimeOutMessage = "请求超时"
    static let HTTPErrorNotConnectedMessage = "网络连接断开"
    static let HTTPErrorOthersMessage = "网络不给力"
    static let HTTPErrorServerMessage = "服务器繁忙"
    
    static let resultCode = 20000;//成功码
    
    var AFSession:Session {
        get{
            AF.sessionConfiguration.httpAdditionalHeaders = ["type":"ios"]
            AF.sessionConfiguration.timeoutIntervalForRequest = 15;//请求超时15秒
            
            return AF
        }
    }
    
    ///请求数据
    func requestData(method:HTTPMethod, url:String, parameters:[String:Any], success:NetSuccess, fail:NetFailure) {
        
        AFSession.request(url, method: method, parameters: parameters).responseJSON { response in
            
            /**
             switch response.result {
             case .success:

                 //AFDataResponse
                 /**
                  if let data = response.data {
                              
                      success(data,100)
                  }
                  print(response.request)  // original URL request
                  print(response.response) // HTTP URL response
                  print(response.data)     // server data
                  print(response.result)   // result of response serialization
                  */
                 print("Validation Successful")
             case let .failure(error):
                 print(error)
             }
             */
        }
    }
    
    
    //MARK: ************************* 常规get请求 *************************
    class func getData(url:String, params:[String:Any], success:NetSuccess, fail:NetFailure) {
        
        self.defaultSingleInstance().requestData(method: HTTPMethod.get, url: url, parameters: params, success: success, fail: fail )
    }
    
    func getData(url:String, params:[String:Any], success:NetSuccess, fail:NetFailure) {
        
        self.requestData(method: HTTPMethod.get, url: url, parameters: params, success: success, fail: fail )
    }
    
    //MARK: ************************* 常规post请求 *************************
    class func postData(url:String, params:[String:Any], success:NetSuccess, fail:NetFailure) {
        
        self.defaultSingleInstance().requestData(method: HTTPMethod.post, url: url, parameters: params, success: success, fail: fail )
    }
    
    func postData(url:String, params:[String:Any], success:NetSuccess, fail:NetFailure) {
        
        self.requestData(method: HTTPMethod.post, url: url, parameters: params, success: success, fail: fail )
    }
    
    
    //MARK: ************************* 普通请求 *************************
    class func getNetDicData(url:String, params:[String:Any], block:NetResultData) {
        
        let httpUrl:String = APPKeyInfo.hostURL().appending(url)
        
        self.getData(url: httpUrl, params: params, success: { (response, code) in
            
            let jsonData:[String:Any] = response as! [String:Any]
            
            let message:String = jsonData["message"] as! String
            
            var data = jsonData["data"]
            
            if data == nil {
                data = [String:Any]()
            }
            
            if code == resultCode {
                block(true, data, 100)
            }else{
                block(false, message, code)
            }
            
        }) { (error:Error) in
            block(false, HTTPErrorOthersMessage, 99)
        }
    }
    
    class func postNetDicData(url:String, params:[String:Any], block:NetResultData) {
        
        let httpUrl:String = APPKeyInfo.hostURL().appending(url)
        
        self.postData(url: httpUrl, params: params, success: { (response, code) in
            
            let jsonData:[String:Any] = response as! [String:Any]
            
            let message:String = jsonData["message"] as! String
            
            var data = jsonData["data"]
            
            if data == nil {
                data = [String:Any]()
            }
            
            if code == resultCode {
                block(true, data, 100)
            }else{
                block(false, message, code)
            }
            
        }) { (error:Error) in
            block(false, HTTPErrorOthersMessage, 99)
        }
    }
    
    //pod 'Networking', '~> 4'  https://github.com/3lvis/Networking
    //MARK: ************************* 封装AFNetworking *************************
    class func getNetDicData_oc(url:String, params:[String:Any], block:@escaping NetResultData) {
        
        //let httpUrl:String = APPKeyInfo.hostURL().appending(url)
        
        APPHttpTool.getRequestNetDicDataUrl(url, params: params) { (result:Bool, idObject:Any, code:Int) in
            
            block(result, idObject, code);//逃逸闭包注意 循环引用
        }
    }
    
    class func postNetDicData_oc(url:String, params:[String:Any], block:@escaping NetResultData) {
        
        //let httpUrl:String = APPKeyInfo.hostURL().appending(url)
       
        APPHttpTool.postRequestNetDicDataUrl(url, params: params) { (result:Bool, idObject:Any, code:Int) in
            
            block(result, idObject, code);
        }
    }
    
    ///模型转换
    class func jsonToModel(json:Any, Model:BaseModel.Type) -> Any? {

        var model:Any?;
        if json is [String:Any] {
            //字典
            let jsonDic:[String : Any] = json as! [String : Any]
            
            model = jsonDic.kj.model(Model.self)//json.kj.model(model.self)

        } else if json is [Any] {
            //数组
            let jsonArray:[Any] = json as! [Any]
            
            model = jsonArray.kj.modelArray(Model.self)
            
        } else {
            model = nil
        }
        return model
    }
    
    /**
     逃逸闭包：@escaping  1>函数内的 【闭包(函数)】 去外部执行  2>函数的  【闭包(函数)】异步执行  —> 加 @escaping 进行修饰 “考虑循环引用”，逃逸闭包内需要 【显式引用self】、非逃逸闭包可以 【隐式引用】

     当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸。当你定义接受闭包作为参数的函数时，你可以在参数名之前标注 @escaping，用来指明这个闭包是允许“逃逸”出这个函数的。

     一种能使闭包“逃逸”出函数的方法是，将这个闭包保存在一个函数外部定义的变量中。举个例子，很多启动异步操作的函数接受一个闭包参数作为 completion handler。这类函数会在异步操作开始之后立刻返回，但是闭包直到异步操作结束后才会被调用。在这种情况下，闭包需要“逃逸”出函数，因为闭包需要在函数返回之后被调用。
     
     例子：
     var completionHandlers: [() -> Void] = []
     func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
         completionHandlers.append(completionHandler)
     }
     
     class SomeClass {
         var x = 10
         func doSomething() {
             someFunctionWithEscapingClosure { self.x = 100 } //显式引用self
             someFunctionWithNonescapingClosure { x = 200 } //隐式引用
         }
     }
     
     自动闭包：@autoclosure
     自动闭包是一种自动创建的闭包，用于包装传递给函数作为参数的表达式。这种闭包不接受任何参数，当它被调用的时候，会返回被包装在其中的表达式的值。这种便利语法让你能够省略闭包的花括号，用一个普通的表达式来代替显式的闭包。
     var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
     print(customersInLine.count)
     // 打印出 "5"

     let customerProvider = { customersInLine.remove(at: 0) }
     print(customersInLine.count)
     // 打印出 "5"

     print("Now serving \(customerProvider())!")
     // Prints "Now serving Chris!"
     print(customersInLine.count)
     // 打印出 "4"

     作者：小驴拉磨
     链接：https://www.jianshu.com/p/d386392fa8c0
     */
    
}

/**  网络类使用 demo
 AlertLoading()
 APPNetTool.getNetDicData_oc(url: "v2/front/tag/getTagList", params: ["tagType":1]) { (result:Bool, idObject:Any, code:Int) in
     AlertHideLoading()
     if result {
         let arrayJson:[AnyObject] = idObject as! [AnyObject]
         
         let model = arrayJson.kj.modelArray(AudioModel.self)
         
         let model2 = APPNetTool.jsonToModel(json: arrayJson, Model: AudioModel.self)
         
         if let array:[AnyObject] = model2 as? [AnyObject] {
             Print("----->结果\(array)")
         }else{
             Print("数据转化失败")
         }
         /**
          chName = "\U8eab\U4f53\U90e8\U4f4d";
          createTime = "2019-12-12 10:42:58";
          enName = "Body Parts";
          picUrl = "http://wdkid-audio.oss-cn-beijing.aliyuncs.com/img/Body%20Parts.png";
          tagId = 3443534;
          tagStatus = 1;
          tagType = 4;
          updateTime = "2019-12-12 10:42:58";
          */
         Print("请求结果--->\(model)")
     } else {
         Print("请求出错--->\(idObject)")
     }
 }
 */
