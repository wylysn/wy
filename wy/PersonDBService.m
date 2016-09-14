//
//  PersonDBService.m
//  wy
//
//  Created by wangyilu on 16/8/30.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PersonDBService.h"

static PersonDBService *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation PersonDBService {
    NSString *databasePath;
}

+ (PersonDBService*)getSharedInstance {
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
                              [docsDir stringByAppendingPathComponent: @"wy-person.db"]];
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"数据库存储路径：%@", docsDir);
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSLog(@"数据库打开成功。。。。。。");
        [sharedInstance createPersonTable];
    }
    else {
        NSLog(@"数据库打开失败。。。。。。");
    }
}

- (void) createPersonTable {
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists Person (AppUserName text primary key, EmployeeId integer, EmployeeName text,DepartmentId integer, DepartName text, SortIndex integer, Phone text, Mobile text)";
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            NSLog(@"创建人员表失败。。。。。%s", errMsg);
        }
    }
    sqlite3_close(database);
}

- (BOOL) saveData:(PersonEntity *)person {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into Person (AppUserName, EmployeeId, EmployeeName, DepartmentId, DepartName, SortIndex, Phone, Mobile) values (\"%@\",\"%ld\",\"%@\",\"%ld\", \"%@\", \"%ld\", \"%@\", \"%@\")",person.AppUserName, person.EmployeeId, person.EmployeeName, person.DepartmentId, person.DepartName, person.SortIndex, person.Phone, person.Mobile];
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

- (PersonEntity *) findByAppUserName:(NSString*)AppUserName
{
    PersonEntity *person;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select AppUserName, EmployeeId, EmployeeName, DepartmentId, DepartName, SortIndex, Phone, Mobile from Person where AppUserName=\"%@\"",AppUserName];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(stmt) == SQLITE_ROW) { //多行数据
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *AppUserName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSInteger EmployeeId = sqlite3_column_int(statement, 1);
                NSString *EmployeeName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSInteger DepartmentId = sqlite3_column_int(statement, 3);
                NSString *DepartName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSInteger SortIndex = sqlite3_column_int(statement, 5);
                NSString *Phone = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                NSString *Mobile = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 7)];
                person = [[PersonEntity alloc] initWithDictionary:@{@"AppUserName":AppUserName, @"EmployeeId":[NSString stringWithFormat:@"%ld", EmployeeId], @"EmployeeName":EmployeeName, @"DepartmentId":[NSString stringWithFormat:@"%ld", DepartmentId], @"DepartName":DepartName, @"SortIndex":[NSString stringWithFormat:@"%ld", SortIndex], @"Phone":Phone, @"Mobile":Mobile}];
            }
            else{
                NSLog(@"没有找到username为%@的人员......", AppUserName);
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return person;
}

- (NSArray *) findAllPersons {
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = @"select AppUserName, EmployeeId, EmployeeName, DepartmentId, DepartName, SortIndex, Phone, Mobile from Person order by SortIndex";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(stmt) == SQLITE_ROW) { //多行数据
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *AppUserName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSInteger EmployeeId = sqlite3_column_int(statement, 1);
                NSString *EmployeeName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSInteger DepartmentId = sqlite3_column_int(statement, 3);
                NSString *DepartName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSInteger SortIndex = sqlite3_column_int(statement, 5);
                NSString *Phone = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                NSString *Mobile = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 7)];
                PersonEntity *person = [[PersonEntity alloc] initWithDictionary:@{@"AppUserName":AppUserName, @"EmployeeId":[NSString stringWithFormat:@"%ld", EmployeeId], @"EmployeeName":EmployeeName, @"DepartmentId":[NSString stringWithFormat:@"%ld", DepartmentId], @"DepartName":DepartName, @"SortIndex":[NSString stringWithFormat:@"%ld", SortIndex], @"Phone":Phone, @"Mobile":Mobile}];
                [resultArr addObject:person];
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return resultArr;
}

- (NSArray *) findPersonsByEmployeeName:(NSString*)AppUserName {
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"select AppUserName, EmployeeId, EmployeeName, DepartmentId, DepartName, SortIndex, Phone, Mobile from Person where EmployeeName like '%%%@%%' order by SortIndex", AppUserName];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(stmt) == SQLITE_ROW) { //多行数据
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *AppUserName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSInteger EmployeeId = sqlite3_column_int(statement, 1);
                NSString *EmployeeName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSInteger DepartmentId = sqlite3_column_int(statement, 3);
                NSString *DepartName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSInteger SortIndex = sqlite3_column_int(statement, 5);
                NSString *Phone = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                NSString *Mobile = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 7)];
                PersonEntity *person = [[PersonEntity alloc] initWithDictionary:@{@"AppUserName":AppUserName, @"EmployeeId":[NSString stringWithFormat:@"%ld", EmployeeId], @"EmployeeName":EmployeeName, @"DepartmentId":[NSString stringWithFormat:@"%ld", DepartmentId], @"DepartName":DepartName, @"SortIndex":[NSString stringWithFormat:@"%ld", SortIndex], @"Phone":Phone, @"Mobile":Mobile}];
                [resultArr addObject:person];
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return resultArr;
}

@end
