//
//  MIGetTbkClickRequest.m
//  MISpring
//
//  Created by 徐 裕健 on 14-6-1.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIGetTbkClickRequest.h"
#import "MITbkMobileItemsConvertModel.h"
#import "MITbkConvertItemModel.h"
#import "MKNetworkEngine.h"

@implementation MIGetTbkClickRequest
@synthesize tbkItemsConvertRequest;

- (id)initWithTag:(NSString *)tag numiid:(NSString *)iid
{
    if (self = [super init])
    {
        self.tag = tag;
        self.numiid = iid;
    }
    
    return self;
}

- (void)sendQuery
{
    if (!self.tag) {
        self.tag = @"";
    }
    
    if ([MIConfig globalConfig].topTbkApi) {
        NSString * outerCode = [[MIMainUser getInstance].userId stringValue];
        if (outerCode == nil || outerCode.length == 0 || [MIConfig globalConfig].temaiRebate == FALSE) {
            outerCode = @"1";
        }
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"taobao.tbk.mobile.items.convert" forKey:@"method"];
        [params setObject: self.numiid forKey:@"num_iids"];
        [params setObject: @"click_url" forKey:@"fields"];
        [params setObject: [NSString stringWithFormat: @"%@%@", self.tag, outerCode] forKey:@"outer_code"];
        [self callClientTbkItemConvert:params];
    } else {
        __weak typeof(self) weakSelf = self;
        tbkItemsConvertRequest = [[MITbkMobileItemsConvertRequest alloc] init];
        tbkItemsConvertRequest.onCompletion = ^(MITbkMobileItemsConvertModel *model) {
            if (model.success.boolValue) {
                [weakSelf tbkItemsConvertApiCompletion:model];
            } else {
                [weakSelf tbkItemsConvertApiError:nil];
            }
        };
        tbkItemsConvertRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf tbkItemsConvertApiError:error];
        };
        [self.tbkItemsConvertRequest setNumiids:self.numiid];
        [self.tbkItemsConvertRequest setType:self.tag];
        [self.tbkItemsConvertRequest sendQuery];
    }
}

- (void)callClientTbkItemConvert:(NSMutableDictionary *)dict
{
    NSString *appSecretKey = [MIConfig globalConfig].topAppSecretKey;
    NSString *appKey = [MIConfig globalConfig].topAppKey;
    [dict setObject:appKey forKey:@"app_key"];
    //[dict setObject:@"" forKey:@"session_key"];
    [dict setObject:@"json" forKey:@"format"];
    [dict setObject:@"2.0" forKey:@"v"];
    [dict setObject:@"md5" forKey:@"sign_method"];
    [dict setObject:[[NSDate dateWithTimeIntervalSinceNow:0] stringForYyyymmddhhmmss] forKey:@"timestamp"];
    [dict setObject:[self getTaobaoSignWithDictionary:dict secretKey:appSecretKey] forKey:@"sign"];
    
    //配置更新
    _operation = [[MKNetworkOperation alloc] initWithURLString:@"http://gw.api.taobao.com/router/rest" params:dict httpMethod:@"GET"];
    [_operation addCompletionHandler:[self completionHandler] errorHandler:[self errorHandler]];
    [self enqueueOperation:_operation];
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
        MILog(@"%@", dics);
        
        id responseObj = (NSDictionary *)[dics objectForKey:@"tbk_mobile_items_convert_response"];
        if ([[responseObj objectForKey:@"total_results"] intValue] == 1) {
            responseObj = (NSDictionary *)[responseObj objectForKey:@"tbk_items"];
            responseObj = (NSArray *)[responseObj objectForKey:@"tbk_item"];
            if (((NSArray *)responseObj).count > 0) {
                responseObj = (NSDictionary *)[responseObj objectAtIndex:0];
            }
            if (responseObj && self.onCompletionHandler) {
                self.onCompletionHandler([responseObj objectForKey:@"click_url"]);
                return;
            }
        }
        
        if (self.onErrorHandler) {
            self.onErrorHandler();
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
        
        if(weakSelf.onErrorHandler)
            weakSelf.onErrorHandler();
        _operation = nil;
    };
    
    return [block copy];
}

//- (void) taobaokeMobileItemConvertApiResponse:(id)data
//{
//    TopApiResponse *response = (TopApiResponse *)data;
//    id responseObj = [TopIOSClient getResponseObject: response.content];
//    if (responseObj && ![responseObj isKindOfClass: [TopServiceError class]]) {
//        responseObj = (NSDictionary *)[responseObj objectForKey:@"tbk_mobile_items_convert_response"];
//        if ([[responseObj objectForKey:@"total_results"] intValue] == 1) {
//            responseObj = (NSDictionary *)[responseObj objectForKey:@"tbk_items"];
//            responseObj = (NSArray *)[responseObj objectForKey:@"tbk_item"];
//            responseObj = (NSDictionary *)[responseObj objectAtIndex:0];
//            if (responseObj && self.onCompletionHandler) {
//                self.onCompletionHandler([responseObj objectForKey:@"click_url"]);
//                return;
//            }
//        }
//    }
//    
//    if (self.onErrorHandler) {
//        self.onErrorHandler();
//    }
//}

- (void) tbkItemsConvertApiCompletion:(MITbkMobileItemsConvertModel *)model
{
    if (model.tbkConvertItems.count > 0) {
        MITbkConvertItemModel *itemModel = [model.tbkConvertItems objectAtIndex:0];
        if (self.onCompletionHandler) {
            self.onCompletionHandler(itemModel.clickUrl);
        }
    }
}

- (void) tbkItemsConvertApiError:(MIError*) error
{
    MILog(@"tbkItemsConvertApiError");
    if (self.onErrorHandler) {
        self.onErrorHandler();
    }
}

- (void)cancelRequest
{
    if ([tbkItemsConvertRequest.operation isExecuting]) {
        [tbkItemsConvertRequest cancelRequest];
    }
    
    if (_operation && [_operation isExecuting]) {
        [super cancelRequest];
    }
    
//    if (self.topSessionKey) {
//        [self.topClient cancel:self.topSessionKey];
//        self.topSessionKey = nil;
//    }
}

/**
  生成taobao的签名
 */
- (NSString*)getTaobaoSignWithDictionary:(NSDictionary *)params
                         secretKey:(NSString *)secretKey
{
    NSArray * keys = [params allKeys];
    NSArray * sortedKeys = [keys sortedArrayUsingFunction:strCompare context:NULL];
    
    NSMutableString *buffer = [[NSMutableString alloc] initWithString: secretKey];
    for (NSString *key in sortedKeys)
    {
        [buffer appendString:[NSString stringWithFormat:@"%@%@", key, [params objectForKey: key]]];
    }
    [buffer appendString:secretKey];
    NSString * signature = [[buffer md5] uppercaseString];
    return signature;
}


@end
