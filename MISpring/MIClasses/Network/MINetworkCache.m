//
//  MINetworkCache.m
//  BeiBeiAPP
//
//  Created by 徐 裕健 on 14/8/14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MINetworkCache.h"

static const NSInteger kDefaultMaxCacheAge = 60 * 60 * 24 * 3; // 3 days

@interface MINetworkCache ()

@property (strong, nonatomic) NSCache *memCache;
@property (strong, nonatomic) NSString *diskCachePath;
@property (strong, nonatomic) dispatch_queue_t ioQueue;

@end

@implementation MINetworkCache

+ (MINetworkCache *)sharedNetworkCache
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{instance = self.new;});
    return instance;
}

- (id)init
{
    return [self initWithNamespace:@"default"];
}

- (id)initWithNamespace:(NSString *)ns
{
    if ((self = [super init]))
    {
        NSString *fullNamespace = [@"com.mizhe.spring.NetworkCache." stringByAppendingString:ns];
        
        // Create IO serial queue
        _ioQueue = dispatch_queue_create("com.mizhe.spring.NetworkCache", DISPATCH_QUEUE_SERIAL);
        
        // Init default values
        _maxCacheAge = kDefaultMaxCacheAge;
        
        // Init the memory cache
        _memCache = [[NSCache alloc] init];
        _memCache.name = fullNamespace;
        
        // Init the disk cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
        
        // Subscribe to app events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanDisk)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SDDispatchQueueRelease(_ioQueue);
}
- (NSString*) uniqueIdentifierForOperation:(MKNetworkOperation*) operation {
    
    NSMutableString *filename = [NSMutableString stringWithFormat:@"GET %@", operation.url];
    return [filename md5];
}
- (void) saveCacheData:(NSData*) data forOperation:(MKNetworkOperation*) operation
{
    dispatch_async(self.ioQueue, ^{
        
        NSString* cacheDataKey = [self uniqueIdentifierForOperation:operation];
        [self.memCache setObject:data forKey:cacheDataKey cost:data.length];
        
        // Can't use defaultManager another thread
        NSFileManager *fileManager = NSFileManager.new;
        
        if (![fileManager fileExistsAtPath:self.diskCachePath])
        {
            [fileManager createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
        [fileManager createFileAtPath:[self.diskCachePath stringByAppendingPathComponent:cacheDataKey] contents:data attributes:nil];
    });
}

- (NSData*) cachedDataForOperation:(MKNetworkOperation*) operation {
    
    NSString* cacheDataKey = [self uniqueIdentifierForOperation:operation];
    NSData *cachedData = [self.memCache objectForKey:cacheDataKey];
    if(cachedData) return cachedData;
    
    NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:[operation uniqueIdentifier]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        cachedData = [NSData dataWithContentsOfFile:filePath];
        [self.memCache setObject:cachedData forKey:cacheDataKey cost:cachedData.length];
        return cachedData;
    }
    
    return nil;
}

- (void)clearDisk
{
    [self.memCache removeAllObjects];
    dispatch_async(self.ioQueue, ^
                   {
                       [[NSFileManager defaultManager] removeItemAtPath:self.diskCachePath error:nil];
                       [[NSFileManager defaultManager] createDirectoryAtPath:self.diskCachePath
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:NULL];
                   });
}

- (void)clearMemory
{
    [self.memCache removeAllObjects];
}

- (void)cleanDisk
{
    dispatch_async(self.ioQueue, ^
                   {
                       NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-self.maxCacheAge];
                       // convert NSString path to NSURL path
                       NSURL *diskCacheURL = [NSURL fileURLWithPath:self.diskCachePath isDirectory:YES];
                       // build an enumerator by also prefetching file properties we want to read
                       NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:diskCacheURL
                                                                                    includingPropertiesForKeys:@[ NSURLIsDirectoryKey, NSURLContentModificationDateKey ]
                                                                                                       options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                                                  errorHandler:NULL];
                       for (NSURL *fileURL in fileEnumerator)
                       {
                           // skip folder
                           NSNumber *isDirectory;
                           [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
                           if ([isDirectory boolValue])
                           {
                               continue;
                           }
                           
                           // compare file date with the max age
                           NSDate *fileModificationDate;
                           [fileURL getResourceValue:&fileModificationDate forKey:NSURLContentModificationDateKey error:NULL];
                           if ([[fileModificationDate laterDate:expirationDate] isEqualToDate:expirationDate])
                           {
                               [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
                           }
                       }
                   });
}

@end
