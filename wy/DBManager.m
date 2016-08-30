//
//  DBManager.m
//  wy
//
//  Created by wangyilu on 16/8/30.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

// 创建数据库指针
static sqlite3 *db = nil;

// 打开数据库
+ (sqlite3 *)open {
    // 此方法的主要作用是打开数据库
    // 返回值是一个数据库指针
    // 因为这个数据库在很多的SQLite API（函数）中都会用到，我们声明一个类方法来获取，更加方便
    
    // 懒加载
    if (db != nil) {
        return db;
    }
    
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: DBNAME]];
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"数据库存储路径：%@", docsDir);
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSLog(@"数据库打开成功。。。。。。");
    }
    else {
        NSLog(@"数据库打开失败。。。。。。");
    }
    
    return db;
}

+ (void)close {
    
    // 关闭数据库
    sqlite3_close(db);
    
    // 将数据库的指针置空
    db = nil;
    NSLog(@"数据库关闭。。。。。。");
}

@end
