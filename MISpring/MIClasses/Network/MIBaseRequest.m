//
//  MIBaseRequest.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-29.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <Foundation/NSObject.h>
#import "MIBaseRequest.h"
#import "MIConfig.h"
#import "MIError.h"
#import "MizheFramework/HusorEncrypt.h"

@implementation MIBaseRequest

@synthesize operation = _operation;
@synthesize method = _method;
@synthesize fields = _fields;
@synthesize onCompletion = _onCompletion;
@synthesize onError = _onError;
@synthesize autoShowError = _autoShowError;

-(id)init
{
    if(self = [super init])
    {
        _operation = nil;
        self.autoShowError = YES;
        self.fields = [[NSMutableDictionary alloc] init];
        self.networkCache = [MINetworkCache sharedNetworkCache];
    }
    
    return self;
}

- (NSString *) getType
{
    return nil;
}

- (NSString *) getMethod
{
    return nil;
}

- (NSString *) getStaticURL
{
    return nil;
}

- (NSString *) modelName
{
    if (_modelName) {
        return _modelName;
    }
    
    if (_method == nil) {
        return nil;
    }
    
    NSString *methodName = [[_method capitalizedString] stringByReplacingOccurrencesOfString:@"." withString:@""];
    methodName = [methodName stringByReplacingOccurrencesOfString:@"Mizhe" withString:@""];
    NSString *modelName = [NSString stringWithFormat:@"MI%@Model",methodName];
    return modelName;
}

- (BOOL) getForceReload
{
    return NO;
}

-(void)cancelRequest
{
    if(!_operation)
        return;
    
    [_operation cancel];
    _operation = nil;
}

-(void)sendQuery
{
    _type = [self getType];
    _method = [self getMethod];
    MKNetworkOperation* operation;
    if (_type && [_type isEqualToString:@"static"]) {
        _staticURL = [[self getStaticURL] urlEncoder];
        operation = [[MKNetworkOperation alloc] initWithURLString:_staticURL params:nil httpMethod:@"GET"];
        operation.postDictionary = self.fields;
        NSNumber *page = [self.fields objectForKey:@"page"];
        if ((page == nil || page.integerValue == 1) && !([self getForceReload] == YES || !self.onCompletion)) {
            [self cachedForOperation:operation];
        } else {
            [self enqueueOperation:operation cache:nil];
        }
    } else {
        
        //设置session key
        NSString *sessionKey = [MIMainUser getInstance].sessionKey;
        if (sessionKey != nil) {
            [self.fields setObject:sessionKey forKey:@"session"];
        }
        
        // 设置时间戳
        NSString * ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
        [self.fields setObject:ts forKey:@"timestamp"];
        
        // 设置方法
        [self.fields setObject:_method forKey:@"method"];
        
        // 设置设备信息
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[MIConfig getClientInfo] options:NSJSONWritingPrettyPrinted error:nil];
        if (nil != jsonData) {
            NSString *clientInfo = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [self.fields setObject:clientInfo forKey:@"client_info"];
        }
        
        // signatureƒ
        [self.fields removeObjectForKey:@"sign"];
        NSString * signature = [MIUtility getSignWithDictionary:self.fields];
        [self.fields setObject:signature forKey:@"sign"];
        
        // 发送报文
        operation = [[MKNetworkOperation alloc] initWithURLString:[MIConfig globalConfig].apiURL params:self.fields httpMethod:@"GET"];
        [self enqueueOperation:operation cache:nil];
    }
}

- (void)enqueueOperation:(MKNetworkOperation*) operation cache:(id)model
{
    if (model) {
        self.onCompletion(model);
    }
    
#ifdef MILog_DEBUG
    [operation addHeaders:@{@"Cookie":@"HX-BETA=1"}];  //预发布环境下使用cookie
#endif
    
    [operation addCompletionHandler:[self completionHandler] errorHandler:[self errorHandler]];
    [self enqueueOperation:operation];
    _operation = operation;
}

- (void)cachedForOperation:(MKNetworkOperation*) operation
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id dataModel = nil;
        NSData *cacheData = [self.networkCache cachedDataForOperation:operation];
        if(cacheData)
        {
            id responseObject = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers error:nil];
            if (responseObject) {
                dataModel = [MIUtility convertDisctionary2Object: responseObject className: self.modelName];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self enqueueOperation:operation cache:dataModel];
        });
    });
}

-(MKNKResponseBlock)completionHandler
{
    __weak typeof(self) weakSelf = self;
    MKNKResponseBlock block = ^(MKNetworkOperation *completedOperation) {
        MILog(@"operation = %@", _operation);

        _operation = nil;
        NSData* data = completedOperation.responseData;
        if([data length] <= 0)
        {
            MIError* error = [MIError errorWithCode:1 errorMessage:@"系统服务错误，请稍候重试"];
            [error showHUD];
            if(weakSelf.onError)
                weakSelf.onError(completedOperation, error);
            MILog(@"completedOperation.responseData 返回数据为空");
            return ;
        }

        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        MILog(@"response = %@", responseObject);
        if(nil == responseObject)
        {
            MIError* error = [MIError errorWithCode:1 errorMessage:@"系统服务错误，请稍候重试"];
            [error showHUD];
            if(self.onError)
                self.onError(completedOperation, error);
            MILog(@"JSONObjectWithData 失败");
            return ;
        }
        
        NSDictionary* dics = (NSDictionary*)responseObject;
        if([dics objectForKey:@"err_code"])
        {
            // session key失效的时候提示重新登录。errCode 2为session失效，100为用户不存在或禁用
            MIError *error = [MIError errorWithRestInfo:responseObject];
            NSString* code = [dics objectForKey:@"err_code"];
            if([MIError isNeedLoginAgainError:[code intValue]]){
                [[NSNotificationCenter defaultCenter] postNotificationName:MiNotificationShowAlertLogin object:[NSNumber numberWithInt:[code intValue]]];
            } else {
                [error showHUD];
            }

            if(self.onError)
                self.onError(completedOperation, error);
            return;
        }
        
        NSHTTPURLResponse *response = [completedOperation valueForKey:@"response"];
        if (response) {
            [[HusorEncrypt getInstance] proccessResp:response];
        }
        
        if(self.onCompletion)
        {
            id dataModel = [MIUtility convertDisctionary2Object: dics className: self.modelName];
            self.onCompletion(dataModel);
            if (_type && [_type isEqualToString:@"static"] && [self getForceReload] != YES) {
                NSNumber *page = [completedOperation.postDictionary objectForKey:@"page"];
                if (page == nil || page.integerValue == 1) {
                    [self.networkCache saveCacheData:data forOperation:completedOperation];
                }
            }
        }
    };
    
    return [block copy];
}

-(MKNKResponseErrorBlock)errorHandler
{
    __weak typeof(self) weakSelf = self;
    MKNKResponseErrorBlock block = ^(MKNetworkOperation* completedOperation, NSError *error) {
        MIError *rcError = [MIError errorWithNSError:error];
        [rcError showHUD];
        MILog(@"operation = %@", _operation);

        if(weakSelf.onError)
            weakSelf.onError(completedOperation,rcError);
        _operation = nil;
    };
    
    return [block copy];
}

@end
