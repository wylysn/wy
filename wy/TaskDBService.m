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
        [sharedInstance createTaskDeviceTable];
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
    NSString *sql_stmt =@"create table if not exists Task (Code text primary key, Applyer text, ApplyerTel text, ServiceType text, Priority text, Location text, Description text, CreateDate text, Creator text, Executors text, Leader text, Department text, EStartTime text, EEndTime text, EWorkHours text, AStartTime text, AEndTime text, AWorkHours text, WorkContent text, EditFields text, IsLocalSave bool, TaskNotice text, TaskAction text, SBList text, PicContent1 text, PicContent2 text, PicContent3 text, PicContent4 text, SBCheckList text)";
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

- (BOOL) saveTask:(TaskEntity *)task {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = @"insert into Task (Code, Applyer, ApplyerTel, ServiceType, Priority, Location, Description, CreateDate, Creator, Executors, Leader, Department, EStartTime, EEndTime, EWorkHours, AStartTime, AEndTime, AWorkHours, WorkContent, EditFields, IsLocalSave, TaskNotice, TaskAction, SBList, PicContent1, PicContent2, PicContent3, PicContent4, SBCheckList) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
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
            sqlite3_bind_text(statement, 29, [task.SBCheckList UTF8String], -1, SQLITE_TRANSIENT);
            
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
        NSString *insertSQL = @"update Task set Location=?, Description=?, Executors=?, Leader=?, EStartTime=?, EEndTime=?, EWorkHours=?, WorkContent=?, SBList=?, PicContent1=?, PicContent2=?, PicContent3=?, PicContent4=?, SBCheckList=? where Code=?";
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
            sqlite3_bind_text(statement, 14, [taskEntity.SBCheckList UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 15, [taskEntity.Code UTF8String], -1, SQLITE_TRANSIENT);
            
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
        NSMutableString *querySQL = [[NSMutableString alloc] initWithString:@"select Code, ShortTitle, Subject, ReceiveTime, TaskStatus, ServiceType, Priority, Location from TaskList where 1=1"];
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
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Applyer, ApplyerTel, ServiceType, Priority, Location, Description, CreateDate, Creator, Executors, Leader, Department, EStartTime, EEndTime, EWorkHours, AStartTime, AEndTime, AWorkHours, WorkContent, EditFields, IsLocalSave, TaskNotice, TaskAction, SBList, PicContent1, PicContent2, PicContent3, PicContent4 from Task where Code=\"%@\"",Code];
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
                task = [[TaskEntity alloc] initWithDictionary:@{@"Code":Code, @"Applyer":Applyer, @"ApplyerTel":ApplyerTel, @"ServiceType":ServiceType, @"Priority":Priority, @"Location":Location, @"Description":Description, @"CreateDate":CreateDate, @"Creator":Creator, @"Executors":Executors, @"Leader":Leader, @"Department":Department, @"EStartTime":EStartTime, @"EEndTime":EEndTime, @"EWorkHours":EWorkHours, @"AStartTime":AStartTime, @"AEndTime":AEndTime, @"AWorkHours":AWorkHours, @"WorkContent":WorkContent, @"EditFields":EditFields, @"IsLocalSave":IsLocalSave?@"1":@"0", @"TaskNotice":TaskNotice, @"TaskAction":TaskAction, @"SBList":SBList, @"PicContent1":PicContent1, @"PicContent2":PicContent2, @"PicContent3":PicContent3, @"PicContent4":PicContent4}];
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

@end
