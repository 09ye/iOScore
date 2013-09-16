//
//  DatabaseOperation.h
//  Core
//
//  Created by sheely on 13-9-13.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "sqlite3.h"


@interface DatabaseOperation : NSObject {
    
    
    sqlite3 *m_sql;
    
    NSString *m_dbName;
    
}

@property(nonatomic)sqlite3*    m_sql;

@property(nonatomic,retain)NSString*    m_dbName;



-(id)initWithDbName:(NSString*)dbname;


-(BOOL)openOrCreateDatabase:(NSString*)DbName;


-(BOOL)createTable:(NSString*)sqlCreateTable;


-(void)closeDatabase;


-(BOOL)InsertTable:(NSString*)sqlInsert;


-(BOOL)UpdataTable:(NSString*)sqlUpdata;


-(NSArray*)querryTable:(NSString*)sqlQuerry;


-(NSArray*)querryTableByCallBack:(NSString*)sqlQuerry;


-(BOOL)push:(NSData *)data forKey:(NSString *)url;

@end