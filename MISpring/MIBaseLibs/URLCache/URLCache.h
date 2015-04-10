//
//  URLCache.h
//  URLCacheTest
//
//  Created by Jin Luo on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface URLCache : NSURLCache {
    NSMutableDictionary *cachedResponses;
    NSMutableDictionary *responsesInfo;
}

@property (nonatomic, retain) NSMutableDictionary *cachedResponses;

@end
