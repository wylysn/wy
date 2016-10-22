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
    NSString *sql_stmt =@"create table if not exists Device (Code text primary key, Name text, Model text, Brand text, Xlhao text, Pro_Date text, Weight text, Des_Life text, Pos text, Description text, Patrol_Tpl text, Status integer, Picture text, Attachment text, Organizationid text, ClassName text, PosID text, ClassID text)";
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
    NSString *insertSQL = @"insert into Device (Code, Name, Model, Brand, Xlhao, Pro_Date, Weight, Des_Life, Pos, Description, Patrol_Tpl, Status, Picture, Attachment, Organizationid, ClassName, PosID, ClassID) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        const char *insert_stmt = [insertSQL UTF8String];
        
        int result = sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (result == SQLITE_OK) { // 语法通过
            sqlite3_bind_text(statement, 1, [device.Code UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [device.Name UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 3, [device.QRCode UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 4, [device.Class UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [device.Model UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [device.Brand UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [device.Xlhao UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6, [device.Pro_Date UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 7, [device.Weight UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 8, [device.Des_Life UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 9, [device.Pos UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 10, [device.Description UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 11, [device.Patrol_Tpl UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 12, [device.Status UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 13, [device.Picture UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 14, [device.Attachment UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 15, [device.Organizationid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 16, [device.ClassName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 17, [device.PosID UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 18, [device.ClassID UTF8String], -1, SQLITE_TRANSIENT);
            
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

- (NSArray *)findAllDevices {
    NSMutableArray *deviceArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Name, Model, Brand, Xlhao, Pro_Date, Weight, Des_Life, Pos, Description, Patrol_Tpl, Status, Picture, Attachment, ClassName, PosID, ClassID from Device"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *Model = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *Brand = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *Xlhao = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSString *Pro_Date = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                NSString *Weight = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                NSString *Des_Life = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 7)];
                NSString *Pos = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 8)];
                NSString *Description = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 9)];
                NSString *Patrol_Tpl = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 10)];
                NSString *Status = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 11)];
                NSString *Picture = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 12)];
                NSString *Attachment = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 13)];
                NSString *Organizationid = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 14)];
                NSString *ClassName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 15)];
                NSString *PosID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 16)];
                NSString *ClassID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 17)];
                DeviceEntity *device = [[DeviceEntity alloc] initWithDictionary:@{@"Code":Code, @"Name":Name, @"Model":Model, @"Brand":Brand, @"Xlhao":Xlhao, @"Pro_Date":Pro_Date, @"Weight":Weight, @"Des_Life":Des_Life, @"Pos":Pos, @"Description":Description, @"Patrol_Tpl":Patrol_Tpl, @"Status":Status, @"Picture":Picture, @"Attachment":Attachment, @"Organizationid":Organizationid, @"ClassName":ClassName, @"PosID":PosID, @"ClassID":ClassID}];
                [deviceArr addObject:device];
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return deviceArr;
}

- (NSArray *) findDevicesByName:(NSString*)name {
    NSMutableArray *deviceArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Name, Model, Brand, Xlhao, Pro_Date, Weight, Des_Life, Pos, Description, Patrol_Tpl, Status, Picture, Attachment, Organizationid, ClassName, PosID, ClassID from Device where Name like '%%%@%%'",  [NSString stringWithCString:[name UTF8String] encoding:NSUTF8StringEncoding]];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *Model = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *Brand = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *Xlhao = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSString *Pro_Date = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                NSString *Weight = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                NSString *Des_Life = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 7)];
                NSString *Pos = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 8)];
                NSString *Description = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 9)];
                NSString *Patrol_Tpl = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 10)];
                NSString *Status = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 11)];
                NSString *Picture = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 12)];
                NSString *Attachment = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 13)];
                NSString *Organizationid = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 14)];
                NSString *ClassName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 15)];
                NSString *PosID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 16)];
                NSString *ClassID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 17)];
                DeviceEntity *device = [[DeviceEntity alloc] initWithDictionary:@{@"Code":Code, @"Name":Name, @"Model":Model, @"Brand":Brand, @"Xlhao":Xlhao, @"Pro_Date":Pro_Date, @"Weight":Weight, @"Des_Life":Des_Life, @"Pos":Pos, @"Description":Description, @"Patrol_Tpl":Patrol_Tpl, @"Status":Status, @"Picture":Picture, @"Attachment":Attachment, @"Organizationid":Organizationid, @"ClassName":ClassName, @"PosID":PosID, @"ClassID":ClassID}];
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

- (NSArray *) findAssetsByCondition:(NSDictionary*)condition {
    NSMutableArray *deviceArr = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *keyWord = condition[@"keyword"]?condition[@"keyword"]:@"";
        NSString *key = [NSString stringWithCString:[keyWord UTF8String] encoding:NSUTF8StringEncoding];
        
        NSMutableString *querySql = [[NSMutableString alloc] initWithString:@"select Code, Name, Model, Brand, Xlhao, Pro_Date, Weight, Des_Life, Pos, Description, Patrol_Tpl, Status, Picture, Attachment, Organizationid, ClassName, PosID, ClassID from Device where 1=1"];
        if (![keyWord isBlankString]) {
            [querySql appendString:[NSString stringWithFormat:@" and (Name like '%%%@%%' or Pos like '%%%@%%' or Brand like '%%%@%%')", key, key, key]];
        }
        
        NSArray *locationArr = [((NSDictionary *)condition[@"Location"]) allKeys];
        if (locationArr.count>0) {
            NSString *locations = [locationArr componentsJoinedByString:@","];
            [querySql appendString:[NSString stringWithFormat:@" and (PosID in (%@))", locations]];
        }
        
        NSArray *classArr = [((NSDictionary *)condition[@"DeviceClass"]) allKeys];
        if (classArr.count>0) {
            NSString *classes = [classArr componentsJoinedByString:@","];
            [querySql appendString:[NSString stringWithFormat:@" and (ClassID in (%@))", classes]];
        }
        
        const char *query_stmt = [querySql UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *Model = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *Brand = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *Xlhao = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSString *Pro_Date = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                NSString *Weight = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                NSString *Des_Life = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 7)];
                NSString *Pos = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 8)];
                NSString *Description = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 9)];
                NSString *Patrol_Tpl = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 10)];
                NSString *Status = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 11)];
                NSString *Picture = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 12)];
                NSString *Attachment = (const char *) sqlite3_column_text(statement, 13)?[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 13)]:@"";
                NSString *Organizationid = (const char *) sqlite3_column_text(statement, 14)?[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 14)]:@"";
                NSString *ClassName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 15)];
                NSString *PosID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 16)];
                NSString *ClassID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 17)];
                DeviceEntity *device = [[DeviceEntity alloc] initWithDictionary:@{@"Code":Code, @"Name":Name, @"Model":Model, @"Brand":Brand, @"Xlhao":Xlhao, @"Pro_Date":Pro_Date, @"Weight":Weight, @"Des_Life":Des_Life, @"Pos":Pos, @"Description":Description, @"Patrol_Tpl":Patrol_Tpl, @"Status":Status, @"Picture":Picture, @"Attachment":Attachment, @"Organizationid":Organizationid, @"ClassName":ClassName, @"PosID":PosID, @"ClassID":ClassID}];
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

- (DeviceEntity *)findDeviceByCode:(NSString *)Code {
    DeviceEntity *device;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select Code, Name, Model, Brand, Xlhao, Pro_Date, Weight, Des_Life, Pos, Description, Patrol_Tpl, Status, Picture, Attachment, Organizationid, ClassName, PosID, ClassID from Device where Code=\"%@\"",Code];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(stmt) == SQLITE_ROW) { //多行数据
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *Code = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *Model = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *Brand = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *Xlhao = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSString *Pro_Date = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                NSString *Weight = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                NSString *Des_Life = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 7)];
                NSString *Pos = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 8)];
                NSString *Description = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 9)];
                NSString *Patrol_Tpl = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 10)];
                NSString *Status = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 11)];
                NSString *Picture = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 12)];
                NSString *Attachment = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 13)];
                NSString *Organizationid = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 14)];
                NSString *ClassName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 15)];
                NSString *PosID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 16)];
                NSString *ClassID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 17)];
                device = [[DeviceEntity alloc] initWithDictionary:@{@"Code":Code, @"Name":Name, @"Model":Model, @"Brand":Brand, @"Xlhao":Xlhao, @"Pro_Date":Pro_Date, @"Weight":Weight, @"Des_Life":Des_Life, @"Pos":Pos, @"Description":Description, @"Patrol_Tpl":Patrol_Tpl, @"Status":Status, @"Picture":Picture, @"Attachment":Attachment, @"Organizationid":Organizationid, @"ClassName":ClassName, @"PosID":PosID, @"ClassID":ClassID}];
            }
            else{
                NSLog(@"没有找到code为%@的设备......", Code);
            }
        } else {
            NSLog(@"查找失败:%s", sqlite3_errmsg(database));
        }
    }
    sqlite3_finalize(statement);
    return device;
}

@end
