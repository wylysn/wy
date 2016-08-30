//
//  PersonDBService.m
//  wy
//
//  Created by wangyilu on 16/8/30.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PersonDBService.h"

static PersonDBService *sharedInstance = nil;
static sqlite3_stmt *statement = nil;

@implementation PersonDBService

+ (PersonDBService*)getSharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
        [sharedInstance createPersonTable];
    }
    return sharedInstance;
}

- (void) createPersonTable {
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists Person (id integer primary key, name text, department text, position text)";
    sqlite3 *database = [DBManager open];
    if (database) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            NSLog(@"创建人员表失败。。。。。%s", errMsg);
        }
    }
    [DBManager close];
}

- (BOOL) saveData:(PersonEntity *)person {
    BOOL isSuccess = FALSE;
    sqlite3 *database = [DBManager open];
    if (database) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into Person (id, name, department, position) values (\"%ld\",\"%@\", \"%@\", \"%@\")",(long)[person.id integerValue], person.name, person.department, person.position];
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

- (PersonEntity *) findById:(NSString*)id
{
    PersonEntity *person;
    sqlite3 *database = [DBManager open];
    if (database) {
        NSString *querySQL = [NSString stringWithFormat: @"select id, name, department, position from Person where id=\"%@\"",id];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(stmt) == SQLITE_ROW) { //多行数据
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *id = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *department = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *position = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                person = [[PersonEntity alloc] initWithDictionary:@{@"id":id, @"name":name, @"department":department, @"position":position}];
            }
            else{
                NSLog(@"没有找到id位%@的人员......", id);
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return person;
}

- (void)deleteData:(NSInteger)id {
    char *sql = "delete from Person where id = ?";
    sqlite3 *database = [DBManager open];
    if (database) {
        int result = sqlite3_prepare(database, sql, -1, &statement, NULL);
        
        if (result == SQLITE_OK) {
            NSLog(@"删除语句正确");
            // 绑定数据
            sqlite3_bind_int(statement, (int)(id), 58);
            // 判断时候执行成功
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"删除成功");
            } else {
                NSLog(@"删除是吧i");
            }
        } else {
            NSLog(@"删除语句错误");
        }
    }
}

@end
