//
//  APPOssInterface.m
//  APPBase
//
//  Created by 峰 on 2020/1/4.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import "APPOssInterface.h"

//#import <AliyunOSSiOS/OSSService.h>

@implementation APPOssInterface
{
    ///OSS阿里云上传客户端对象（client的生命周期必须和应用的生命周期要保持一直。）
    
    /** 注销！
     OSSClient *_ossClient;//请保持OSSClient对象和app的生命周期一致。如果有多个endpoint的话，就创建多个client就可以。
     */
    
    NSDictionary *_dicOss;//信息
}

///获取OSS上传对象
+ (instancetype)shareInstance
{
    static APPOssInterface *ossInterface = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ossInterface = [[self alloc] init];
    });
    return ossInterface;
}


#pragma mark - OSS阿里云上传图片

///获取
- (void)getOSSClientWithBlock:(APPBackBlock)blockClient {
    
    //!_ossClient  ——> 鉴权模式 ！必须每次都请求（否则，使用的时候 报错，在OSS的SDK中的 时间戳 中 会失败！！好像是时间戳过期！）
    if (1) {
        //client不存在
        /**
        [[CBConfigurationData shareInstance] getDataConfigurationWithType:CBConfugurationType_oss blockResult:^(BOOL result, id idObject, NSInteger code) {
            if (result) {
                NSDictionary *dicOss = (NSDictionary *)idObject;
                self->_dicOss = dicOss;//捕获OSS
                
                [self initClientWithDicJson:dicOss];
                blockClient(YES,@0);
            }else{
                blockClient(NO,@0);
            }
        }];
         */
    }else{
        blockClient(YES,@0);
    }
}

///初始化client
- (void)initClientWithDicJson:(NSDictionary *)dicOss {
    
    
    
    //STS鉴权模式  鉴权模式最后每次都请求 token，因为token会失效
    /**
    OSSFederationToken *token = [OSSFederationToken new];
    token.tAccessKey = [dicOss objectForKey:@"accessKeyId"];
    token.tSecretKey = [dicOss objectForKey:@"accessKeySecret"];
    token.tToken = [dicOss objectForKey:@"securityToken"];
    token.expirationTimeInGMTFormat = [dicOss objectForKey:@"expiration"];
     */
    //    id<OSSCredentialProvider> credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
    //        return token;
    //    }];
        
    //自签名模式  自签名模式 不需要token，不需要每次都请求接口
    // 移动端建议使用STS方式初始化OSSClient。可以通过sample中STS使用说明了解更多(https://github.com/aliyun/aliyun-oss-ios-sdk/tree/master/DemoByOC)
    
    /** 注销！
     id <OSSCredentialProvider> credential = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
         // 您需要在这里依照OSS规定的签名算法，实现加签一串字符内容，并把得到的签名传拼接上AccessKeyId后返回
         // 一般实现是，将字符内容post到您的业务服务器，然后返回签名
         // 如果因为某种原因加签失败，描述error信息后，返回nil
         NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:[dicOss objectForKey:@"accessKeySecret"]];//这里是用SDK内的工具函数进行本地加签，建议您通过业务server实现远程加签
         if (signature != nil) {
             *error = nil;
         } else {
             *error = [NSError errorWithDomain:@"<your domain>" code:-1001 userInfo:@{}];
             return nil;
         }
         return [NSString stringWithFormat:@"OSS %@:%@", [dicOss objectForKey:@"accessKeyId"], signature];
     }];
     
     
     //if (!_ossClient) {
         //上传阿里云服务器   endpoint 就是 域名！ 文件地址的 域名！！
         NSString *endpoint = [dicOss objectForKey:@"endpoint"];//endpoint = "oss-cn-beijing.aliyuncs.com";  host = "http://w-y-audio.wdkid.net";
         _ossClient = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
     //}
     _ossClient.credentialProvider = credential;//更新这个属性
     */
}

#pragma mark - ************************* 上传OSS数据 *************************
///上传数据
- (void)uploadData:(NSData *)upData dataId:(NSString *)dataId blockResult:(APPBackBlock)blockResult{
    
    //是否有client
    [self getOSSClientWithBlock:^(BOOL result, id idObject) {
        if (result) {
            //上传
            [self uploadToOSSWithData:upData upId:dataId blockResult:blockResult];
        }else{
            blockResult(NO,@"上传失败");
        }
    }];
}

///上传OSS阿里云
- (void)uploadToOSSWithData:(NSData *)upData upId:(NSString *)upId blockResult:(APPBackBlock)blockResult {
    
    /** 注销！
     OSSPutObjectRequest *put = [[OSSPutObjectRequest alloc] init];
     
     //配置必填字段，其中bucketName为存储空间名称；objectKey等同于objectName，表示将文件上传到OSS时需要指定包含文件后缀在内的完整路径，例如abc/efg/123.jpg。
     put.bucketName = @"<bucketName>";
     put.bucketName = [_dicOss objectForKey:@"bucketName"];
     put.objectKey = upId;//"folder/subfolder/fileName"  fileName为文字名， / 前面 都是路径
     //put.contentType = @"application/octet-stream"; 默认类型  //音频类型 @"audio/mp3" 否则上传的链接为下载链接不能在线播放
     
     put.uploadingData = upData;// 直接上传NSData
     
     //开始上传
     OSSTask *putTask = [_ossClient putObject:put];
     
     [putTask continueWithBlock:^id(OSSTask *task) {
         dispatch_async(dispatch_get_main_queue(), ^{
             //回到主线程
             
             if (!task.error) {
                 NSLog(@"upload object success!");
                 ///获取数据OSS连接
                 [self getDataPublicUrlWithDataId:upId blockResult:^(BOOL result, id idObject) {
                     if (result) {
                         blockResult(YES,idObject);//返回链接
                     }else{
                         blockResult(NO,@0);
                     }
                 }];
             } else {
                 NSLog(@"upload object failed, error: %@" , task.error);
                 blockResult(NO,@0);
             }
         });
         return nil;
     }];
     */
}

#pragma mark - ************************* 获取OSS数据 *************************
///获取OSS数据
- (void)getDataFormOSSWithDataId:(NSString *)dataId blockResult:(APPBackBlock)blockResult{
    
    [self getOSSClientWithBlock:^(BOOL result, id idObject) {
        if (result) {
            //获取
            [self getDataWithDataKey:dataId blockResult:blockResult];
        }else{
            blockResult(NO,@"获取失败");
        }
    }];
}

///获取数据
- (void)getDataWithDataKey:(NSString *)dataKey blockResult:(APPBackBlock)blockResult{
    
    /** 注销！
     OSSGetObjectRequest * request = [OSSGetObjectRequest new];
     
     // 必填字段
     request.bucketName = [_dicOss objectForKey:@"bucketName"];
     request.objectKey = dataKey;
     */
    
    /**
     // 图片处理
     request.xOssProcess = @"image/resize,m_lfit,w_100,h_100";
     // 可选字段
     request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
     // 当前下载段长度、当前已经下载总长度、一共需要下载的总长度
     NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
     };
     // request.range = [[OSSRange alloc] initWithStart:0 withEnd:99]; // bytes=0-99，指定范围下载
     // request.downloadToFileURL = [NSURL fileURLWithPath:@"<filepath>"]; // 如果需要直接下载到文件，需要指明目标文件地址
     */
    
    /** 注销！
     OSSTask * getTask = [_ossClient getObject:request];
     
     [getTask continueWithBlock:^id(OSSTask *task) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (!task.error) {
                 NSLog(@"download object success!");
                 OSSGetObjectResult * getResult = task.result;
                 //NSLog(@"download result: %@", getResult.downloadedData);
                 
                 blockResult(YES,getResult.downloadedData);//在异步进行请求的，回到主线程
             }else{
                 NSLog(@"download object failed, error: %@" ,task.error);
                 blockResult(NO,@0);//获取失败
             }
         });
         return nil;
     }];
     */
    
    // [getTask waitUntilFinished];
    
    // [request cancel];
}


#pragma mark - ************************* 删除OSS数据 *************************
///删除OSS文件
- (void)deleteOSSDataWithDataId:(NSString *)dataId blockResult:(APPBackBlock)blockResult {
    
    /** 注销！
     [self getOSSClientWithBlock:^(BOOL result, id idObject) {
         if (result) {
             //删除
             [self deleteOSSFileWithDataId:dataId blockResult:blockResult];
         }else{
             blockResult(NO,@0);
         }
     }];
     */
}

///删除数据
- (void)deleteOSSFileWithDataId:(NSString *)dataId  blockResult:(APPBackBlock)blockResult {
    
    /** 注销！
     OSSDeleteObjectRequest * delete = [OSSDeleteObjectRequest new];
     delete.bucketName = _dicOss[@"bucketName"];
     delete.objectKey = dataId;

     OSSTask * deleteTask = [_ossClient deleteObject:delete];

     [deleteTask continueWithBlock:^id(OSSTask *task) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (!task.error) {
                 // ...
                 blockResult(YES,@0);
             }else{
                 NSLog(@"download object failed, error: %@" ,task.error);
                 blockResult(NO,@0);
             }
         });
         
         return nil;
     }];
     */

    // [deleteTask waitUntilFinished];
}

#pragma mark - ************************* 获取对象的URL *************************
///获取对象的URL
- (void)getDataPublicUrlWithDataId:(NSString *)dataId blockResult:(APPBackBlock)blockResult {
    
    if (dataId.length) {
        [self getOSSClientWithBlock:^(BOOL result, id idObject) {
            if (result) {
                [self getDataUrlWithDataId:dataId blockResult:blockResult];
            }else{
                blockResult(NO,@0);
            }
        }];
    }else{
        blockResult(NO,@0);
    }
}

///获取URL
- (void)getDataUrlWithDataId:(NSString *)dataId blockResult:(APPBackBlock)blockResult  {
    
    /** 注销！
     NSString *publicURL = @"";
     
     // sign public url
     OSSTask *task = [_ossClient presignPublicURLWithBucketName:_dicOss[@"bucketName"] withObjectKey:dataId];
     
     if (!task.error) {
         publicURL = task.result;
         blockResult(YES,publicURL);
     }else{
         NSLog(@"sign url error: %@", task.error);
         blockResult(NO,@0);
     }
     */
}


@end
