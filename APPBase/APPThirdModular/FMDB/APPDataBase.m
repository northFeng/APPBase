//
//  APPDataBase.m
//  APPBase
//
//  Created by 峰 on 2019/11/6.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPDataBase.h"

#import "APPFileManager.h"//文件管理

///数据库对象
static FMDatabase *_fmdb;

@interface APPDataBase ()


@end

@implementation APPDataBase


- (instancetype)init{
    
    if (self = [super init]) {
        
        [self createDataBase];//创建数据库
    }
    return self;
}


/**
 优点:

 对多线程的并发操作进行处理，所以是线程安全的；

 以OC的方式封装了SQLite的C语言API，使用起来更加的方便；

 FMDB是轻量级的框架，使用灵活。

 缺点:

 因为它是OC的语言封装的，只能在ios开发的时候使用，所以在实现跨平台操作的时候存在局限性。

 
 数据库使用步骤：创建数据库路径，获得数据库路径，打开数据库，然后对数据库进行增、删、改、查操作，最后关闭数据库。

 */


///创建数据库
- (void)createDataBase {
    
    NSString *dataPath = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject],@"DataBase"];
    
    [APPFileManager createFilePath:dataPath];
    
    NSString *fileName = [dataPath stringByAppendingPathComponent:@"app.db"];//设置数据库名称
    
    //创建数据库
    _fmdb = [FMDatabase databaseWithPath:fileName];//创建并获取数据库信息
    if ([_fmdb open]) {
        NSLog(@"数据库打开成功！");
        [self createDatabaseWithName:@"name" age:@"age"];
        [_fmdb close];
    }else{
        NSLog(@"数据库打开失败！");
    }
}

///创建表单
- (void)createDatabaseWithName:(NSString *)name age:(NSString *)age {
    
    BOOL executeUpdate = [_fmdb executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, %@ text NOT NULL, %@ integer NOT NULL);",name,age]];
    
    if (executeUpdate) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}

///表升级添加新字段
- (void)upgradeDatabaseTabelName:(NSString *)tabelName newKey:(NSString *)newkey {
    
    // 判断是否包含表字段
    if (![_fmdb columnExists:newkey inTableWithName:tabelName]){
              
        NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",tabelName,newkey];
        BOOL worked = [_fmdb executeUpdate:alertStr];
        
        if(worked){
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
    }

    [_fmdb close];
}


///插入数据
- (void)insertDataName:(NSString *)name age:(NSString *)age {
    [_fmdb open];
    
    BOOL results = [_fmdb executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?,?)",name,age];
    //    BOOL result = [fmdb executeUpdateWithFormat:@"insert into t_student (name,age, sex) values (%@,%i,%@)",name,age,sex];
    //3.参数是数组的使用方式
    //    BOOL result = [fmdb executeUpdate:@"INSERT INTO t_student(name,age,sex) VALUES  (?,?,?);" withArgumentsInArray:@[name,@(age),sex]];
    if (results) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
    [_fmdb close];
}


///删除数据
- (void)deleteDataWithId:(NSString *)name {
    
    [_fmdb open];
    BOOL deleate=[_fmdb executeUpdate:@"delete from t_student where name = ?",name];//按照id进行删除
    //BOOL deleate=[fmdb executeUpdateWithFormat:@"delete from t_student where name = %@",@"王子涵1"];//按照名字进行删除
    if (deleate) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
    [_fmdb close];
}


///修改数据
- (void)updateDataWithInfo:(NSString *)newName oldName:(NSString *)oldName {
    [_fmdb open];
    
    //修改学生的名字
    BOOL update=[_fmdb executeUpdate:@"update t_student set name = ? where name =?",newName,oldName];
    if (update) {
        NSLog(@"修改成功");
    } else {
        NSLog(@"修改失败");
    }
    [_fmdb close];
}


///查询
- (void)getData {
    [_fmdb open];
    
    //查询整个表
    FMResultSet *resultSet = [_fmdb executeQuery:@"select * from t_student"];
    //根据条件查询
    //FMResultSet * resultSet = [_fmdb executeQuery:@"select * from t_student where id < ?", @(4)];
    //遍历结果集合
    while ([resultSet next]) {
        int idNum = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *age = [resultSet stringForColumn:@"age"];
        NSLog(@"学号：%@ 姓名：%@ 年龄：%@",@(idNum),name,age);
    }
    [_fmdb close];
}

///分页查找
- (void)getDataPage:(NSInteger)page limit:(NSInteger)limit {
    
    NSInteger p = page * limit;
    
    [_fmdb open];
    
    //FMResultSet * resultSet = [_fmdb executeQuery:@"select * from t_student where id > ? order by id limit ?,?", @(5),@(p),@(limit)];
    //升序查找
    //FMResultSet * resultSet = [_fmdb executeQuery:@"select * from t_student order by id limit ?,?",@(p),@(limit)];
    
    //降序查找
    FMResultSet * resultSet = [_fmdb executeQuery:@"select * from t_student order by id desc limit ?,?",@(p),@(limit)];
    
    //遍历结果集合
    while ([resultSet next]) {
        int idNum = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet stringForColumn:@"name"];
        NSLog(@"学号：%@ 姓名：%@",@(idNum),name);
    }
    [_fmdb close];
}






@end
