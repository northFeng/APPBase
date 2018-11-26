//
//  APPUserInfoModel.h
//  GFAPP
//  用户信息Model
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPUserInfoModel : NSObject

///用户登录token
@property (nonatomic,copy) NSString *token;

///员工id
@property (nonatomic,copy) NSString *employeeId;

///员工手机号
@property (nonatomic,copy) NSString *employeeMobile;

///商铺id
@property (nonatomic,copy) NSString *shopId;

///商圈id
@property (nonatomic,copy) NSString *tradingAreaId;

///商铺名
@property (nonatomic,copy) NSString *shopName;

///商铺联系人
@property (nonatomic,copy) NSString *contacts;

///商铺联系人手机号
@property (nonatomic,copy) NSString *contactsMobile;

///商铺地址
@property (nonatomic,copy) NSString *shopAddress;

///商铺纬度
@property (nonatomic,copy) NSString *latitude;

///商铺经度
@property (nonatomic,copy) NSString *longitude;

///商铺开放时间
@property (nonatomic,copy) NSString *businessHours;

///商铺图标
@property (nonatomic,copy) NSString *shopIcon;

///商铺类型
@property (nonatomic,copy) NSString *shopType;

///商铺等级
@property (nonatomic,copy) NSString *shopLevel;

///账户金额
@property (nonatomic,copy) NSString *balance;

///优惠券
@property (nonatomic,copy) NSString *couponNum;

///城市名字
@property (nonatomic,copy,nullable) NSString *cityName;

///城市ID
@property (nonatomic,copy,nullable) NSString *cityId;


//**************************************
///已消费金额
//@property (nonatomic,copy) NSString *balanceUse;

///是否打开————>骑手来店取货时是否要电话通知
//@property (nonatomic,assign) BOOL isOpen;





@end


///用户默认保存的
@interface APPDefautlLocalInfo : NSObject

///地址主名称
@property (nonatomic,copy) NSString *localName;

///纬度
@property (nonatomic,copy) NSString *localLatitude;

///经度
@property (nonatomic,copy) NSString *localLongitude;

///详细地址
@property (nonatomic,copy) NSString *subTitle;

///名字
@property (nonatomic,copy) NSString *lxrName;

///电话
@property (nonatomic,copy) NSString *lxrPhoneNum;


@end

NS_ASSUME_NONNULL_END











