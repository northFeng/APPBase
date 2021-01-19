//
//  UIDevice+Info.m
//  APPBase
//
//  Created by v_gaoyafeng on 2021/1/19.
//  Copyright © 2021 ishansong. All rights reserved.
//

#import "UIDevice+Info.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <mach/mach_time.h>
#import <sys/utsname.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <LocalAuthentication/LocalAuthentication.h>
#include <net/if.h>
#include <sys/sysctl.h>
#import <mach/mach.h>
#import <sys/time.h>

#if defined(__IPHONE_14_0)
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#endif
#import <AdSupport/AdSupport.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation UIDevice (Info)

//////////////////////////////////////////////////////////////////////////////////
+ (BOOL) isPad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (BOOL) isPhone {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}


//320*480
+ (BOOL)iPhoneScreen3_5Inch {
    return ([UIDevice isPhone] &&
            [[UIScreen mainScreen] bounds].size.width == 320.0f &&
            [[UIScreen mainScreen] bounds].size.height == 480.0f);
}
//320*568
+ (BOOL)iPhoneScreen4_0Inch {
    return ([UIDevice isPhone] &&
            [[UIScreen mainScreen] bounds].size.width == 320.0f &&
            [[UIScreen mainScreen] bounds].size.height == 568.0f);
}
//375*667
+ (BOOL)iPhoneScreen4_7Inch {
    return ([UIDevice isPhone] &&
            [[UIScreen mainScreen] bounds].size.width == 375.0f &&
            [[UIScreen mainScreen] bounds].size.height == 667.0f);
}
//414*736
+ (BOOL)iPhoneScreen5_5Inch {
    return ([UIDevice isPhone] &&
            [[UIScreen mainScreen] bounds].size.width == 414.0f &&
            [[UIScreen mainScreen] bounds].size.height == 736.0f);
}
//375*812
+ (BOOL)iPhoneScreen5_8Inch {
    return ([UIDevice isPhone] &&
            [[UIScreen mainScreen] bounds].size.width == 375.0f &&
            [[UIScreen mainScreen] bounds].size.height == 812.0f);
}
//414*896 2x
+ (BOOL)iPhoneScreen6_1Inch{
    return ([UIDevice isPhone] &&
            [[UIScreen mainScreen] bounds].size.width == 414.0f &&
            [[UIScreen mainScreen] bounds].size.height == 896.0f &&
            [UIScreen mainScreen].scale == 2);
}
//414*896 3x
+ (BOOL)iPhoneScreen6_5Inch{
    return ([UIDevice isPhone] &&
            [[UIScreen mainScreen] bounds].size.width == 414.0f &&
            [[UIScreen mainScreen] bounds].size.height == 896.0f &&
            [UIScreen mainScreen].scale == 3);
}


//////////////////////////////////////////////////////////////////////////////////
+ (CGSize)screenSize {
    return [UIScreen mainScreen].bounds.size;
}

+ (CGFloat)screenScale {
    return [UIScreen mainScreen].scale;
}

+ (NSString *)screenResolutionString {
    CGSize size = [UIDevice screenSize];
    CGFloat scale = [UIDevice screenScale];
    return [NSString stringWithFormat:@"%.0fx%.0f", size.width * scale, size.height * scale];
}

+ (NSString *)apnSupplier
{
    CTCarrier *carrier = [UIDevice getCurrentCarrier];
    NSString *carrierName = carrier.carrierName;
    return carrierName.length > 0 ? carrierName : @"";
}




/// 网络类型 3G | 4G 等等
+ (NSString *)getCurrentRadioAccessTechnology {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentRadioAccessTechnology = nil;
    if (@available(iOS 13.0, *)) {
        if (info && [info respondsToSelector:@selector(serviceCurrentRadioAccessTechnology)]) {
            NSDictionary *dic = [info serviceCurrentRadioAccessTechnology];
            for (NSString* key in dic) {
                if ([info respondsToSelector:@selector(dataServiceIdentifier)]) {
                    NSString *serviceId = [info dataServiceIdentifier];
                    if([key isEqualToString:serviceId]) {
                        currentRadioAccessTechnology = dic[key];
                        break;
                    }
                }
            }
        }
    }
    if (nil == currentRadioAccessTechnology) {
        currentRadioAccessTechnology = info.currentRadioAccessTechnology;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:info];
    return currentRadioAccessTechnology;
}

+ (CTCarrier*)getCurrentCarrier {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *result = nil;
    if (@available(iOS 13.0, *)) {
        if ([info respondsToSelector:@selector(serviceSubscriberCellularProviders)]) {
            NSDictionary *dic = [info serviceSubscriberCellularProviders];
            for (NSString* key in dic) {
                CTCarrier *carrier = dic[key];
                if ([info respondsToSelector:@selector(dataServiceIdentifier)] && [carrier isKindOfClass:[CTCarrier class]]) {
                    NSString *serviceId = [info dataServiceIdentifier];
                    if([key isEqualToString:serviceId]) {
                        result = carrier;
                        break;
                    }
                }
            }
        }
    }
    if(nil == result) {
        result = [info subscriberCellularProvider];
    }
    /// removeObserver：根据查询资料 由于系统的问题被释放的CTTelephonyNetworkInfo有可能还会被发通知造成crash
    [[NSNotificationCenter defaultCenter] removeObserver:info];
    return result;
}





static NSString *deviceMachineName;
//获取设备编号
+ (NSString *)deviceMachineName {
    if (deviceMachineName) {
        return deviceMachineName;
    }
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if (deviceString == nil
        || ![deviceString isKindOfClass:[NSString class]]
        || [deviceString length] == 0){
#if TARGET_OS_IPHONE
        deviceString = @"ios_device";
#else
        deviceString = @"mac_device";
#endif
    }
    deviceMachineName = deviceString;
    return deviceMachineName;
}


static NSUInteger MBMember;
//获取设备内存 MB
+ (NSUInteger)MBMember{
    if (MBMember >0) {
        return MBMember;
    }
    double currentDeviceMemory= [NSProcessInfo processInfo].physicalMemory/1024/1024.f;
    MBMember = (NSUInteger)currentDeviceMemory;
    return MBMember;
}

static NSString *osVersion;
//操作系统版本
+ (NSString *)osVersion{
    if (osVersion) {
        return osVersion;
    }
    
    NSMutableString *sysVersion = [NSMutableString stringWithString:[[UIDevice currentDevice] systemVersion]];
    
    NSMutableString *oSysVersion = [NSMutableString stringWithString:sysVersion];
    [oSysVersion replaceOccurrencesOfString:@"." withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [oSysVersion length])];
    
    NSInteger osMargin = 2 - (sysVersion.length - oSysVersion.length);
    while (osMargin > 0) {
        [sysVersion appendString:@".0" ];
        osMargin --;
    }
    
    osVersion = sysVersion;
    return osVersion;
}

static UIDeviceMemoryLevel staticMemoryLevel = 0;
//获取设备内存级别 -- 用于判断设备性能
+ (UIDeviceMemoryLevel)memoryLever;
{
    if (staticMemoryLevel > 0) {
        return staticMemoryLevel;
    }
    
    if ([UIDevice MBMember] < 400) {
        staticMemoryLevel = UIDeviceMemoryLevel_Low;
    }else if ([UIDevice MBMember] < 900){
        staticMemoryLevel = UIDeviceMemoryLevel_Middle;
    }else{
        staticMemoryLevel = UIDeviceMemoryLevel_High;
    }
    return staticMemoryLevel;
}

// 设备是否越狱
+ (BOOL)isJailbroken {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath])
    {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath])
    {
        jailbroken = YES;
    }
    
#if TARGET_IS_IPHONE
    struct stat s;
    if (lstat("/Applications", &s) != 0) {
        if (s.st_mode & S_IFLNK) {
            //设备被感染
            jailbroken = YES;
        }
    }
#endif
    
    return jailbroken;
}

//获取IP地址
+ (NSString *)iPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [UIDevice getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            BOOL iFFUP = interface->ifa_flags & IFF_UP;
            if(!iFFUP /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

+ (NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
//    zyb--!类型需要新增
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform?:@"unknown";
    
}


+ (BOOL)supportBiometryWithPolicy:(DevicePolicyType)policy
                            error:(NSError * __autoreleasing *)error {
    
    LAContext *context= [[LAContext alloc] init];
    context.localizedFallbackTitle = @"";
    LAPolicy m_policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    if (policy == DevicePolicyType_Authentication) {
        m_policy = LAPolicyDeviceOwnerAuthentication;
    }
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:error]) {
        return YES;
    }
    return NO;
}

+ (DeviceBiometryType)supportedBiometryType {
    if (@available(iOS 11.0, *)) {
        LAContext *context = [[LAContext alloc] init];
        [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
        if ([context respondsToSelector:@selector(biometryType)]){
            switch (context.biometryType) {
                case LABiometryNone:
                    return DeviceBiometryType_None;
                case LABiometryTypeTouchID:
                    return DeviceBiometryType_TouchID;
                case LABiometryTypeFaceID:
                    return DeviceBiometryType_FaceID;
            }
        } else {
            return DeviceBiometryType_Unknown;
        }
    }
    return DeviceBiometryType_Unknown;
}

+ (LAError)compatibleBiometryErrorType:(LAError)error {
    if (@available(iOS 11.0, *)) {
        LAError bioError = error;
        switch (error) {
            case LAErrorTouchIDNotEnrolled:
                bioError = LAErrorBiometryNotEnrolled;
                break;
            case LAErrorTouchIDNotAvailable:
                bioError = LAErrorBiometryNotAvailable;
                break;
            case LAErrorTouchIDLockout:
                bioError = LAErrorBiometryLockout;
                break;
            default:
                bioError = error;
        }
        return bioError;
    } else {
        return error;
    }
}


+ (BOOL)isSIMInstalled {
    CTCarrier *carrier = [UIDevice getCurrentCarrier];
    if (!carrier.isoCountryCode && !carrier.carrierName) {
        NSLog(@"No sim present Or No cellular coverage or phone is on airplane mode.");
        return NO;
    }
    return YES;
}

+ (NSUInteger)sysCores {
    unsigned int ncpu;
    size_t len = sizeof(ncpu);
    sysctlbyname("hw.ncpu", &ncpu, &len, NULL, 0);
    return ncpu;
}

+ (NSUInteger)appCpuUsage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

+ (NSUInteger)sysCpuUsage {
    kern_return_t kr;
    mach_msg_type_number_t count;
    static host_cpu_load_info_data_t previous_info = {0, 0, 0, 0};
    host_cpu_load_info_data_t info;
    
    count = HOST_CPU_LOAD_INFO_COUNT;
    
    kr = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)&info, &count);
    if (kr != KERN_SUCCESS) {
        return 0;
    }
    
    natural_t user   = info.cpu_ticks[CPU_STATE_USER] - previous_info.cpu_ticks[CPU_STATE_USER];
    natural_t nice   = info.cpu_ticks[CPU_STATE_NICE] - previous_info.cpu_ticks[CPU_STATE_NICE];
    natural_t system = info.cpu_ticks[CPU_STATE_SYSTEM] - previous_info.cpu_ticks[CPU_STATE_SYSTEM];
    natural_t idle   = info.cpu_ticks[CPU_STATE_IDLE] - previous_info.cpu_ticks[CPU_STATE_IDLE];
    natural_t total  = user + nice + system + idle;
    previous_info    = info;
    
    natural_t cpu_processor_count = 0;
    natural_t cpu_processor_info_count = 0;
    processor_info_array_t cpu_processor_infos = NULL;
    host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &cpu_processor_count, &cpu_processor_infos, &cpu_processor_info_count);
    
    return (user + nice + system) * 100.0 * cpu_processor_count / total;
}

+ (NSUInteger)sysTotalMemoryInMB {
    return [NSProcessInfo processInfo].physicalMemory/1024.0/1024.0;
}

+ (NSUInteger)appMemoryUsageInMB {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if (kernelReturn == KERN_SUCCESS) {
        return vmInfo.phys_footprint/1024.0/1024.0;
    }
    return 0;
}

+ (NSUInteger)sysMemoryUsageInMB {
    vm_statistics64_data_t vmstat;
    natural_t size = HOST_VM_INFO64_COUNT;
    kern_return_t kernelReturn = host_statistics64(mach_host_self(), HOST_VM_INFO64, (host_info64_t)&vmstat, &size);
    if (kernelReturn == KERN_SUCCESS) {
        CGFloat nbytesPerMB = 1024.0 * 1024.0;
        //double free = vmstat.free_count * PAGE_SIZE / nbytesPerMB;
        double wired = vmstat.wire_count * PAGE_SIZE / nbytesPerMB;
        double active = vmstat.active_count * PAGE_SIZE / nbytesPerMB;
        //double inactive = vmstat.inactive_count * PAGE_SIZE / nbytesPerMB;
        double compressed = vmstat.compressor_page_count * PAGE_SIZE / nbytesPerMB;
        return wired + active + compressed;
    }
    return 0;
}

static NSString *idfa = @"";
+ (NSString *)deviceIDFA {
    // 尝试获取一次
    if (idfa.length <= 0) {
        idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    }
//    if (idfa.length <= 0) {
//#ifdef __IPHONE_14_0
//        if (@available(iOS 14.0, *)) {
//            // iOS14及以上版本需要先请求权限
//            ATTrackingManagerAuthorizationStatus status = ATTrackingManager.trackingAuthorizationStatus;
//            //用户未做选择
//            if (status == ATTrackingManagerAuthorizationStatusNotDetermined) {
//                dispatch_semaphore_t sem = dispatch_semaphore_create(0);
//                [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
//                    //用户允许
//                    if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
//                        idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
//                    }
//                    dispatch_semaphore_signal(sem);
//                }];
//                dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//            } else if(status == ATTrackingManagerAuthorizationStatusAuthorized){
//                idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
//            }
//        }
//#else
//        //ios14以下的直接获取
//        if ([ASIdentifierManager sharedManager].advertisingTrackingEnabled) {
//            idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
//        }
//#endif
//    }
    return idfa ? idfa : @"";
}

@end
