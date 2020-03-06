//
//  APPEnum.h
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/26.
//  Copyright © 2018 ishansong. All rights reserved.
//

#ifndef APPEnum_h
#define APPEnum_h

/**
 *  枚举
 */
typedef NS_ENUM(NSInteger,APPEnum) {
    /**
     *  未知
     */
    APPEnum_One = 0,
};

/**
 * 全局block回调
 * block会捕获外部对象指针进行拷贝，对象拥有的block在对象释放时，block会自动销毁，block里的对象也会销毁
 * 如果该对象没有销毁，该block拥有的对象要释放时！一定要释放block = nil !!!!否则block内拥有的对象不会释放！
 */
typedef void (^APPBackBlock)(BOOL result, id idObject);

///网络请求返回  code 100成功  99网络失败  101 服务器失败
typedef void (^APPNetBlock)(BOOL result, id idObject, NSInteger code);


/**
 *  登录类型
 */
typedef NS_ENUM(NSInteger,APPEnumloginType) {
    /**
     *  登录成功
     */
    APPEnumloginType_Sucess = 200,
    /**
     *  用户未登录
     */
    APPEnumloginType_NoLogin = 300,
    /**
     *  参数错误
     */
    APPEnumloginType_ParamError = 400,
    /**
     *  登录出错
     */
    APPEnumloginType_Error = 500,
};


/**
 *  订单状态
 */
typedef NS_ENUM(NSInteger,APPEnumOrderState) {
    /**
     *  所有
     */
    APPEnumOrderState_all = 0,
    /**
     *  待支付
     */
    APPEnumOrderState_waitePay = 10,
    /**
     *  派单中——>待派单(已支付)
     */
    APPEnumOrderState_sendOrder = 20,
    /**
     *  待取货（已支付）
     */
    APPEnumOrderState_waitePickGood = 30,
    /**
     *  闪送中
     */
    APPEnumOrderState_sending = 40,
    /**
     *  已完成
     */
    APPEnumOrderState_complete = 50,
    /**
     *  已取消
     */
    APPEnumOrderState_cancle = 60,
    /**
     *  进行中
     */
    APPEnumOrderState_ongoing = 100,
};


/**
 *  首页Cell类型
 */
typedef NS_ENUM(NSInteger,APPEnumHomeCellType) {
    /**
     *  发件地址-默认模式
     */
    APPEnumHomeCellType_Send_Default = 0,
    /**
     *  发件地址-填写模式
     */
    APPEnumHomeCellType_Send_Select = 1,
    /**
     *  收件地址-默认模式
     */
    APPEnumHomeCellType_Receipt_Default = 2,
    /**
     *  收件地址-填写模式
     */
    APPEnumHomeCellType_Receipt_Select = 3,
    /**
     *  提示继续填单模式
     */
    APPEnumHomeCellType_Continue = 4,
};

/**
 *  下单类型
 */
typedef NS_ENUM(NSInteger,APPEnumOrderType) {
    /**
     *  及时单
     */
    APPEnumOrderType_timely = 0,
    /**
     *  预约单
     */
    APPEnumOrderType_appointment = 1,
};


/**
 *  优惠券类型
 */
typedef NS_ENUM(NSInteger,APPEnumCouponType) {
    /**
     *  失效
     */
    APPEnumCouponType_overdue = 0,
    /**
     *  未用(可用)
     */
    APPEnumCouponType_canUse = 10,
    /**
     *  锁定
     */
    APPEnumCouponType_lock = 20,
    /**
     *  使用
     */
    APPEnumCouponType_useing = 30,
};


/**
 *  支付类型
 */
typedef NS_ENUM(NSInteger,APPEnumPayType) {
    /**
     *  支付宝
     */
    APPEnumPayType_zfb = 1,
    /**
     *  服务号微信
     */
    APPEnumPayType_wxpublic = 2,
    /**
     *  APP微信
     */
    APPEnumPayType_wxapp = 3,
    /**
     *  银联
     */
    APPEnumPayType_unionpay = 4,
    /**
     *  余额
     */
    APPEnumPayType_balance = 5,
};

#endif /* APPEnum_h */
