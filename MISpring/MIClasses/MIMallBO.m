//
//  MIMallstaff.m
//  MISpring
//
//  Created by Mac Chow on 13-4-11.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMallBO.h"
#import "MIDatabaseUtil.h"
#import "FMDatabase.h"
#import "MIMallReloadRequest.h"
#import "MIMallReloadModel.h"
#import "ValueInjector.h"

static MIMallBO * _staff;

@implementation MIMallBO
@synthesize ioQueue = _ioQueue;

- (id) init
{
    self = [super init];
    if (self) {
        _ioQueue = dispatch_queue_create("com.mizhe.databaseio", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

+ (MIMallBO *) getInstance
{
    if (!_staff) {
        _staff = [[MIMallBO alloc] init];
    }
    return _staff;
}

+ (id) allocWithZone:(NSZone*) zone
{
	@synchronized(self) {
		if (_staff == nil) {
			_staff = [super allocWithZone:zone];  // assignment and return on first allocation
			return _staff;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone*) zone
{
	return _staff;
}

-(void) dealloc
{
    dispatch_release(_ioQueue);
}

- (void) getMallsWithForceReload:(BOOL)reload WithMobileOnly:(BOOL)mobileOnly WithAtLeast:(NSUInteger)atleast callback:(void (^)(NSArray * malls)) cb
{
    NSDictionary * param = @{
                             @"forceReload": [[NSNumber alloc] initWithBool:reload],
                             @"mobileOnly": [[NSNumber alloc] initWithBool:mobileOnly],
                             @"atleast": [[NSNumber alloc] initWithInteger:atleast],
                             @"callback": cb
                            };
    dispatch_async(self.ioQueue, ^{
        [self getMallsThread:param];
    });
}

- (void) getMallById: (NSUInteger) mallId withForceReload:(BOOL)reload callback:(void (^)(MIMallModel *mall)) cb
{
    return;
}

- (void) getMallsWithMobileOnly:(BOOL)mobileOnly AtLeast:(NSUInteger)atleast callback:(void (^)(NSArray * malls)) cb
{
    dispatch_async(self.ioQueue, ^{
        MIDatabaseUtil * util = [MIDatabaseUtil globalDBUtil];
        
        NSMutableArray *malls;
        if (mobileOnly) {
            malls = [util selectQueryFrom:@"mall" Fields: @[@"*"] Where:@"\"type\"=1" OrderBy:@"pos" IsDesc:YES Limit:[NSString stringWithFormat:@"%d", atleast]];
            if ([malls count] < atleast) {
                NSArray * mallsplus = [util selectQueryFrom: @"mall" Fields:@[@"*"] Where:@"\"type\"=0" OrderBy:@"pos" IsDesc:YES Limit:[NSString stringWithFormat: @"%d", atleast - [malls count]]];
                NSMutableArray * tmp = [malls mutableCopy];
                for (MIMallModel * mall in mallsplus) {
                    [tmp addObject: mall];
                }
                malls = [NSMutableArray arrayWithArray: tmp];
            }
        } else {
            malls = [util selectQueryFrom:@"mall" Fields:@[@"*"] Where:Nil OrderBy:@"pos" IsDesc:YES Limit:Nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{ cb(malls); });
    });
}

- (void) getMallsThread: (NSDictionary *) param
{
    BOOL forceReload = [(NSNumber *)[param objectForKey: @"forceReload"] boolValue];
    BOOL mobileOnly = [(NSNumber *)[param objectForKey: @"mobileOnly"] boolValue];
    NSUInteger atleast = [(NSNumber *)[param objectForKey: @"atleast"] integerValue];
    void (^cb) (NSArray *);
    cb = [param objectForKey: @"callback"];
    
    MIDatabaseUtil * util = [MIDatabaseUtil globalDBUtil];
    FMDatabaseQueue * queue = [util getConnection];
    __block NSNumber * last = [[NSNumber alloc] initWithInt:0];
    __block NSNumber * currentCount = [[NSNumber alloc] initWithInt:0];
    
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery: @"select max(gmtModified) from mall"];
        if ([rs next]) {
            last = [[NSNumber alloc] initWithInt: [rs intForColumnIndex:0]];
        }
        [rs close];
        if (!mobileOnly) {
            rs = [db executeQuery: @"select count(*) from mall"];
            [rs next];
            currentCount = [[NSNumber alloc] initWithInt: [rs intForColumnIndex:0]];
            [rs close];
        }
    }];
    
    if ([[NSDate date] timeIntervalSince1970] - [last intValue] > 86400) {
        //更新周期为1天
        forceReload = YES;
    }
    if (!mobileOnly && [currentCount intValue] < 100) {
        forceReload = YES;
        last = [[NSNumber alloc] initWithInteger: 0];
    }
    
    if (forceReload) {
        __weak typeof(self) weakSelf = self;

        MIMallReloadRequest * req = [[MIMallReloadRequest alloc] init];
        [req setLast: last];
        [req setType: [[NSNumber alloc] initWithBool: mobileOnly]];
        req.onCompletion = ^(MIMallReloadModel* model) {
            MILog(@"fetch new malls count: %@", model.count);
            
            [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                if (model.count > 0) {
                    for (MIMallModel* mall in model.malls) {
                        NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithObject: mall];
                        NSString * sql = @"\
                            REPLACE INTO \"mall\" (\
                            mallId, name, seoName, summary, mode, logo, commission,\
                            commissionType, type, pos, gmtModified, cate, pinyin\
                            ) values (\
                            :mallId, :name, :seoName, :summary, :mode, :logo, :commission,\
                            :commissionType, :type, :pos, :gmtModified, :cate, :pinyin\
                        )";
                        [db executeUpdate:sql withParameterDictionary:param];
                    }
                }
                
            }];
            
            [weakSelf getMallsWithMobileOnly:mobileOnly AtLeast:atleast callback:cb];
        };
        
        req.onError = ^(MKNetworkOperation* completedOperation, NSError *error) {
            [weakSelf getMallsWithMobileOnly:mobileOnly AtLeast:atleast callback:cb];
        };
        
        [req sendQuery];
        
        if (currentCount.intValue > 100) {
            [weakSelf getMallsWithMobileOnly:mobileOnly AtLeast:atleast callback:cb];
        }
        
    } else {
        [self getMallsWithMobileOnly:mobileOnly AtLeast:atleast callback:cb];
    }
}

@end
