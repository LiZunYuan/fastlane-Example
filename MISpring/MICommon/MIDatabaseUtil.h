//
//  MIDatabase.h
//  MISpring
//
//  Created by Mac Chow on 13-3-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface MIDatabaseUtil : NSObject

@property (nonatomic, retain) NSString * dbPath;

+ (MIDatabaseUtil* ) globalDBUtil;
- (FMDatabaseQueue *) getConnection;

- (NSMutableArray *) selectQueryFrom:(NSString *) table Fields:(NSArray *) fields Where:(NSString *)where OrderBy:(NSString *)orderby IsDesc:(BOOL *)desc Limit:(NSString *)limit;

//- (BOOL) insert : (NSString *) table : (NSObject *) data;
@end
