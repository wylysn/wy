//
//  InspectionModelDBService.m
//  wy
//
//  Created by wangyilu on 16/9/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "InspectionModelDBService.h"
#import <sqlite3.h>

static InspectionModelDBService *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation InspectionModelDBService {
    NSString *databasePath;
}

+ (InspectionModelDBService *)getSharedInstance{
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
                    [docsDir stringByAppendingPathComponent: @"wy-inspection.db"]];
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"数据库存储路径：%@", docsDir);
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSLog(@"数据库打开成功。。。。。。");
        [sharedInstance createInspectionTable];
        [sharedInstance createInspectionChildTable];
    }
    else {
        NSLog(@"数据库打开失败。。。。。。");
    }
}

- (BOOL) createInspectionTable {
    BOOL isSuccess = TRUE;
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists Inspection (Code text primary key, Name text, CompayCode text, Memo text)";
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            isSuccess = FALSE;
            NSLog(@"创建巡检模板表失败。。。。。%s", errMsg);
        }
    }
    sqlite3_close(database);
    return isSuccess;
}

- (BOOL) createInspectionChildTable {
    BOOL isSuccess = TRUE;
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists InspectionChild (ParentCode text, ItemName text, ItemType integer, InputMax text, InputMin text, ItemValues text, UnitName text)";
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            isSuccess = FALSE;
            NSLog(@"创建巡检模板子表失败。。。。。%s", errMsg);
        }
    }
    sqlite3_close(database);
    return isSuccess;
}


- (BOOL) saveInspectionModel:(InspectionModelEntity *)inspection {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into Inspection (Code, Name, CompayCode, Memo) values (\"%@\",\"%@\", \"%@\", \"%@\")", inspection.Code, inspection.Name, inspection.CompayCode, inspection.Memo];
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

- (BOOL) saveInspectionChildModel:(InspectionChildModelEntity *)inspection {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into InspectionChild (ParentCode, ItemName, ItemType, InputMax, InputMin, ItemValues, UnitName) values (\"%@\", \"%@\", \"%ld\", \"%@\", \"%@\", \"%@\", \"%@\")", inspection.ParentCode, inspection.ItemName, inspection.ItemType, inspection.InputMax, inspection.InputMin, inspection.ItemValues, inspection.UnitName];
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

- (InspectionModelEntity *) findInspectionModelByCode:(NSString*)Code {
    InspectionModelEntity *inspection;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Name, CompayCode, Memo from Inspection where Code=\"%@\"",Code];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(stmt) == SQLITE_ROW) { //多行数据
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *CompayCode = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *Memo = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                inspection = [[InspectionModelEntity alloc] init];
                inspection.Code = Code;
                inspection.Name = Name;
                inspection.CompayCode = CompayCode;
                inspection.Memo = Memo;
            }
            else{
                NSLog(@"没有找到code为%@的模板......", Code);
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return inspection;
}

- (NSArray *) findInspectionChildModelByCode:(NSString*)ParentCode {
    NSMutableArray *childModels = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select ParentCode, ItemName, ItemType, InputMax, InputMin, ItemValues, UnitName from InspectionChild where ParentCode=\"%@\"",ParentCode];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *ParentCode = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *ItemName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                int ItemType = sqlite3_column_int(statement, 2);
                NSString *InputMax = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *InputMin = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSString *ItemValues = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                NSString *UnitName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                InspectionChildModelEntity *inspection = [[InspectionChildModelEntity alloc] init];
                inspection.ParentCode = ParentCode;
                inspection.ItemName = ItemName;
                inspection.ItemType = ItemType;
                inspection.InputMax = InputMax;
                inspection.InputMin = InputMin;
                inspection.ItemValues = ItemValues;
                inspection.UnitName = UnitName;
                
                [childModels addObject:inspection];
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return childModels;
}

@end
