//
//  DeviceDBService.m
//  wy
//
//  Created by wangyilu on 16/8/30.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "DeviceDBService.h"

static DeviceDBService *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DeviceDBService {
    NSString *databasePath;
}

+ (DeviceDBService *)getSharedInstance{
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
                              [docsDir stringByAppendingPathComponent: @"wy-device.db"]];
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"数据库存储路径：%@", docsDir);
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSLog(@"数据库打开成功。。。。。。");
        [sharedInstance createDeviceListTable];
        [sharedInstance createDeviceTable];
    }
    else {
        NSLog(@"数据库打开失败。。。。。。");
    }
}

- (BOOL) createDeviceListTable {
    BOOL isSuccess = TRUE;
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists DeviceList (Code text primary key, Name text, Class text, Location text, KeyId text)";
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            isSuccess = FALSE;
            NSLog(@"创建设备台账表失败。。。。。%s", errMsg);
        }
    }
    sqlite3_close(database);
    return isSuccess;
}

- (BOOL) createDeviceTable {
    BOOL isSuccess = TRUE;
    char *errMsg;
    NSString *sql_stmt =@"create table if not exists Device (Code text primary key, Name text, QRCode text, Class text, Model text, Brand text, Xlhao text, Pro_Date text, Weight text, Des_Life text, Pos text, Description text, Patrol_Tpl text, Status integer, Picture text, Attachment text, Organizationid text)";
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

- (BOOL) saveDeviceList:(DeviceListEntity *)deviceList {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into DeviceList (Code, Name, Class, Location, KeyId) values (\"%@\",\"%@\", \"%@\", \"%@\", \"%@\")", deviceList.Code, deviceList.Name, deviceList.class, deviceList.Location, deviceList.KeyId];
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

- (DeviceListEntity *)findDeviceListByCode:(NSString *)Code {
    DeviceListEntity *device;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Name, Class, Location, KeyId from DeviceList where Code=\"%@\"",Code];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(stmt) == SQLITE_ROW) { //多行数据
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *Class = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *Location = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *KeyId = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                device = [[DeviceListEntity alloc] initWithDictionary:@{@"Code":Code, @"Name":Name, @"Class":Class, @"Location":Location, @"KeyId":KeyId}];
            }
            else{
                NSLog(@"没有找到code为%@的人员......", Code);
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return device;
}

- (NSArray *) findDeviceListsByName:(NSString*)name {
    NSMutableArray *deviceArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Name, Class, Location, KeyId from DeviceList where Name like '%%%@%%'",  [NSString stringWithCString:[name UTF8String] encoding:NSUTF8StringEncoding]];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *Class = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *Location = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *KeyId = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                DeviceListEntity *device = [[DeviceListEntity alloc] initWithDictionary:@{@"Code":Code, @"Name":Name, @"Class":Class, @"Location":Location, @"KeyId":KeyId}];
                [deviceArr addObject:device];
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    } else {
        NSLog(@"查找失败:%s", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    return deviceArr;
}

- (NSArray *)findAllDeviceLists {
    NSMutableArray *deviceArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Name, Class, Location, KeyId from DeviceList"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *Class = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *Location = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *KeyId = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                DeviceListEntity *device = [[DeviceListEntity alloc] initWithDictionary:@{@"Code":Code, @"Name":Name, @"Class":Class, @"Location":Location, @"KeyId":KeyId}];
                [deviceArr addObject:device];
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return deviceArr;
}

- (BOOL) saveDevice:(DeviceEntity *)device {
    BOOL isSuccess = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into Device (Code, Name, QRCode, Class, Model, Brand, Xlhao, Pro_Date, Weight, Des_Life, Pos, Description, Patrol_Tpl, Status, Picture, Attachment, Organizationid) values (\"%@\",\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\", \"%@\")", device.Code, device.Name, device.QRCode, device.Class, device.Model, device.Brand, device.Xlhao, device.Pro_Date, device.Weight, device.Des_Life, device.Pos, device.Description, device.Patrol_Tpl, device.Status, device.Picture, device.Attachment, device.Organizationid];
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

- (DeviceEntity *)findDeviceByCode:(NSString *)Code {
    DeviceEntity *device;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Name, QRCode, Class, Model, Brand, Xlhao, Pro_Date, Weight, Des_Life, Pos, Description, Patrol_Tpl, Status, Picture, Attachment, Organizationid from Device where Code=\"%@\"",Code];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(stmt) == SQLITE_ROW) { //多行数据
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *QRCode = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *Class = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *Model = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSString *Brand = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                NSString *Xlhao = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                NSString *Pro_Date = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 7)];
                NSString *Weight = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 8)];
                NSString *Des_Life = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 9)];
                NSString *Pos = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 10)];
                NSString *Description = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 11)];
                NSString *Patrol_Tpl = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 12)];
                int Status = sqlite3_column_int(statement, 13);
                NSString *Picture = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 14)];
                NSString *Attachment = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 15)];
                NSString *Organizationid = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 16)];
                device = [[DeviceEntity alloc] initWithDictionary:@{@"Code":Code, @"Name":Name, @"QRCode":QRCode, @"Class":Class, @"Model":Model, @"Brand":Brand, @"Xlhao":Xlhao, @"Pro_Date":Pro_Date, @"Weight":Weight, @"Des_Life":Des_Life, @"Pos":Pos, @"Description":Description, @"Patrol_Tpl":Patrol_Tpl, @"Status":[NSString stringWithFormat:@"%d",Status], @"Picture":Picture, @"Attachment":Attachment, @"Organizationid":Organizationid}];
            }
            else{
                NSLog(@"没有找到code为%@的人员......", Code);
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return device;
}

@end
