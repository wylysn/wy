//
//  DeviceClassDBService.m
//  wy
//
//  Created by 王益禄 on 2016/10/22.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "DeviceClassDBService.h"

static DeviceClassDBService *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DeviceClassDBService{
    NSString *databasePath;
}

+ (DeviceClassDBService *)getSharedInstance{
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
                    [docsDir stringByAppendingPathComponent: @"wy-deviceclass.db"]];
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"数据库存储位置：%@", databasePath);
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSLog(@"数据库打开成功。。。。。。");
        [sharedInstance createDeviceClassTable];
    }
    else {
        NSLog(@"数据库打开失败。。。。。。");
    }
}

- (BOOL) createDeviceClassTable {
    BOOL isSuccess = TRUE;
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists DeviceClass (ID integer primary key, Code text, Name text, ParentID integer)";
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            isSuccess = FALSE;
            NSLog(@"创建设备分类表失败。。。。。%s", errMsg);
        }
    }
    sqlite3_close(database);
    return isSuccess;
}

- (BOOL) saveDeviceClass:(DeviceClassEntity *)deviceClass {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = @"insert into DeviceClass (ID, Code, Name, ParentID) values (?, ?, ?, ?)";
        const char *insert_stmt = [insertSQL UTF8String];
        int result = sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (result == SQLITE_OK) { // 语法通过
            sqlite3_bind_int(statement, 1, (int)deviceClass.ID);
            sqlite3_bind_text(statement, 2, [deviceClass.Code UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [deviceClass.Name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement, 4, (int)deviceClass.ParentID);
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

- (NSArray *) findAllDeviceClass {
    NSMutableArray *positionArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = @"select ID, Code, Name, ParentID from DeviceClass";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int id = sqlite3_column_int(statement, 0);
                NSString *code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                int parentId = sqlite3_column_int(statement, 3);
                DeviceClassEntity *deviceClass = [[DeviceClassEntity alloc] initWithDictionary:@{@"ID":[NSString stringWithFormat:@"%d", id], @"Code":code, @"Name":name, @"ParentID":[NSString stringWithFormat:@"%d", parentId]}];
                [positionArr addObject:deviceClass];
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

- (NSMutableArray *) findDeviceClassByParent:(DeviceClassEntity *)parent {
    NSMutableArray *positionArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"select a.*,ifnull(b.count,0) as CHILDNUM from ( select * from DeviceClass a where a.ParentID = %ld) a left join (select b.ParentID, count(1) as count from (select * from DeviceClass a where a.ParentID = %ld) a, DeviceClass b where a.ID = b.ParentID group by b.ParentID) b on a.ID = b.ParentID", parent.ID, parent.ID];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int id = sqlite3_column_int(statement, 0);
                NSString *code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                int parentId = sqlite3_column_int(statement, 3);
                int childnum = sqlite3_column_int(statement, 4);
                DeviceClassEntity *deviceClass = [[DeviceClassEntity alloc] initWithDictionary:@{@"ID":[NSString stringWithFormat:@"%d", id], @"Code":code, @"Name":name, @"ParentID":[NSString stringWithFormat:@"%d", parentId]}];
                deviceClass.childNum = childnum;
                deviceClass.level = parent.level+1;
                [positionArr addObject:deviceClass];
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
