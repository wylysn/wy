//
//  TaskDBService.m
//  wy
//
//  Created by wangyilu on 16/9/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskDBService.h"
#import <sqlite3.h>

static TaskDBService *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation TaskDBService {
    NSString *databasePath;
}

+ (TaskDBService *)getSharedInstance{
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
                    [docsDir stringByAppendingPathComponent: @"wy.db"]];
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"数据库存储路径：%@", docsDir);
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSLog(@"数据库打开成功。。。。。。");
        [sharedInstance createTaskListTable];
        [sharedInstance createTaskTable];
    }
    else {
        NSLog(@"数据库打开失败。。。。。。");
    }
}

- (BOOL) createTaskListTable {
    BOOL isSuccess = TRUE;
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists TaskList (Code text primary key, ShortTitle text, Subject text, ReceiveTime text, TaskStatus text, ServiceType text, Priority text, Position text)";
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            isSuccess = FALSE;
            NSLog(@"创建任务台账表失败。。。。。%s", errMsg);
        }
    }
    sqlite3_close(database);
    return isSuccess;
}

- (BOOL) createTaskTable {
    BOOL isSuccess = TRUE;
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists Task (Code text primary key, Applyer text, ApplyerTel text, ServiceType text, Priority text, Location text, Description text, CreateDate text, Creator text, Executors text, Leader text, EStartTime text, EEndTime text, EWorkHours text, AStartTime text, AEndTime text, AWorkHours text, WorkContent text, EditFields text)";
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            isSuccess = FALSE;
            NSLog(@"创建设备表失败。。。。。%s", errMsg);
        }
    }
    sqlite3_close(database);
    return isSuccess;
}

- (BOOL) saveTaskList:(TaskListEntity *)taskList {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into TaskList (Code, ShortTitle, Subject, ReceiveTime, TaskStatus, ServiceType, Priority, Position) values (\"%@\",\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", taskList.Code, taskList.ShortTitle, taskList.Subject, taskList.ReceiveTime, taskList.TaskStatus, taskList.ServiceType, taskList.Priority, taskList.Position];
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

- (BOOL) saveTask:(TaskEntity *)task {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into Task (Code, Applyer, ApplyerTel, ServiceType, Priority, Location, Description, CreateDate, Creator, Executors, Leader, EStartTime, EEndTime, EWorkHours, AStartTime, AEndTime, AWorkHours, WorkContent, EditFields) values (\"%@\",\"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\", \"%@\", \"%@\")", task.Code, task.Applyer, task.ApplyerTel, task.ServiceType, task.Priority, task.Location, task.Description, task.CreateDate, task.Creator, task.Executors, task.Leader, task.EStartTime, task.EEndTime, task.EWorkHours, task.AStartTime, task.AEndTime, task.AWorkHours, task.WorkContent, task.EditFields];
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

- (NSArray *)findTaskLists:(NSDictionary *)condition {
    NSMutableArray *taskArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSMutableString *querySQL = [[NSMutableString alloc] initWithString:@"select Code, ShortTitle, Subject, ReceiveTime, TaskStatus, ServiceType, Priority, Position from TaskList where 1=1"];
        NSEnumerator *keyIterater = condition.keyEnumerator;
        for (NSString *key in keyIterater) {
            if (![key isBlankString]) {
                [querySQL appendString:@" and "];
                if ([@"ServiceType" isEqualToString:key]) {
                    [querySQL appendString:@"ServiceType"];
                } else if ([@"Priority" isEqualToString:key]) {
                    [querySQL appendString:@"Priority"];
                } else if ([@"ShortTitle" isEqualToString:key]) {
                    [querySQL appendString:@"ShortTitle"];
                } else if ([@"TaskStatus" isEqualToString:key]) {
                    [querySQL appendString:@"TaskStatus"];
                }
                [querySQL appendString:@" in ("];
                NSArray *vArray = [key componentsSeparatedByString:@","];
                for (int i=0; i<vArray.count; i++) {
                    NSString *vl = vArray[i];
                    [querySQL appendString:[NSString stringWithFormat:@"'%@'", vl]];
                    if (i!=vArray.count-1) {
                        [querySQL appendString:@","];
                    }
                }
                [querySQL appendString:@")"];
            }
        }
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *ShortTitle = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *Subject = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *ReceiveTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *TaskStatus = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSString *ServiceType = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                NSString *Priority = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                NSString *Position = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 7)];
                TaskListEntity *device = [[TaskListEntity alloc] initWithDictionary:@{@"Code":Code, @"ShortTitle":ShortTitle, @"Subject":Subject, @"ReceiveTime":ReceiveTime, @"TaskStatus":TaskStatus, @"ServiceType":ServiceType, @"Priority":Priority, @"Position":Position}];
                [taskArr addObject:device];
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return taskArr;
}

- (TaskEntity *)findTaskByCode:(NSString *)Code {
    TaskEntity *task;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Applyer, ApplyerTel, ServiceType, Priority, Location, Description, CreateDate, Creator, Executors, Leader, EStartTime, EEndTime, EWorkHours, AStartTime, AEndTime, AWorkHours, WorkContent, EditFields from Device where Code=\"%@\"",Code];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(stmt) == SQLITE_ROW) { //多行数据
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Applyer = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *ApplyerTel = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *ServiceType = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *Priority = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSString *Location = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                NSString *Description = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                NSString *CreateDate = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 7)];
                NSString *Creator = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 8)];
                NSString *Executors = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 9)];
                NSString *Leader = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 10)];
                NSString *EStartTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 11)];
                NSString *EEndTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 12)];
                NSString * EWorkHours = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 13)];
                NSString *AStartTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 14)];
                NSString *AEndTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 15)];
                NSString *AWorkHours = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 16)];
                NSString *WorkContent = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 17)];
                NSString *EditFields = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 18)];
                task = [[TaskEntity alloc] initWithDictionary:@{@"Code":Code, @"Applyer":Applyer, @"ApplyerTel":ApplyerTel, @"ServiceType":ServiceType, @"Priority":Priority, @"Location":Location, @"Description":Description, @"CreateDate":CreateDate, @"Creator":Creator, @"Executors":Executors, @"Leader":Leader, @"EStartTime":EStartTime, @"EEndTime":EEndTime, @"EWorkHours":EWorkHours, @"AStartTime":AStartTime, @"AEndTime":AEndTime, @"AWorkHours":AWorkHours, @"WorkContent":WorkContent, @"EditFields":EditFields}];
            }
            else{
                NSLog(@"没有找到code为%@的人员......", Code);
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return task;
}

@end
