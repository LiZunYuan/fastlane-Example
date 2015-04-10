//
//  URLCache.m
//  URLCacheTest
//
//  Created by Jin Luo on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "URLCache.h"
#include <CommonCrypto/CommonDigest.h>

@implementation URLCache
@synthesize cachedResponses;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

static NSString *cacheDirectory;

+ (void)initialize {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    cacheDirectory = [paths objectAtIndex:0];
}

- (NSString *)mimeTypeForPath:(NSString *)originalPath
{
	//
	// Current code only substitutes PNG images
	//
    if ([originalPath hasSuffix:@".jpg"]) {
        return @"image/jpeg";
    } else if ([originalPath hasSuffix:@".gif"]) {
        return @"image/gif";
    } else {
        return @"image/png";
    }
}
- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path {
    if (self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path]) {
        cachedResponses = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    
    //我们得先判断是不是GET方法，因为其他方法不应该被缓存。还得判断是不是网络请求，例如http、https和ftp，因为连data协议等本地请求都会跑到这个方法里来…
    if ([request.HTTPMethod compare:@"GET"] != NSOrderedSame) {
        return [super cachedResponseForRequest:request];
    }
    
    NSURL *url = request.URL;
    NSSet *supportSchemes = [NSSet setWithObjects:@"http",@"https",@"ftp", nil];
    if (![supportSchemes containsObject:url.scheme]) {
        return [super cachedResponseForRequest:request];
    }
    
    if (!([url.absoluteString hasSuffix:@".jpg"] || [url.absoluteString hasSuffix:@".png"] || [url.absoluteString hasSuffix:@".gif"])) {
        return [super cachedResponseForRequest:request];
    }
    
    //接着判断是不是已经在cachedResponses里了，这样的话直接拿出来即可：
    NSString *absoluteString = url.absoluteString;
    NSCachedURLResponse *cachedResponse = [cachedResponses objectForKey:absoluteString];
    if (cachedResponse) {
        return cachedResponse;
    }
    
    //再查查磁盘里有没有，如果有的话，说明可以从磁盘获取：
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:absoluteString];
    if (image) {
        [[SDImageCache sharedImageCache] removeImageForKey:absoluteString fromDisk:NO];
        NSData *data = UIImageJPEGRepresentation(image, (CGFloat)0.45);
        
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:request.URL MIMEType:[self mimeTypeForPath:absoluteString] expectedContentLength:data.length textEncodingName:nil];
        cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
        
        [cachedResponses setObject:cachedResponse forKey:absoluteString];
        return cachedResponse;
    }
    
    //这里的难点在于构造NSURLResponse和NSCachedURLResponse，不过对照下文档看看也就清楚了。如前文所说，我们还得把cachedResponse保存到cachedResponses里，避免它被提前释放。
    //接下来就说明缓存不存在了，需要我们自己发起一个请求。可恨的是NSURLResponse不能更改属性，所以还需要手动新建一个NSMutableURLRequest对象：
    NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:request.timeoutInterval];
    newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
    newRequest.HTTPShouldHandleCookies = request.HTTPShouldHandleCookies;
    //实际上NSMutableURLRequest还有一些其他的属性，不过并不太重要，所以我就只复制了这2个。

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:newRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (!error) {
                                   UIImage *image = [UIImage imageWithData:data];
                                   [[SDImageCache sharedImageCache] storeImage:image forKey:absoluteString toDisk:YES];
                                   [[SDImageCache sharedImageCache] removeImageForKey:absoluteString fromDisk:NO];
                                   
                                   // 如果下载没出错的话，我们就能拿到data和response了，于是就能将其保存到磁盘了。
                                   // Add it to our cache dictionary
                                   //
                                   NSData *compressionData = UIImageJPEGRepresentation(image, (CGFloat)0.45);
                                   NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:compressionData];
                                   [cachedResponses setObject:cachedResponse forKey:absoluteString];
                                   image = nil;

                                   [[NSNotificationCenter defaultCenter] postNotificationName:MiNotifyWebViewImageLoadSuccess object:nil userInfo:nil];
                               }
                           }];
    
    //接下来还得将文件信息保存到responsesInfo，并构造一个NSCachedURLResponse。
    //然而这里还有个陷阱，因为直接使用response对象会无效。我稍微研究了一下，发现它其实是个NSHTTPURLResponse对象，可能是它的allHeaderFields属性影响了缓存策略，导致不能重用。
    //不过这难不倒我们，直接像前面那样构造一个NSURLResponse对象就行了，这样就没有allHeaderFields属性了：
    
	//
	// Load the data
	//
    UIImage *defaultImage = [UIImage imageNamed:@"default_avatar_img"];
    NSData *data = UIImageJPEGRepresentation(defaultImage, (CGFloat)1.0);
	
	//
	// Create the cacheable response
	//
	NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[request URL]
                                                         MIMEType:[self mimeTypeForPath:absoluteString]
                                            expectedContentLength:[data length]
                                                 textEncodingName:nil];
	cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
    [cachedResponses setObject:cachedResponse forKey:absoluteString];
	return cachedResponse;
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)request {
    [cachedResponses removeObjectForKey:request.URL.absoluteString];
    [super removeCachedResponseForRequest:request];
}

- (void)removeAllCachedResponses {

    [responsesInfo removeAllObjects];
    [cachedResponses removeAllObjects];
    [super removeAllCachedResponses];
}

@end
