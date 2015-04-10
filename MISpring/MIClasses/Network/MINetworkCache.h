//
//  MINetworkCache.h
//  BeiBeiAPP
//
//  Created by 徐 裕健 on 14/8/14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MINetworkCache : NSObject

/**
 * The maximum length of time to keep the data in the cache, in seconds
 */
@property (assign, nonatomic) NSInteger maxCacheAge;

/**
 * Returns global shared cache instance
 *
 * @return MINetworkCache global instance
 */
+ (MINetworkCache *)sharedNetworkCache;

- (void) saveCacheData:(NSData*) data forOperation:(MKNetworkOperation*) operation;
- (NSData*) cachedDataForOperation:(MKNetworkOperation*) operation;
- (void)clearDisk;
- (void)clearMemory;

@end
