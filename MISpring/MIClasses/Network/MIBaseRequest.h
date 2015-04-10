//
//  MIBaseRequest.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-29.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MINetworkCache.h"
#import "MIBlocks.h"

@interface MIBaseRequest : MKNetworkEngine
{
    MKNetworkOperation* _operation;
    NSMutableDictionary* _fields;
    BOOL _autoShowError;
}

/**
 * 请求缓存
 */
@property (strong, nonatomic) MINetworkCache *networkCache;

/**
 * 执行当前请求的操作
 */
@property (nonatomic, readonly) MKNetworkOperation* operation;

/**
 * 请求方式
 */
@property (nonatomic, copy) NSString* type;

/**
 * 请求方法
 */
@property (nonatomic, copy) NSString* method;

/**
 * 请求地址
 */
@property (nonatomic, copy) NSString* staticURL;

/**
 * 返回modelName
 */
@property (nonatomic, copy) NSString* modelName;

/**
 * 请求参数
 */
@property (nonatomic, retain) NSMutableDictionary* fields;

/**
 * 请求完成回调
 */
@property (nonatomic, copy) onCompletionBlock onCompletion;

/**
 * 错误回调
 */
@property (nonatomic, copy) onErrorBlock onError;

/*
 * 是否自动显示错误
 */
@property (nonatomic, assign) BOOL autoShowError;

/*
 * 是否强制刷新数据
 */
@property (nonatomic, assign) BOOL forceReload;

/**
 * 发送请求
 */
-(void)sendQuery;

/**
 * 取消请求
 */
-(void)cancelRequest;


//-(MKNKEncodingBlock)postDataEncodingHandler;

-(MKNKResponseBlock)completionHandler;

-(MKNKResponseErrorBlock)errorHandler;


@end
