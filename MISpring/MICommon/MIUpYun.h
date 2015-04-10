//
//  MIUpYun.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-16.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MKNetworkEngine.h"
/**
 *	@brief 默认空间名（必填项），可在init之后修改bucket的值来更改
 */

//#error 必填项
#define DEFAULT_BUCKET @"mzimg"
/**
 *	@brief	默认表单API功能密钥 （必填项），可在init之后修改passcode的值来更改
 */
//#error 必填项
//#define DEFAULT_PASSCODE @""

/**
 *	@brief	默认当前上传授权的过期时间，单位为“秒” （必填项，较大文件需要较长时间)，可在init之后修改expiresIn的值来更改
 */
//#error 必填项
#define DEFAULT_EXPIRES_IN 1800

#define API_DOMAIN @"http://v0.api.upyun.com/"

typedef void(^SUCCESS_BLOCK)(id result);
typedef void(^FAIL_BLOCK)(NSError * error);
typedef void(^PROGRESS_BLOCK)(CGFloat percent,long long requestDidSendBytes);

@interface MIUpYun : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic, copy) NSString *bucket;

@property (nonatomic, assign) NSTimeInterval expiresIn;

@property (nonatomic, copy) NSMutableDictionary *params;

@property (nonatomic, copy) NSString *passcode;

@property (nonatomic, copy) SUCCESS_BLOCK   successBlocker;

@property (nonatomic, copy) FAIL_BLOCK      failBlocker;

@property (nonatomic, copy) PROGRESS_BLOCK  progressBlocker;

+ (MIUpYun *) getInstance;

- (void)modifyHeadImage;

/**
 *	@brief	上传图片接口
 *
 *	@param 	image 	图片
 *	@param 	savekey 	savekey
 */
- (void) uploadImage:(UIImage *)image savekey:(NSString *)savekey;


@end
