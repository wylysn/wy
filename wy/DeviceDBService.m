//
//  DeviceDBService.m
//  wy
//
//  Created by wangyilu on 16/8/30.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "DeviceDBService.h"

static DeviceDBService *sharedInstance = nil;
static sqlite3_stmt *statement = nil;

@implementation DeviceDBService

+ (DeviceDBService*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
        [sharedInstance createDeviceTable];
    }
    return sharedInstance;
}

- (BOOL) createDeviceTable {
    BOOL isSuccess = TRUE;
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists Device (id integer primary key autoincrement, code text, name text, position text)";
    sqlite3 *database = [DBManager open];
    if (database) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            isSuccess = FALSE;
            NSLog(@"创建人员表失败。。。。。%s", errMsg);
        }
    }
    [DBManager close];
    return isSuccess;
}

- (BOOL) saveDevice:(DeviceEntity *)device {
    BOOL isSuccess = FALSE;
    sqlite3 *database = [DBManager open];
    if (database) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into Device (code, name, position) values (\"%@\",\"%@\", \"%@\")", device.code, device.name, device.position];
        const char *insert_stmt = [insertSQL UTF8String];
        int result = sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (result == SQLITE_OK) { // 语法通过
            // 执行插入语句
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"插入成功。。。。。");
                isSuccess = TRUE;
            } else {
                NSLog(@"插入失败:%s", sqlite3_errmsg(database));
            }
        } else {
            NSLog(@"语法不通过 ");
        }
        sqlite3_finalize(statement);
    }
    return isSuccess;
}

- (DeviceEntity *)findDeviceById:(NSString *)id {
    DeviceEntity *device;
    sqlite3 *database = [DBManager open];
    if (database) {
        NSString *querySQL = [NSString stringWithFormat: @"select code, name, position from Device where id=\"%@\"",id];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(stmt) == SQLITE_ROW) { //多行数据
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *position = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                device = [[DeviceEntity alloc] initWithDictionary:@{@"code":code, @"name":name, @"position":position}];
            }
            else{
                NSLog(@"没有找到id位%@的人员......", id);
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return device;
}

- (NSArray *) findDevicesByName:(NSString*)name {
    NSMutableArray *deviceArr = [[NSMutableArray alloc] init];
    sqlite3 *database = [DBManager open];
    if (database) {
        NSString *querySQL = [NSString stringWithFormat: @"select code, name, position from Device where name '%%%@%%'",  [NSString stringWithCString:[name UTF8String] encoding:NSUnicodeStringEncoding]];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *position = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                DeviceEntity *device = [[DeviceEntity alloc] initWithDictionary:@{@"code":code, @"name":name, @"position":position}];
                [deviceArr addObject:device];
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return deviceArr;
}

- (NSArray *)findAll {
    NSMutableArray *deviceArr = [[NSMutableArray alloc] init];
    sqlite3 *database = [DBManager open];
    if (database) {
        NSString *querySQL = [NSString stringWithFormat: @"select code, name, position from Device"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *position = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                DeviceEntity *device = [[DeviceEntity alloc] initWithDictionary:@{@"code":code, @"name":name, @"position":position}];
                [deviceArr addObject:device];
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return deviceArr;
}

@end
