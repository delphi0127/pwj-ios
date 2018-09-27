//
//  myDB.m
//  pwj1
//
//  Created by Apollo on 15/6/9.
//  Copyright (c) 2015年 Apollo. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AppDelegate-Swift.h"
//#import "TableViewController-Swift.h"
#import <sqlite3.h>

sqlite3 *database;
int result = sqlite3_open("/Users/Apollo/Desktop/pwj/pwjcs_0.db",&database);
char *errorMsg;
const char *stringPath = [pathString UTF8String];
const char *createSQL = "CREATE TABLE IF NOT EXISTS PEOPLE" "(ID INTEGER PRIMARY KEY AUTOINCREMENT, FIELD_DATA TEXT)";
int result = sqlite3_exec(database,createSQL,NULL,NULL,&errorMsg);

NSString *query = @"SELECT ID,FIELD_DATA FROM FIELDS ORDER BY ROW";
sqlite3_stmt *statement;
int result = sqlite3_prepare_v2(database,[query UTF8String],-1,&statement,nil);
while (sqlite3_step(statement) == SQLITE_row) {
    int rowNum = sqlite3_clumn_int(statement,0);
    char *rowData = (char *)sqlite3_clumn_text(statement,1);
    NSString *fieldValue = [[NSString alloc] initWithUTF8String:rowData];
    
}
sqlite3_finalize(statement);
