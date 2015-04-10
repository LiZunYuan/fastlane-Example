//
//  MIDatabase.m
//  MISpring
//
//  Created by Mac Chow on 13-3-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIDatabaseUtil.h"
#import "ValueInjector.h"

static MIDatabaseUtil * _globalDBUtil = nil;

@implementation MIDatabaseUtil

@synthesize dbPath;

#pragma mark - Singleton method

- (id)init {
    self = [super init];
    if (self) {
        self.dbPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"mizhe.local.sqlite"];
//        NSLog(@"dbpath=%@", self.dbPath);
        FMDatabaseQueue * queue = [self getConnection];
        [queue inDatabase: ^(FMDatabase *db) {
            FMResultSet * rs = [db executeQuery: @"select count(*) from sqlite_master where type='table' and name=?;", @"mall"];
            [rs next];
            BOOL dbExists = [rs boolForColumnIndex:0];
            [rs close];
            if (!dbExists) {
                NSString * sql =
                    @"\
                    CREATE TABLE \"mall\"(\
                    \"mallId\" INTEGER NOT NULL UNIQUE,\
                    \"name\" VARCHAR(20) NOT NULL,\
                    \"seoName\" VARCHAR(20) NOT NULL COLLATE NOCASE,\
                    \"pinyin\" VARCHAR(20) NOT NULL COLLATE NOCASE,\
                    \"mode\" INTEGER NOT NULL,\
                    \"summary\" VARCHAR(2048) NULL,\
                    \"commission\" INTEGER NOT NULL,\
                    \"commissionType\" INTEGER NOT NULL,\
                    \"type\" INTEGER NOT NULL,\
                    \"pos\" INTEGER NOT NULL,\
                    \"cate\" VARCHAR(10) NULL,\
                    \"logo\" VARCHAR(50) NOT NULL,\
                    \"gmtModified\" INTEGER NOT NULL,\
                    PRIMARY KEY (\"mallId\")\
                    )";
                [db executeUpdate: sql];
            }
        }];
        [queue close];
    }
    
    return self;
}

+ (id) allocWithZone:(NSZone*) zone
{
	@synchronized(self) {
		if (_globalDBUtil == nil) {
			_globalDBUtil = [super allocWithZone:zone];  // assignment and return on first allocation
			return _globalDBUtil;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone*) zone
{
	return _globalDBUtil;
}

+ (MIDatabaseUtil *)globalDBUtil {
    if(!_globalDBUtil) {
        _globalDBUtil = [[MIDatabaseUtil alloc] init];
    }
    
    return _globalDBUtil;
}

- (FMDatabaseQueue *) getConnection {
    return [FMDatabaseQueue databaseQueueWithPath: self.dbPath];
}

#pragma mark - Query Methods
- (NSMutableArray *) selectQueryFrom:(NSString *) table Fields:(NSArray *) fields Where:(NSString *)where OrderBy:(NSString *)orderby IsDesc:(BOOL *)desc Limit:(NSString *)limit {
    NSMutableArray* resultSet = [[NSMutableArray alloc] init];
    FMDatabaseQueue * queue = [self getConnection];
    [queue inDatabase: ^(FMDatabase *db) {
        NSString *fieldString = [fields componentsJoinedByString:@","];
        NSString * sql = [NSString stringWithFormat: @"select %@ from %@", fieldString, table];
        if (where) {
            sql = [NSString stringWithFormat: @"%@ where %@", sql, where];
        }
        if (orderby) {
            sql = [NSString stringWithFormat: @"%@ order by %@", sql, orderby];
        }
        if (desc) {
            sql = [NSString stringWithFormat: @"%@ desc", sql];
        }
        if (limit) {
            sql = [NSString stringWithFormat: @"%@ limit %@", sql, limit];
        }
        MILog(@"%@", sql);
        FMResultSet *rs = [db executeQuery: sql];
        
        NSBundle *bundle = [NSBundle mainBundle];
        Class result_class = [bundle classNamed: [NSString stringWithFormat:@"MI%@Model", [table capitalizedString]]];
        while ([rs next]) {
            NSDictionary * result = [rs resultDictionary];
            id anInstance = [[result_class alloc] init];
            [anInstance injectFromObject: result];
            [resultSet addObject: anInstance];
        }
        
        [rs close];
        
    }];
    
    return resultSet;
}

#pragma mark - Update methods
//- (BOOL) insert : (FMDatabaseQueue *) queue : (NSString *) table : (NSObject *) model {
//    
//    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        
//    }];
//    
//    return YES;
//}

@end
