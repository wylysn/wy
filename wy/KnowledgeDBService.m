//
//  KnowledgeDBService.m
//  wy
//
//  Created by wangyilu on 16/8/31.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "KnowledgeDBService.h"

static KnowledgeDBService *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation KnowledgeDBService {
    NSString *databasePath;
}

+ (KnowledgeDBService *)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

- (void)createDB {
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                              [docsDir stringByAppendingPathComponent: @"wy-knowledge.db"]];
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"数据库存储路径：%@", docsDir);
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSLog(@"数据库打开成功。。。。。。");
        [sharedInstance createDeviceTable];
    }
    else {
        NSLog(@"数据库打开失败。。。。。。");
    }
}

- (BOOL) createDeviceTable {
    BOOL isSuccess = TRUE;
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists Knowledge (id integer primary key, content text, source text, createPerson text, createTime text)";
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            isSuccess = FALSE;
            NSLog(@"创建人员表失败。。。。。%s", errMsg);
        }
    }
    sqlite3_close(database);
    return isSuccess;
}

- (BOOL) saveKnowledge:(KnowledgeEntity *)knowledge {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into Knowledge (id, content, source, createPerson, createTime) values (\"%d\",\"%@\", \"%@\",\"%@\", \"%@\")", knowledge.id, knowledge.content, knowledge.source, knowledge.createPerson, knowledge.createTime];
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

- (KnowledgeEntity *)findKnowledgeById:(int)id {
    KnowledgeEntity *knowledge;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select id, content, source, createPerson, createTime from Knowledge where id=\"%d\"",id];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(stmt) == SQLITE_ROW) { //多行数据
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                int id = sqlite3_column_int(statement, 0);
                NSString *content = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *source = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *createPerson = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *createTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                knowledge = [[KnowledgeEntity alloc] initWithDictionary:@{@"id":[NSString stringWithFormat:@"%d", id], @"content":content, @"source":source, @"createPerson":createPerson, @"createTime":createTime}];
            }
            else{
                NSLog(@"没有找到id位%d的知识......", id);
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return knowledge;
}

- (NSArray *) findKnowledgeByKeyword:(NSString*)keyword {
    NSMutableArray *knowledgeArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select id, content, source, createPerson, createTime from Knowledge where content like '%%%@%%'",  [NSString stringWithCString:[keyword UTF8String] encoding:NSUTF8StringEncoding]];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int id = sqlite3_column_int(statement, 0);
                NSString *content = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *source = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *createPerson = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *createTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                KnowledgeEntity *knowledge = [[KnowledgeEntity alloc] initWithDictionary:@{@"id":[NSString stringWithFormat:@"%d", id], @"content":content, @"source":source, @"createPerson":createPerson, @"createTime":createTime}];
                [knowledgeArr addObject:knowledge];
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    } else {
        NSLog(@"查找失败:%s", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    return knowledgeArr;
}

@end
