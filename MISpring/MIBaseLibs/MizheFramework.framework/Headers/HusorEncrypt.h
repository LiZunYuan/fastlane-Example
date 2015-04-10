//
//  HusorEncrypt.h
//  BeibeiFramework
//
//  Created by weihao on 14-12-6.
//  Copyright (c) 2014年 weihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HusorEncrypt : NSObject

-(NSInteger)getKeyId;

-(NSString *)desEncrypt:(NSString *)str;
-(NSString *)desDecrypt:(NSString *)str;

-(NSString *)genSignWithDict:(NSDictionary *)params;

-(void)proccessResp:(NSHTTPURLResponse *)response;

+ (instancetype)getInstance;

@end
