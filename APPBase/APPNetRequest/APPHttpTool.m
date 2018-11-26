//
//  APPHttpTool.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/5/21.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "APPHttpTool.h"

#import "GFEncryption.h"

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>


@implementation APPHttpTool

+ (instancetype)sharedNetworking{
    
    static APPHttpTool *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[APPHttpTool alloc] init];
    });
    return handler;
}

///取消所有的网络请求
+ (void)cancelAllRequest{
    
    AFHTTPSessionManager *manager = [self getAFManager];
    if ([manager.tasks count] > 0) {
        NSLog(@"返回时取消网络请求");
        [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
        //NSLog(@"tasks = %@",manager.tasks);
    }
}

+ (void)getWithUrl:(NSString *)url params:(NSDictionary *)params success:(Success)success fail:(Failure)fail{
    
    NSLog(@"请求地址----%@\n    请求参数----%@",url,params);
    
    //检查地址中是否有中文
    NSString *urlStr = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    AFHTTPSessionManager *manager = [self getAFManager];
    
    //添加公共参数
    params = [self addPublicParameterWithDic:params];
    
    [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求结果=%@",responseObject);
        
        if (success) {
            NSInteger code = [responseObject[@"status"] integerValue];
            
            //后台协商进行用户登录异常提示 && 强制用户退出
            if (code == 300) {
                
                //用户登录过期 && 执行退出
                [[APPManager sharedInstance] forcedExitUserWithShowControllerItemIndex:2];
                
            }
            
            success(responseObject,code);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorNotConnectedToInternet) {
            NSLog(@"没有网络");
        }
        if (fail) {
            fail(error);
        }
    }];
}

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(Success)success fail:(Failure)fail
{
    NSLog(@"请求地址----%@\n    请求参数----%@",url,params);
    
    //检查地址中是否有中文
    NSString *urlStr = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    /**
     加密处理：对字段进行json序列化进行加密成字符串，进行发送到后台
     一定要判断请求的URL是否为上传图片，若为上传图片则不进行加密处理
     */
    
    AFHTTPSessionManager *manager=[self getAFManager];
    
    //添加公共参数
    params = [self addPublicParameterWithDic:params];
    
    [manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求结果=%@",responseObject);
        
        if (success) {
            
            NSInteger code = [responseObject[@"status"] integerValue];
            
            //后台协商进行用户登录异常提示 && 强制用户退出
            if (code == 300) {
                
                //用户登录过期 && 执行退出
                [[APPManager sharedInstance] forcedExitUserWithShowControllerItemIndex:2];
                
            }
            
            success(responseObject,code);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        if (fail) {
            fail(error);
        }
    }];
}

+ (void)deleteWithUrl:(NSString *)url params:(NSDictionary *)params success:(Success)success fail:(Failure)fail
{
    
    NSLog(@"请求地址----%@\n    请求参数----%@",url,params);
    //检查地址中是否有中文
    NSString *urlStr = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    AFHTTPSessionManager *manager=[self getAFManager];
    
    //添加公共参数
    params = [self addPublicParameterWithDic:params];
    
    [manager DELETE:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求结果=%@",responseObject);
        if (success) {
            
            NSInteger code = [responseObject[@"status"] integerValue];
            
            //后台协商进行用户登录异常提示 && 强制用户退出
            if (code == 300) {
                
                //用户登录过期 && 执行退出
                [[APPManager sharedInstance] forcedExitUserWithShowControllerItemIndex:2];
                
            }
            
            success(responseObject,code);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        if (fail) {
            fail(error);
        }
    }];
}


#pragma mark - 上传图片和视频
+ (void)uploadImageAndMovieName:(NSString *)fileName fileType:(NSString *)fileType filePath:(NSString *)filePath{
    
    //获取文件的后缀名
    NSString *extension = [fileName componentsSeparatedByString:@"."].lastObject;
    
    //设置mimeType
    NSString *mimeType;
    if ([fileType isEqualToString:@"image"]) {
        mimeType = [NSString stringWithFormat:@"image/%@", extension];
    } else {
        mimeType = [NSString stringWithFormat:@"video/%@", extension];
    }
    
    //创建AFHTTPSessionManager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置响应文件类型为JSON类型
    manager.responseSerializer    = [AFJSONResponseSerializer serializer];
    
    //初始化requestSerializer
    manager.requestSerializer     = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = nil;
    
    //设置timeout
    [manager.requestSerializer setTimeoutInterval:20.0];
    
    //设置请求头类型
    [manager.requestSerializer setValue:@"form/data" forHTTPHeaderField:@"Content-Type"];
    
    //设置请求头, 授权码
    //[manager.requestSerializer setValue:@"YgAhCMxEehT4N/DmhKkA/M0npN3KO0X8PMrNl17+hogw944GDGpzvypteMemdWb9nlzz7mk1jBa/0fpOtxeZUA==" forHTTPHeaderField:@"Authentication"];
    
    //上传服务器接口
    NSString *url = [NSString stringWithFormat:@"http://xxxxx.xxxx.xxx.xx.x"];
    
    //开始上传
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSError *error;
        BOOL success = [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:fileName fileName:fileName mimeType:mimeType error:&error];
        
        if (!success) {
            
            NSLog(@"appendPartWithFileURL error: %@", error);
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"上传进度: %f", uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"成功返回: %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"上传失败: %@", error);
        
    }];
}



#pragma mark - 创建AFN管理者
+(AFHTTPSessionManager *)getAFManager{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //请求序列化
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//设置请求数据为json
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval = 10;//超时时间
    //请求头信息设置
    /**
    //本地账户的token 和 账户ID 每次请求都放到请求头中，后台做判断，有异常就返回了，强制用户退出登录
    [manager.requestSerializer setValue:[HSAccountManager sharedAccountManager].token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[HSAccountManager sharedAccountManager].userId forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue:[HSAppInfo appBundleID] forHTTPHeaderField:@"packageName"];
     */
    
    //响应序列化
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
    //响应数据格式设置
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"application/json;charset=UTF-8",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    return manager;
}

+(NSString *)strUTF8Encoding:(NSString *)str{
    //编码
    NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];

    return [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    //解码
    //[str stringByRemovingPercentEncoding];
}

///添加公共参数
+ (NSDictionary *)addPublicParameterWithDic:(NSDictionary *)dicParams{
    
    NSMutableDictionary *dicMutable = [dicParams mutableCopy];
    
    NSInteger timeStamp = [APPFunctionMethod date_getNowTimeStampWithPrecision:1000];
    NSString *publicStr = [NSString stringWithFormat:@"platform=IOS&version=1.0&timeSpan=%ld&token=%@",timeStamp,APPManagerUserInfo.token];
    NSString *sign = [GFEncryption md5LowercaseString_32:publicStr];
    
    //添加公共参数sign
    [dicMutable gf_setObject:sign withKey:@"sign"];
    
    [dicMutable gf_setObject:@"IOS" withKey:@"platform"];
    [dicMutable gf_setObject:@"1.0" withKey:@"version"];
    [dicMutable gf_setObject:[NSNumber numberWithInteger:timeStamp] withKey:@"timeSpan"];
    
    [dicMutable gf_setObject:APPManagerUserInfo.token withKey:@"token"];
    
    return [dicMutable copy];
}



#pragma mark - ************************** 网络监测 **************************
#pragma makr - 开始监听网络连接
+ (void)startMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status){
                
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                [APPHttpTool sharedNetworking].networkStats=StatusUnknown;
                
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络");
                [APPHttpTool sharedNetworking].networkStats=StatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                [APPHttpTool sharedNetworking].networkStats=StatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                
                [APPHttpTool sharedNetworking].networkStats=StatusReachableViaWiFi;
                NSLog(@"WIFI网络");
                break;
        }
        //网络发生变化在此进行通知
        [APPNotificationCenter postNotificationName:_kGlobal_NetworkingReachabilityChangeNotification object:nil];
    }];
    
    [mgr startMonitoring];
}

/**
 *  关闭网络监测
 */
+ (void)stopMonitoring{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}



@end
