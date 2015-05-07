#import "DatabaseOperation.h"
#import <pthread.h>

@interface DatabaseOperation (){
    pthread_rwlock_t rwlock;
}
@end


@implementation DatabaseOperation

@synthesize m_sql;
@synthesize m_dbName;

- (id) initWithDbName:(NSString*)dbname

{
    self = [super init];
    if (self != nil) {
        if ([self openOrCreateDatabase:dbname]) {
           // [self closeDatabase];
            if(pthread_rwlock_init(&rwlock, NULL)) {
                return nil;
            }
        }
    }
    return self;
}

- (id) init

{
    NSAssert(0,@"Never Use this.Please Call Use initWithDbName:(NSString*)");
    return nil;
}


- (void) dealloc
{
    self.m_sql = nil;
    self.m_dbName =nil;
}


//-------------------创建数据库-------------------------

-(BOOL)openOrCreateDatabase:(NSString*)dbName

{
    self.m_dbName = dbName;

    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/"];
    if(sqlite3_open([[documentsDirectory stringByAppendingPathComponent:dbName]UTF8String],&m_sql) !=SQLITE_OK)
    {
        NSLog(@"创建数据库失败");
        return    NO;
    }
    return YES;
}
//------------------创建表----------------------
-(BOOL)exec:(NSString*)sqlstr
{
    char *errorMsg;
    if (sqlite3_exec (self.m_sql, [sqlstr UTF8String],NULL,NULL, &errorMsg) != SQLITE_OK)
    {
        SHLog(@"exec:%s",errorMsg);
        return NO;
    }
    //[self closeDatabase];
    return YES;

}

-(BOOL)createTable:(NSString*)sqlCreateTable

{
//    if (![self openOrCreateDatabase:self.m_dbName]) {
//        return NO;
//    }
    char *errorMsg;
    
    if (sqlite3_exec (self.m_sql, [sqlCreateTable UTF8String],NULL,NULL, &errorMsg) != SQLITE_OK)
        
    {
        NSLog(@"创建数据表失败:%s",errorMsg);
        return NO;
    }
    //[self closeDatabase];
    return YES;
    
}


//----------------------关闭数据库-----------------

//-(void)closeDatabase
//{
//    //sqlite3_close(self.m_sql);
//}

//------------------insert-------------------

-(BOOL)insertTable:(NSString*)sqlInsert

{
//    if (![self openOrCreateDatabase:self.m_dbName]) {
//        return NO;
//    }
    char* errorMsg = NULL;
    if(sqlite3_exec(self.m_sql, [sqlInsert UTF8String],0,NULL, &errorMsg) ==SQLITE_OK)
    {
        //[self closeDatabase];
        return YES;
    }
    
    else {
        printf("更新表失败:%s",errorMsg);
        //[self closeDatabase];
        return NO;
    }

    return YES;
    
}
//--------------updata-------------

-(BOOL)updataTable:(NSString*)sqlUpdata{
    
//    if (![self openOrCreateDatabase:self.m_dbName]) {
//        return NO;
//    }
    char *errorMsg;
    if (sqlite3_exec (self.m_sql, [sqlUpdata UTF8String],0,NULL, &errorMsg) !=SQLITE_OK)
    {
        //[self closeDatabase];
        return YES;
        
    }else {
        return NO;
    }
    return YES;
    
}


//--------------select---------------------

-(NSArray*)querryTable:(NSString*)sqlQuerry

{

    int row = 0;
    int column = 0;
    char*    errorMsg = NULL;
    char**    dbResult = NULL;
    NSMutableArray*    array = [[NSMutableArray alloc]init];
    if(sqlite3_get_table(m_sql, [sqlQuerry UTF8String], &dbResult, &row,&column,&errorMsg ) ==SQLITE_OK)
    {
        if (0 == row) {
            //[self closeDatabase];
            return nil;
        }
        int index = column;
        for(int i =0; i < row ; i++ ) {
            NSMutableDictionary*    dic = [[NSMutableDictionary alloc]init];
            for(int j =0 ; j < column; j++ ) {
                if (dbResult[index]) {
                    NSString*    value = [[NSString alloc]initWithUTF8String:dbResult[index]];
                    NSString*    key = [[NSString alloc]initWithUTF8String:dbResult[j]];
                    [dic setObject:value forKey:key];
                }
                index ++;           
            }
            [array addObject:dic];            
        }   
    }else {
        printf("%s",errorMsg);
        //[self closeDatabase];
        return nil;
    }
    //[self closeDatabase];
    return array;
    
}

- (BOOL)oprationTableByStms:(NSString *)sqlStr args:(NSArray * )args
{
    if(pthread_rwlock_rdlock(&rwlock))
		return NO;
	const char *sql = [sqlStr UTF8String];
    sqlite3_stmt *stmt = NULL;
    if(sqlite3_prepare_v2(self.m_sql, sql, -1, &stmt, NULL) != SQLITE_OK) {
		pthread_rwlock_unlock(&rwlock);
		return NO;
	}
    for (int i = 0 ;i<args.count ;i++) {
        NSObject* obj = [args objectAtIndex:i];
        if([[obj class]isSubclassOfClass:[NSNumber class]]){
            sqlite3_bind_double(stmt, i+1, [(NSNumber*)obj floatValue]);
            continue;
        }else if ( [[obj class] isSubclassOfClass:[NSData class]]){
            sqlite3_bind_blob(stmt, i+1, [(NSData*)obj bytes], [(NSData*)obj length], NULL);
            continue;
        }else if ( [[obj class] isSubclassOfClass:[NSString class]]){
            sqlite3_bind_text(stmt, i+1, [(NSString*)obj UTF8String], [(NSString*)obj length], NULL);
            continue;
        }
    }
   	
	BOOL result = (SQLITE_DONE == sqlite3_step(stmt));
	sqlite3_finalize(stmt);
    pthread_rwlock_unlock(&rwlock);
    return result;
}
- (NSArray * )fetchRowByStms:(NSString *)sqlStr whereargs:(NSArray * )args selectargs:(NSArray * )type
{
    NSString *sql = sqlStr;
	if(pthread_rwlock_rdlock(&rwlock))
		return nil;
	sqlite3_stmt *stmt = NULL;
	if(sqlite3_prepare_v2(self.m_sql, [sql UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
		pthread_rwlock_unlock(&rwlock);
		return nil;
	}
    for (int i = 0 ;i<args.count ;i++) {
        NSObject* obj = [args objectAtIndex:i];
        if([[obj class]isSubclassOfClass:[NSNumber class]]){
            sqlite3_bind_double(stmt, i+1, [(NSNumber*)obj floatValue]);
            continue;
        }else if ( [[obj class] isSubclassOfClass:[NSData class]]){
            sqlite3_bind_blob(stmt, i+1, [(NSData*)obj bytes], [(NSData*)obj length], NULL);
            continue;
        }else if ( [[obj class] isSubclassOfClass:[NSString class]]){
            sqlite3_bind_text(stmt, i+1, [(NSString*)obj UTF8String], [(NSString*)obj length], NULL);
            continue;
        }
    }
    
    NSMutableArray * array = nil;
    if(SQLITE_ROW == sqlite3_step(stmt)) {
        array = [[NSMutableArray alloc]init];
        for (int i = 0 ;i<type.count ;i++) {
            NSObject* obj = [type objectAtIndex:i];
            if([[obj class]isSubclassOfClass:[NSNumber class]]){
                NSNumber * number = [[NSNumber alloc]initWithDouble:sqlite3_column_double(stmt, i)];
                [array addObject:number];
                continue;
            }else if ( [[obj class] isSubclassOfClass:[NSData class]]){
                NSData * data = [[NSData alloc] initWithBytes:sqlite3_column_blob(stmt, i) length:sqlite3_column_bytes(stmt, i)];
                [array addObject:data];
                continue;
            }else if ( [[obj class] isSubclassOfClass:[NSString class]]){
                NSString* str = [[NSString alloc] initWithUTF8String: sqlite3_column_text(stmt, i)];
                [array addObject:str];
                continue;
            }
        }
    }
    pthread_rwlock_unlock(&rwlock);
    return array;

}
- (NSArray * )fetchRowByStms:(NSString *)sqlStr args:(NSArray * )type
{
    NSString *sql = sqlStr;
	if(pthread_rwlock_rdlock(&rwlock))
		return nil;
	sqlite3_stmt *stmt = NULL;
	if(sqlite3_prepare_v2(self.m_sql, [sql UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
		pthread_rwlock_unlock(&rwlock);
		return nil;
	}
    NSMutableArray * array = nil;
    if(SQLITE_ROW == sqlite3_step(stmt)) {
        array = [[NSMutableArray alloc]init];
        for (int i = 0 ;i<type.count ;i++) {
            NSObject* obj = [type objectAtIndex:i];
            if([[obj class]isSubclassOfClass:[NSNumber class]]){
                NSNumber * number = [[NSNumber alloc]initWithDouble:sqlite3_column_double(stmt, i)];
                [array addObject:number];
                break;
            }else if ( [[obj class] isSubclassOfClass:[NSData class]]){
                NSData * data = [[NSData alloc] initWithBytes:sqlite3_column_blob(stmt, i) length:sqlite3_column_bytes(stmt, i)];
                [array addObject:data];
                break;
            }else if ( [[obj class] isSubclassOfClass:[NSString class]]){
                NSString* str = [[NSString alloc] initWithUTF8String: sqlite3_column_text(stmt, i)];
                [array addObject:str];
                break;
            }
        }
    }
    pthread_rwlock_unlock(&rwlock);
    return array;
}

//- (NSData *)fetch:(NSString *)url timestamp:(time_t *)ti {
//	NSString *sql = [NSString stringWithFormat:@"SELECT DATA, TIME FROM %@ WHERE URL = ?;", @"cache"];
//	if(pthread_rwlock_rdlock(&rwlock))
//		return nil;
//	sqlite3_stmt *stmt = NULL;
//	NSData *data = nil;
//	if(sqlite3_prepare_v2(self.m_sql, [sql UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
//		pthread_rwlock_unlock(&rwlock);
//		return nil;
//	}
//	
//	sqlite3_bind_text(stmt, 1, [url UTF8String], [url length], NULL);
//	
//	if(SQLITE_ROW == sqlite3_step(stmt)) {
//		time_t t = sqlite3_column_int(stmt, 1);
//		if(ti) {
//			*ti = t;
//		}
//        data = [[NSData alloc] initWithBytes:sqlite3_column_blob(stmt, 0) length:sqlite3_column_bytes(stmt, 0)];
//	}
//	
//	sqlite3_finalize(stmt);
//	pthread_rwlock_unlock(&rwlock);
//	return data;
//}
//----------------------select--------------------

int processData(void* arrayResult,int columnCount,char** columnValue,char** columnName)
{
    int i;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    for( i = 0 ; i < columnCount; i ++ )
    {
        if (columnValue[i]) {
            NSString* key = [[NSString alloc]initWithUTF8String:columnName[i]];
            NSString* value = [[NSString alloc]initWithUTF8String:columnValue[i]];
            [dic setObject:value forKey:key];
        }  
    }
    [(__bridge NSMutableArray*)arrayResult addObject:dic];
    return 0;
}

//-(void) insertData:(id)insertValue{
//
//    NSLog(@"Insert Values is :%@",insertValue);
//
//    char *errorMsg;
//  
//    NSString *insertSql= [NSString stringWithFormat:@"insert into %@ values (%d)",_tableName,[insertValue intValue]];
//
//    if (sqlite3_exec(database, [insertSql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK) {
//     
//    }else {
//    
//        NSLog(@"Insert Failure %s",errorMsg);
//  
//    }
//
//}

//-(void) deleteData:(id)deleteValue{
//    074
//    NSLog(@"Delete Values is :%@",deleteValue);
//    075
//    char *errorMsg;
//    076
//    NSString *deleteSql= [NSString stringWithFormat:@"delete from %@ where mapIndex = %d",_tableName,[deleteValue intValue]];
//    077
//    
//    078
//    if (sqlite3_exec(database, [deleteSql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK) {
//        079
//        NSLog(@"Delete Success.");
//        080
//    }else {
//        081
//        NSLog(@"Delete Failure %s",errorMsg);
//        082
//    }
//    083
//}


//---------------------select-----------------------

-(NSArray*)querryTableByCallBack:(NSString*)sqlQuerry

{
//    if (![self openOrCreateDatabase:self.m_dbName]) {
//        return nil;
//    }
    char*    errorMsg = NULL;
    NSMutableArray* arrayResult = [[NSMutableArray alloc]init];
    if (sqlite3_exec(self.m_sql,[sqlQuerry UTF8String],processData,(__bridge void*)arrayResult,&errorMsg) !=SQLITE_OK) {
        printf("查询出错:%s",errorMsg);
    }
   //[self closeDatabase];
    return arrayResult ;
    
}
@end