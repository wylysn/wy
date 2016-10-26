//
//  TaskDBService.m
//  wy
//
//  Created by wangyilu on 16/9/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskDBService.h"
#import "MaterialsEntity.h"
#import "ToolsEntity.h"

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

// 打开数据库
+ (sqlite3 *)open {
    // 此方法的主要作用是打开数据库
    // 返回值是一个数据库指针
    // 因为这个数据库在很多的SQLite API（函数）中都会用到，我们声明一个类方法来获取，更加方便
    
    // 懒加载
    if (database != nil) {
        return database;
    }
    
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString:
                              [docsDir stringByAppendingPathComponent: DBNAME]];
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"数据库存储路径：%@", docsDir);
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSLog(@"数据库打开成功。。。。。。");
    }
    else {
        NSLog(@"数据库打开失败。。。。。。");
    }
    
    return database;
}

+ (void)close {
    
    // 关闭数据库
    sqlite3_close(database);
    
    // 将数据库的指针置空
    database = nil;
    NSLog(@"数据库关闭。。。。。。");
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
        [sharedInstance createTaskDeviceTable];
        [sharedInstance createPlanDetailTable];
    }
    else {
        NSLog(@"数据库打开失败。。。。。。");
    }
}

- (BOOL) createTaskListTable {
    BOOL isSuccess = TRUE;
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists TaskList (Code text primary key, ShortTitle text, Subject text, ReceiveTime text, TaskStatus text, ServiceType text, Priority text, Location text)";
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
    NSString *sql_stmt =@"create table if not exists Task (Code text primary key, Applyer text, ApplyerTel text, ServiceType text, Priority text, Location text, Description text, CreateDate text, Creator text, Executors text, Leader text, Department text, EStartTime text, EEndTime text, EWorkHours text, AStartTime text, AEndTime text, AWorkHours text, WorkContent text, EditFields text, IsLocalSave bool, TaskNotice text, TaskAction text, SBList text, PicContent1 text, PicContent2 text, PicContent3 text, PicContent4 text, PicContent5 text, PicContent6 text, PicContent7 text, PicContent8 text, SBCheckList text)";
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            isSuccess = FALSE;
            NSLog(@"创建任务基本信息表失败。。。。。%s", errMsg);
        }
    }
    sqlite3_close(database);
    return isSuccess;
}

- (BOOL) createTaskDeviceTable {
    BOOL isSuccess = TRUE;
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists TaskDevice (Code text primary key, ParentID text, Name text, Position text, PatrolTemplateCode text, IsLocalSave bool)";
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            isSuccess = FALSE;
            NSLog(@"创建任务设备表失败。。。。。%s", errMsg);
        }
    }
    sqlite3_close(database);
    return isSuccess;
}

- (BOOL) createPlanDetailTable {
    BOOL isSuccess = TRUE;
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists PlanDetail (Code text primary key, Name text, Priority text, ExecuteTime text, StepList text, MaterialList text, ToolList text, PositionList text, SBList text, TaskAction text, EditFields text, IsLocalSave bool)";
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            isSuccess = FALSE;
            NSLog(@"创建计划任务信息表失败。。。。。%s", errMsg);
        }
    }
    sqlite3_close(database);
    return isSuccess;
}

- (BOOL) saveTaskList:(TaskListEntity *)taskList {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into TaskList (Code, ShortTitle, Subject, ReceiveTime, TaskStatus, ServiceType, Priority, Location) values (\"%@\",\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", taskList.Code, taskList.ShortTitle, taskList.Subject, taskList.ReceiveTime, taskList.TaskStatus, taskList.ServiceType, taskList.Priority, taskList.Location];
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

- (BOOL)deleteAllTaskList {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = @"delete from TaskList";
        const char *insert_stmt = [insertSQL UTF8String];
        int result = sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (result == SQLITE_OK) { // 语法通过
            // 执行插入语句
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"清除成功。。。。。");
                isSuccess = TRUE;
            } else {
                NSLog(@"清除失败:%s", sqlite3_errmsg(database));
            }
        } else {
            NSLog(@"语法不通过 ");
        }
        sqlite3_finalize(statement);
    }
    return isSuccess;
}

- (BOOL)deleteTaskList:(TaskListEntity *)taskList {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = @"delete from TaskList where Code=?";
        const char *insert_stmt = [insertSQL UTF8String];
        int result = sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (result == SQLITE_OK) { // 语法通过
            sqlite3_bind_text(statement, 1, [taskList.Code UTF8String], -1, SQLITE_TRANSIENT);
            
            // 执行插入语句
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"删除成功。。。。。");
                isSuccess = TRUE;
            } else {
                NSLog(@"删除失败:%s", sqlite3_errmsg(database));
            }
        } else {
            NSLog(@"语法不通过:%s", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }
    return isSuccess;
}

- (BOOL) saveTask:(TaskEntity *)task {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = @"insert into Task (Code, Applyer, ApplyerTel, ServiceType, Priority, Location, Description, CreateDate, Creator, Executors, Leader, Department, EStartTime, EEndTime, EWorkHours, AStartTime, AEndTime, AWorkHours, WorkContent, EditFields, IsLocalSave, TaskNotice, TaskAction, SBList, PicContent1, PicContent2, PicContent3, PicContent4, PicContent5, PicContent6, PicContent7, PicContent8, SBCheckList) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        const char *insert_stmt = [insertSQL UTF8String];
        int result = sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (result == SQLITE_OK) { // 语法通过
            sqlite3_bind_text(statement, 1, [task.Code UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [task.Applyer UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [task.ApplyerTel UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [task.ServiceType UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [task.Priority UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6, [task.Location UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 7, [task.Description UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 8, [task.CreateDate UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 9, [task.Creator UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 10, [task.Executors UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 11, [task.Leader UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 12, [task.Department UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 13, [task.EStartTime UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 14, [task.EEndTime UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 15, [task.EWorkHours UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 16, [task.AStartTime UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 17, [task.AEndTime UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 18, [[task.AWorkHours isBlankString]?@"":task.AWorkHours UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 19, [[task.WorkContent isBlankString]?@"":task.WorkContent UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 20, [task.EditFields UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement, 21, task.IsLocalSave);
            sqlite3_bind_text(statement, 22, [task.TaskNotice UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 23, [task.TaskAction UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 24, [task.SBList UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 25, [task.PicContent1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 26, [task.PicContent2 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 27, [task.PicContent3 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 28, [task.PicContent4 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 29, [task.PicContent5?task.PicContent5:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 30, [task.PicContent6?task.PicContent6:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 31, [task.PicContent7?task.PicContent7:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 32, [task.PicContent8?task.PicContent8:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 33, [task.SBCheckList UTF8String], -1, SQLITE_TRANSIENT);
            
            // 执行插入语句
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"插入成功。。。。。");
                isSuccess = TRUE;
            } else {
                NSLog(@"插入失败:%s", sqlite3_errmsg(database));
            }
        } else {
            NSLog(@"语法不通过:%s", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }
    return isSuccess;
}

- (BOOL)updateTaskEntity:(TaskEntity *)taskEntity {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = @"update Task set Location=?, Description=?, Executors=?, Leader=?, EStartTime=?, EEndTime=?, EWorkHours=?, WorkContent=?, SBList=?, PicContent1=?, PicContent2=?, PicContent3=?, PicContent4=?, PicContent5=?, PicContent6=?, PicContent7=?, PicContent8=?, SBCheckList=? where Code=?";
        const char *insert_stmt = [insertSQL UTF8String];
        int result = sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (result == SQLITE_OK) { // 语法通过
            sqlite3_bind_text(statement, 1, [taskEntity.Location UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [taskEntity.Description UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [taskEntity.Executors UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [taskEntity.Leader UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [taskEntity.EStartTime UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6, [taskEntity.EEndTime UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 7, [taskEntity.EWorkHours UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 8, [taskEntity.WorkContent UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 9, [taskEntity.SBList UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 10, [taskEntity.PicContent1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 11, [taskEntity.PicContent2 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 12, [taskEntity.PicContent3 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 13, [taskEntity.PicContent4 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 14, [taskEntity.PicContent5?taskEntity.PicContent5:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 15, [taskEntity.PicContent6?taskEntity.PicContent6:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 16, [taskEntity.PicContent7?taskEntity.PicContent7:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 17, [taskEntity.PicContent8?taskEntity.PicContent8:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 18, [taskEntity.SBCheckList UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 19, [taskEntity.Code UTF8String], -1, SQLITE_TRANSIENT);
            
            // 执行插入语句
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"更新成功。。。。。");
                isSuccess = TRUE;
            } else {
                NSLog(@"更新失败:%s", sqlite3_errmsg(database));
            }
        } else {
            NSLog(@"语法不通过:%s", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }
    return isSuccess;
}

- (BOOL)deleteTaskEntity:(NSString *)code {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = @"delete from Task where Code=?";
        const char *insert_stmt = [insertSQL UTF8String];
        int result = sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (result == SQLITE_OK) { // 语法通过
            sqlite3_bind_text(statement, 1, [code UTF8String], -1, SQLITE_TRANSIENT);
            
            // 执行插入语句
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"删除成功。。。。。");
                isSuccess = TRUE;
            } else {
                NSLog(@"删除失败:%s", sqlite3_errmsg(database));
            }
        } else {
            NSLog(@"语法不通过:%s", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }
    return isSuccess;
}

- (BOOL) saveTaskDevice:(TaskDeviceEntity *)taskDevice {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = @"insert into TaskDevice (Code, ParentID, Name, Position, PatrolTemplateCode, IsLocalSave) values (?,?,?,?,?,?)";
        const char *insert_stmt = [insertSQL UTF8String];
        int result = sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (result == SQLITE_OK) { // 语法通过
            sqlite3_bind_text(statement, 1, [taskDevice.Code UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [taskDevice.ParentID UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [taskDevice.Name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [taskDevice.Position UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [taskDevice.PatrolTemplateCode UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement, 6, taskDevice.IsLocalSave);
            
            // 执行插入语句
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"插入成功。。。。。");
                isSuccess = TRUE;
            } else {
                NSLog(@"插入失败:%s", sqlite3_errmsg(database));
            }
        } else {
            NSLog(@"语法不通过:%s", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }
    return isSuccess;
}

- (NSArray *)findTaskLists:(NSDictionary *)condition {
    NSMutableArray *taskArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSMutableString *querySQL = [[NSMutableString alloc] initWithString:@"select Code, ShortTitle, Subject, ReceiveTime, TaskStatus, ServiceType, Priority, Location from TaskList where 1=1 order by ReceiveTime desc"];
        NSEnumerator *keyIterater = condition.keyEnumerator;
        for (NSString *key in keyIterater) {
            if (![key isBlankString] || ![@"ServiceType" isEqualToString:key] || ![@"Priority" isEqualToString:key] || ![@"ShortTitle" isEqualToString:key] || ![@"TaskStatus" isEqualToString:key]) {
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
                NSArray *vArray = [condition[key] componentsSeparatedByString:@","];
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
                NSString *Location = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 7)];
                TaskListEntity *device = [[TaskListEntity alloc] initWithDictionary:@{@"Code":Code, @"ShortTitle":ShortTitle, @"Subject":Subject, @"ReceiveTime":ReceiveTime, @"TaskStatus":TaskStatus, @"ServiceType":ServiceType, @"Priority":Priority, @"Location":Location}];
                device.IsLocalSave = YES;//本地数据库没存，导致后面进入详细页面有问题,代码冲突，所以这里补上
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
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Applyer, ApplyerTel, ServiceType, Priority, Location, Description, CreateDate, Creator, Executors, Leader, Department, EStartTime, EEndTime, EWorkHours, AStartTime, AEndTime, AWorkHours, WorkContent, EditFields, IsLocalSave, TaskNotice, TaskAction, SBList, PicContent1, PicContent2, PicContent3, PicContent4, PicContent5, PicContent6, PicContent7, PicContent8, SBCheckList from Task where Code=\"%@\"",Code];
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
                NSString *Department = (const char *) sqlite3_column_text(statement, 11)?[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 11)]:@"";
                NSString *EStartTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 12)];
                NSString *EEndTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 13)];
                NSString * EWorkHours = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 14)];
                NSString *AStartTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 15)];
                NSString *AEndTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 16)];
                NSString *AWorkHours = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 17)];
                NSString *WorkContent = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 18)];
                NSString *EditFields = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 19)];
                BOOL IsLocalSave = (BOOL)sqlite3_column_int(statement, 20);
                NSString *TaskNotice = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 21)];
                NSString *TaskAction = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 22)];
                NSString *SBList = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 23)];
                NSString *PicContent1 = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 24)];
                NSString *PicContent2 = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 25)];
                NSString *PicContent3 = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 26)];
                NSString *PicContent4 = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 27)];
                NSString *PicContent5 = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 28)];
                NSString *PicContent6 = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 29)];
                NSString *PicContent7 = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 30)];
                NSString *PicContent8 = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 31)];
                NSString *SBCheckList = (const char *) sqlite3_column_text(statement, 32)?[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 32)]:@"";
                task = [[TaskEntity alloc] initWithDictionary:@{@"Code":Code, @"Applyer":Applyer, @"ApplyerTel":ApplyerTel, @"ServiceType":ServiceType, @"Priority":Priority, @"Location":Location, @"Description":Description, @"CreateDate":CreateDate, @"Creator":Creator, @"Executors":Executors, @"Leader":Leader, @"Department":Department, @"EStartTime":EStartTime, @"EEndTime":EEndTime, @"EWorkHours":EWorkHours, @"AStartTime":AStartTime, @"AEndTime":AEndTime, @"AWorkHours":AWorkHours, @"WorkContent":WorkContent, @"EditFields":EditFields, @"IsLocalSave":IsLocalSave?@"1":@"0", @"TaskNotice":TaskNotice, @"TaskAction":TaskAction, @"SBList":SBList, @"PicContent1":PicContent1, @"PicContent2":PicContent2, @"PicContent3":PicContent3, @"PicContent4":PicContent4, @"PicContent5":PicContent5, @"PicContent6":PicContent6, @"PicContent7":PicContent7, @"PicContent8":PicContent8, @"SBCheckList":SBCheckList}];
            }
            else{
                NSLog(@"没有找到code为%@的任务......", Code);
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return task;
}

- (NSArray *)findTaskDevices:code {
    NSMutableArray *taskDeviceArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select Code, ParentID, Name, Position, PatrolTemplateCode, IsLocalSave from TaskDevice where Code=\"%@\"",code];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *ParentID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *Position = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *PatrolTemplateCode = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                BOOL IsLocalSave = (BOOL)sqlite3_column_int(statement, 5);
                TaskDeviceEntity *device = [[TaskDeviceEntity alloc] initWithDictionary:@{@"Code":Code, @"ParentID":ParentID, @"Name":Name, @"Position":Position, @"PatrolTemplateCode":PatrolTemplateCode, @"IsLocalSave":IsLocalSave?@"1":@"0"}];
                [taskDeviceArr addObject:device];
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return taskDeviceArr;
}


- (BOOL) savePlanDetail:(PlanDetailEntity *)planDetail {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = @"insert into PlanDetail (Code, Name, Priority, ExecuteTime, StepList, MaterialList, ToolList, PositionList, SBList, TaskAction, EditFields, IsLocalSave) values (?,?,?,?,?,?,?,?,?,?,?,?)";
        const char *insert_stmt = [insertSQL UTF8String];
        int result = sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (result == SQLITE_OK) { // 语法通过
            sqlite3_bind_text(statement, 1, [planDetail.Code UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [planDetail.Name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [planDetail.Priority UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [planDetail.ExecuteTime UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [[NSString convertArrayToString:planDetail.StepList] UTF8String], -1, SQLITE_TRANSIENT);
            
            NSMutableArray *materialArr = [[NSMutableArray alloc] init];
            for (MaterialsEntity *material in planDetail.MaterialList) {
                [materialArr addObject:[material toDictionary]];
            }
            sqlite3_bind_text(statement, 6, [[NSString convertArrayToString:materialArr] UTF8String], -1, SQLITE_TRANSIENT);
            
            NSMutableArray *toolArr = [[NSMutableArray alloc] init];
            for (ToolsEntity *tool in planDetail.ToolList) {
                [toolArr addObject:[tool toDictionary]];
            }
            sqlite3_bind_text(statement, 7, [[NSString convertArrayToString:toolArr] UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(statement, 8, [[NSString convertArrayToString:planDetail.PositionList] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 9, [[NSString convertArrayToString:planDetail.SBList] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 10, [[NSString convertArrayToString:planDetail.TaskAction] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 11, [planDetail.EditFields UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement, 12, planDetail.IsLocalSave);
            
            // 执行插入语句
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"插入成功。。。。。");
                isSuccess = TRUE;
            } else {
                NSLog(@"插入失败:%s", sqlite3_errmsg(database));
            }
        } else {
            NSLog(@"语法不通过:%s", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }
    return isSuccess;
}

- (BOOL)updatePlanDetail:(PlanDetailEntity *)planDetail {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = @"update PlanDetail set MaterialList=?, ToolList=? where Code=?";
        const char *insert_stmt = [insertSQL UTF8String];
        int result = sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (result == SQLITE_OK) { // 语法通过
            NSMutableArray *materialArr = [[NSMutableArray alloc] init];
            for (MaterialsEntity *material in planDetail.MaterialList) {
                [materialArr addObject:[material toDictionary]];
            }
            sqlite3_bind_text(statement, 1, [[NSString convertArrayToString:materialArr] UTF8String], -1, SQLITE_TRANSIENT);
            
            NSMutableArray *toolArr = [[NSMutableArray alloc] init];
            for (ToolsEntity *tool in planDetail.ToolList) {
                [toolArr addObject:[tool toDictionary]];
            }
            sqlite3_bind_text(statement, 2, [[NSString convertArrayToString:toolArr] UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(statement, 3, [planDetail.Code UTF8String], -1, SQLITE_TRANSIENT);
            
            // 执行插入语句
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"更新成功。。。。。");
                isSuccess = TRUE;
            } else {
                NSLog(@"更新失败:%s", sqlite3_errmsg(database));
            }
        } else {
            NSLog(@"语法不通过:%s", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }
    return isSuccess;
}

- (PlanDetailEntity *)findPlanDetailByCode:(NSString*)Code {
    PlanDetailEntity *plan;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Name, Priority, ExecuteTime, StepList, MaterialList, ToolList, PositionList, SBList, TaskAction, EditFields, IsLocalSave from PlanDetail where Code=\"%@\"",Code];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(stmt) == SQLITE_ROW) { //多行数据
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *Priority = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *ExecuteTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *StepList = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSString *MaterialList = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                NSString *ToolList = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                NSString *PositionList = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 7)];
                NSString *SBList = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 8)];
                NSString *TaskAction = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 9)];
                NSString *EditFields = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 10)];
                BOOL IsLocalSave = (BOOL)sqlite3_column_int(statement, 11);
                plan = [[PlanDetailEntity alloc] initWithDictionary:@{@"Code":Code, @"Name":Name, @"Priority":Priority, @"ExecuteTime":ExecuteTime, @"StepList":[NSString convertStringToArray:StepList], @"MaterialList":[NSString convertStringToArray:MaterialList], @"ToolList":[NSString convertStringToArray:ToolList], @"PositionList":[NSString convertStringToArray:PositionList], @"SBList":[NSString convertStringToArray:SBList], @"TaskAction":[NSString convertStringToArray:TaskAction], @"EditFields":EditFields, @"IsLocalSave":IsLocalSave?@"1":@"0"} withType:0];
            }
            else{
                NSLog(@"没有找到code为%@的任务......", Code);
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return plan;
}

@end
