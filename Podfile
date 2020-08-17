platform :ios, '10.0'
target 'APPBase' do
  #取消第三方框架中的黄色警告
  inhibit_all_warnings!
  use_frameworks!

# cd项目跟目录 ——> grep -r advertisingIdentifier .
#***************** 常用第三方框架**************
pod 'AFNetworking','~>3.2.1'

#这个框架会帮你集成 YYCache 和 MJExson
#pod 'DKNetworking','~>1.4.2'

#刷新控件
pod 'MJRefresh' , '~>3.1'

#轮播图
pod 'SDCycleScrollView','1.80'

#约束1
pod 'Masonry','~>1.1'
#约束2
pod 'SDAutoLayout','~>2.1'

#缓存框架
pod 'MMKV', '~>1.0.18'#腾讯缓存框架
pod 'YYCache','~>1.0.4'

#模型转换
pod 'YYModel','~>1.0.4'

#提示框
pod 'MBProgressHUD','~>1.1.0'

#加载图片
pod 'SDWebImage','~>4.0.0'

# 集成VC日志输出
pod 'Aspects', '~> 1.4.1'

#系统键盘控制
pod 'IQKeyboardManager'

#APP崩溃检测
pod 'AvoidCrash', '~> 2.5.2'

#FMDB数据库
pod 'FMDB','~>2.7.5'

#block编程
pod 'BlocksKit', '>= 2.2.5'

#吐字弹框菊花
pod 'MMMaterialDesignSpinner'
pod 'JGProgressHUD'


#***************** 第三方功能框架引入**************
#bug追踪
#pod 'Bugly','~>2.5.0'

#bug追踪 & 热更新 已集成JSPatch
#pod 'BuglyHotfix','~>2.1.0'

#RAC 数据绑定框架
pod 'ReactiveObjC', '~>3.1.1'

#Drak Model 
pod 'XYColorOC'

#检查内存泄漏
pod 'MLeaksFinder'

#音频播放器框架
pod 'FreeStreamer','~>4.0.0'

#视频播放器七牛
#线上不带虚拟器指令
#pod 'PLPlayerKit','3.4.3'
#七牛播放器虚拟机版本->上线前注销
pod "PLPlayerKit", :podspec => 'https://raw.githubusercontent.com/pili-engineering/PLPlayerKit/master/PLPlayerKit-Universal.podspec'


#微信SDK
pod 'WechatOpenSDK','~>1.8.6'

#阿里OSS
#pod 'AliyunOSSiOS','~> 2.10.7'

#友盟公共组件
#pod 'UMCCommon','~>2.1.1'
#友盟安全组件
#pod 'UMCSecurityPlugins','~>1.0.6'
#友盟统计组件
#pod 'UMCAnalytics','~>6.0.5'




#------------------ Swift集成 ------------------------
#布局类似Masonry
pod 'SnapKit', '~> 5.0.0'

#网络请求 ANF的swift版本
pod 'Alamofire','~>5.0'

#JSON模型转换 李明杰写的 https://github.com/kakaopensource/KakaJSON
pod 'KakaJSON', '~> 1.1.2'
#常用的
pod 'SwiftyJSON', '~>4.0'

#加载视图
pod 'NVActivityIndicatorView','~>4.8.0'

#图片加载
pod 'Kingfisher','5.13.1'






end

