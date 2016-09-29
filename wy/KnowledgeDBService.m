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

- (void)setSharedInstanceNull {
    sharedInstance = nil;
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
    NSString *sql_stmt =@"create table if not exists Knowledge (Code text primary key, Keyword text, Content text, Lyxm text, createPerson text, createTime text)";
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
        NSString *insertSQL = @"insert into Knowledge (Code, Keyword, Content, Lyxm, createPerson, createTime) values (?,?,?,?,?,?)";
        const char *insert_stmt = [insertSQL UTF8String];
        int result = sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (result == SQLITE_OK) { // 语法通过
            sqlite3_bind_text(statement, 1, [knowledge.Code UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [knowledge.Keyword UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [knowledge.Content UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [knowledge.Lyxm UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 4, [knowledge.createPerson UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 5, [knowledge.createTime UTF8String], -1, SQLITE_TRANSIENT);
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

- (KnowledgeEntity *)findKnowledgeByCode:(NSString *)Code {
    KnowledgeEntity *knowledge;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Keyword, Content, Lyxm, createPerson, createTime from Knowledge where Code=\"%@\"",Code];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(stmt) == SQLITE_ROW) { //多行数据
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Keyword = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *content = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *source = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
//                NSString *createPerson = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
//                NSString *createTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                knowledge = [[KnowledgeEntity alloc] initWithDictionary:@{@"Code":code, @"Keyword":Keyword, @"Content":content, @"Lyxm":source}];
            }
            else{
                NSLog(@"没有找到code位%@的知识......", Code);
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
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Keyword, Content, Lyxm, createPerson, createTime from Knowledge where Keyword like '%%%@%%' or Content like '%%%@%%'", [NSString stringWithCString:[keyword UTF8String] encoding:NSUTF8StringEncoding], [NSString stringWithCString:[keyword UTF8String] encoding:NSUTF8StringEncoding]];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Keyword = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *content = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *source = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                //                NSString *createPerson = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                //                NSString *createTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                KnowledgeEntity *knowledge = [[KnowledgeEntity alloc] initWithDictionary:@{@"Code":code, @"Keyword":Keyword, @"Content":content, @"Lyxm":source}];
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
