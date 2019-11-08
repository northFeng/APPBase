//
//  APPDataBase.h
//  APPBase
//  APP内数据库
//  Created by 峰 on 2019/11/6.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPDataBase : NSObject

///表单名字
@property (nonatomic,copy) NSString *tableName;


///创建数据库
- (void)createDataBase;

///创建表单
- (void)createDatabaseWithName:(NSString *)name age:(NSString *)age;


///插入数据
- (void)insertDataName:(NSString *)name age:(NSString *)age;


///删除数据
- (void)deleteDataWithId:(NSString *)name;


///修改数据
- (void)updateDataWithInfo:(NSString *)newName oldName:(NSString *)oldName;


///查询
- (void)getData;

///分页查找
- (void)getDataPage:(NSInteger)page limit:(NSInteger)limit;



@end

NS_ASSUME_NONNULL_END
