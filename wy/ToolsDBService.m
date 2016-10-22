//
//  ToolsDBService.m
//  wy
//
//  Created by 王益禄 on 2016/10/22.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "ToolsDBService.h"

static ToolsDBService *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation ToolsDBService {
    NSString *databasePath;
}

+ (ToolsDBService *)getSharedInstance {
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
                    [docsDir stringByAppendingPathComponent: @"wy-tools.db"]];
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"数据库存储路径：%@", docsDir);
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSLog(@"数据库打开成功。。。。。。");
        [sharedInstance createToolsTable];
    }
    else {
        NSLog(@"数据库打开失败。。。。。。");
    }
}

- (void) createToolsTable {
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists Tools (Code text primary key, Name text, Number REAL)";
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            NSLog(@"创建物资表失败。。。。。%s", errMsg);
        }
    }
    sqlite3_close(database);
}

- (BOOL) saveTool:(ToolsEntity *)tool {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into Tools (Code, Name, Number) values (\"%@\",\"%@\",\"%f\")",tool.Code, tool.Name, tool.Number];
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

- (ToolsEntity *) findToolByCode:(NSString*)Code {
    ToolsEntity *tool;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Name, Number from Tools where Code=\"%@\"",Code];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                float Number = sqlite3_column_double(statement, 2);
                tool = [[ToolsEntity alloc] initWithDictionary:@{@"Code":Code, @"Name":Name, @"Number":[NSString stringWithFormat:@"%f", Number]}];
            }
            else{
                NSLog(@"没有找到code为%@的工具......", Code);
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return tool;
}

- (NSArray *) findAllTools {
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = @"select Code, Name, Number from Tools";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(stmt) == SQLITE_ROW) { //多行数据
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                float Number = sqlite3_column_double(statement, 2);
                ToolsEntity *tool = [[ToolsEntity alloc] initWithDictionary:@{@"Code":Code, @"Name":Name, @"Number":[NSString stringWithFormat:@"%f", Number]}];
                [resultArr addObject:tool];
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return resultArr;
}

@end
