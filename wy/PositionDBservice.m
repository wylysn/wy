//
//  PositionDBservice.m
//  wy
//
//  Created by wangyilu on 16/9/1.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PositionDBservice.h"

static PositionDBservice *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation PositionDBservice {
    NSString *databasePath;
}

+ (PositionDBservice *)getSharedInstance{
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
                    [docsDir stringByAppendingPathComponent: @"wy-position.db"]];
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"数据库存储位置：%@", databasePath);
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
    NSString *sql_stmt =@"create table if not exists Position (id integer primary key, code text, name text, fullName text, sort integer, status integer, description text, parentId integer, prj_Code text)";
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            isSuccess = FALSE;
            NSLog(@"创建位置表失败。。。。。%s", errMsg);
        }
    }
    sqlite3_close(database);
    return isSuccess;
}

- (BOOL) savePosition:(PositionEntity *)position {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into Position (id, code, name, fullName, sort, status, description, parentId, prj_Code) values (\"%d\",\"%@\", \"%@\",\"%@\", \"%ld@\",\"%ld\",\"%@\",\"%d\",\"%@\")", position.id, position.Code, position.Name, position.FullName, position.Sort, (long)position.Status, position.Description, position.ParentID, position.Prj_Code];
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

- (NSArray *) findAllPositions {
    NSMutableArray *positionArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = @"select id, code, name, fullName, sort, status, description, parentId, prj_Code from Position";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int id = sqlite3_column_int(statement, 0);
                NSString *code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *fullName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                int sort = sqlite3_column_int(statement, 4);
                int status = sqlite3_column_int(statement, 5);
                NSString *description = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                int parentId = sqlite3_column_int(statement, 7);
                NSString *prj_Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 8)];
                PositionEntity *position = [[PositionEntity alloc] initWithDictionary:@{@"id":[NSString stringWithFormat:@"%d", id], @"Code":code, @"Name":name, @"FullName":fullName, @"Sort":[NSString stringWithFormat:@"%d", sort], @"Status":[NSString stringWithFormat:@"%d", status], @"Description":description, @"ParentId":[NSString stringWithFormat:@"%d", parentId], @"Prj_Code":prj_Code}];
                [positionArr addObject:position];
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    } else {
        NSLog(@"查找失败:%s", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    return positionArr;
}

- (NSArray *) findPositionsByParentId:(int) parentId {
    NSMutableArray *positionArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"select a.*,ifnull(b.count,0) as CHILDNUM from ( select * from Position a where a.parentId = %d) a left join (select b.parentId, count(1) as count from (select * from Position a where a.parentId = %d) a, Position b where a.id = b.parentId group by b.parentId) b on a.id = b.parentId", parentId, parentId];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int id = sqlite3_column_int(statement, 0);
                NSString *code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *fullName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                int sort = sqlite3_column_int(statement, 4);
                int status = sqlite3_column_int(statement, 5);
                NSString *description = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                int parentId = sqlite3_column_int(statement, 7);
                int childnum = sqlite3_column_int(statement, 8);
                NSString *prj_Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 8)];
                PositionEntity *position = [[PositionEntity alloc] initWithDictionary:@{@"id":[NSString stringWithFormat:@"%d", id], @"Code":code, @"Name":name, @"FullName":fullName, @"Sort":[NSString stringWithFormat:@"%d", sort], @"Status":[NSString stringWithFormat:@"%d", status], @"Description":description, @"ParentId":[NSString stringWithFormat:@"%d", parentId], @"Prj_Code":prj_Code}];
                position.hasChild = childnum>0?YES:NO;
                [positionArr addObject:position];
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    } else {
        NSLog(@"查找失败:%s", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    return positionArr;
}

@end
