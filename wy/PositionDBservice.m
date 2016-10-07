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
    NSString *sql_stmt =@"create table if not exists Position (ID integer primary key, Code text, Name text, FullName text, Sort text, Status text, Description text, ParentID integer, Prj_Code text)";
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
        NSString *insertSQL = @"insert into Position (ID, Code, Name, FullName, Sort, Status, Description, ParentID, Prj_Code) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        const char *insert_stmt = [insertSQL UTF8String];
        int result = sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (result == SQLITE_OK) { // 语法通过
            sqlite3_bind_int(statement, 1, (int)position.ID);
            sqlite3_bind_text(statement, 2, [position.Code UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [position.Name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [position.FullName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [position.Sort UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6, [position.Status UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 7, [position.Description UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement, 8, (int)position.ParentID);
            sqlite3_bind_text(statement, 9, [position.Prj_Code UTF8String], -1, SQLITE_TRANSIENT);
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
        NSString *querySQL = @"select ID, Code, Name, FullName, Sort, Status, Description, ParentID, Prj_Code from Position";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int id = sqlite3_column_int(statement, 0);
                NSString *code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *fullName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *sort = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSString *status = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                NSString *description = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                int parentId = sqlite3_column_int(statement, 7);
                NSString *prj_Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 8)];
                PositionEntity *position = [[PositionEntity alloc] initWithDictionary:@{@"ID":[NSString stringWithFormat:@"%d", id], @"Code":code, @"Name":name, @"FullName":fullName, @"Sort":sort, @"Status":status, @"Description":description, @"ParentID":[NSString stringWithFormat:@"%d", parentId], @"Prj_Code":prj_Code}];
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

- (NSMutableArray *) findPositionsByParent:(PositionEntity *)parent {
    NSMutableArray *positionArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"select a.*,ifnull(b.count,0) as CHILDNUM from ( select * from Position a where a.ParentID = %ld) a left join (select b.ParentID, count(1) as count from (select * from Position a where a.ParentID = %ld) a, Position b where a.ID = b.ParentID group by b.ParentID) b on a.ID = b.ParentID", parent.ID, parent.ID];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int id = sqlite3_column_int(statement, 0);
                NSString *code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *fullName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *sort = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSString *status = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                NSString *description = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                int parentId = sqlite3_column_int(statement, 7);
                NSString *prj_Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 8)];
                int childnum = sqlite3_column_int(statement, 9);
                PositionEntity *position = [[PositionEntity alloc] initWithDictionary:@{@"ID":[NSString stringWithFormat:@"%d", id], @"Code":code, @"Name":name, @"FullName":fullName, @"Sort":sort, @"Status":status, @"Description":description, @"ParentID":[NSString stringWithFormat:@"%d", parentId], @"Prj_Code":prj_Code}];
                position.childNum = childnum;
                position.level = parent.level+1;
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
