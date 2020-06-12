//
//  SwiftClass.h
//  APPBase
//  OC调Swift类 引用的头文件
//  Created by 峰 on 2020/1/20.
//  Copyright © 2020 ishansong. All rights reserved.
//  1、系统会为工程创建一个“工程名-Swift.h”的文件(不会显示出来,可以引用)，此文件不可手动创建，必须使用系统创建的
//  2、在Build Setting中 每个Target下的build Settings的Defines Module设置为YES
//  3、Swift4.0中想要暴露给OC的 方法 和 属性  前面都需添加 @objc
//  swift版本兼容问题 swift3.0大更新 iOS10发布 2016年9月  swift4.0版本 在 iOS11 发布 2017年9月  ——> iOS版本最低必须10以上，最好是iOS11版本以上

#ifndef SwiftClass_h
#define SwiftClass_h

#import "APPBase-Swift.h"//Swift内不用引用头文件全部可以直接调用类

#endif /* SwiftClass_h */
