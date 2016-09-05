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
    }
    else {
        NSLog(@"数据库打开失败。。。。。。");
    }
}

- (BOOL) createInspectionTable {
    BOOL isSuccess = TRUE;
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists Inspection (Code text primary key, Name text, CompayCode text, Memo text, ItemName text, ItemType integer, InputMax float, InputMin float, ItemValues text, UnitName text)";
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

- (BOOL) saveInspectionModel:(InspectionModelEntity *)inspection {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into Inspection (Code, Name, CompayCode, Memo, ItemName, ItemType, InputMax, InputMin, ItemValues, UnitName) values (\"%@\",\"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%f\", \"%f\", \"%@\", \"%@\")", inspection.Code, inspection.Name, inspection.CompayCode, inspection.Memo, inspection.ItemName, inspection.ItemType, inspection.InputMax, inspection.InputMin, inspection.ItemValues, inspection.UnitName];
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
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Name, CompayCode, Memo, ItemName, ItemType, InputMax, InputMin, ItemValues, UnitName from Inspection where Code=\"%@\"",Code];
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
                NSString *ItemName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                int ItemType = sqlite3_column_int(statement, 5);
                float InputMax = sqlite3_column_double(statement, 6);
                float InputMin = sqlite3_column_double(statement, 7);
                NSString *ItemValues = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 8)];
                NSString *UnitName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 9)];
                inspection = [[InspectionModelEntity alloc] init];
                inspection.Code = Code;
                inspection.Name = Name;
                inspection.CompayCode = CompayCode;
                inspection.Memo = Memo;
                inspection.ItemName = ItemName;
                inspection.ItemType = ItemType;
                inspection.InputMax = InputMax;
                inspection.InputMin = InputMin;
                inspection.ItemValues = ItemValues;
                inspection.UnitName = UnitName;
            }
            else{
                NSLog(@"没有找到code为%@的人员......", Code);
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return inspection;
}

@end
