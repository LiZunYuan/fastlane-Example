//
//  MIUpYun.m
//  MISpring
//
//  Created by 曲俊囡 on 13-12-16.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MIUpYun.h"
#import "MIAppDelegate.h"
#import "MIModifyHeadImageViewController.h"

#define ERROR_DOMAIN @"upyun.com"
#define DATE_STRING(expiresIn) [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] + expiresIn]
#define REQUEST_URL(bucket) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/",API_DOMAIN,bucket]]

#define SUB_SAVE_KEY_FILENAME @"{filename}"

static MIUpYun *_upYunInstance = nil;

@implementation MIUpYun
+ (MIUpYun *) getInstance {
	@synchronized(self) {
		if (_upYunInstance == nil) {
            // 看是否有最近的登录用户Id
            _upYunInstance = [[MIUpYun alloc] init];
		}
	}
    
	return _upYunInstance;
}


+ (id) allocWithZone:(NSZone*) zone {
	@synchronized(self) {
		if (_upYunInstance == nil) {
			_upYunInstance = [super allocWithZone:zone];  // assignment and return on first allocation
			return _upYunInstance;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone*) zone {
	return _upYunInstance;
}

-(id)init
{
    if (self = [super init]) {
        self.bucket = DEFAULT_BUCKET;
        self.expiresIn = DEFAULT_EXPIRES_IN;
        self.passcode = [MIConfig globalConfig].upyunKey;
	}
	return self;
}

- (void)modifyHeadImage
{
    [MobClick event:kUpdateHeadClicks];
    
    MIActionSheet *actionSheet = [[MIActionSheet alloc] initWithTitle:nil];
    [actionSheet addButtonWithTitle:@"拍头像" withBlock:^(NSInteger index) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            if (IOS_VERSION >= 7.0) {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus == AVAuthorizationStatusDenied) {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"未获得授权使用相机" message:@"请在iPhone的“设置->隐私->相机”选项中，允许米折访问你的相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                } else {
                    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
                }
            } else {
                [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
            }
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"米姑娘提示" message:@"该设备没有照相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }];
    
    [actionSheet addButtonWithTitle:@"从相册选择" withBlock:^(NSInteger index) {
        [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"取消", @"取消") withBlock:^(NSInteger index) {
    }];
    
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    MIAppDelegate* delegate = (MIAppDelegate*)[[UIApplication sharedApplication] delegate];
    [actionSheet showInView:delegate.window];
}

- (void) openImagePickerController:(UIImagePickerControllerSourceType) type
{
    UIImagePickerController* imagePickerC = [[UIImagePickerController alloc] init];
    imagePickerC.sourceType = type;
    imagePickerC.delegate = self;
    imagePickerC.allowsEditing = NO;
    [[MINavigator navigator] openModalViewController:imagePickerC animated:YES];
}

- (void) uploadImage:(UIImage *)image savekey:(NSString *)savekey
{
    if (![self checkSavekey:savekey]) {
        return;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 0.85);
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"v0.api.upyun.com" customHeaderFields:nil];
    NSString *policy = [self getPolicyWithSaveKey:savekey];
    NSString *signature = [self getSignatureWithPolicy:policy];
    NSDictionary * parameDic = [NSDictionary dictionaryWithObjectsAndKeys:policy,@"policy", signature,@"signature", nil];
    MKNetworkOperation* operation = [engine operationWithPath:self.bucket params:parameDic httpMethod:@"POST" ssl:NO];
    [operation addData:imageData forKey:@"file"];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *responseDic = [completedOperation responseJSON];
        if ([[responseDic valueForKey:@"code"] integerValue] == 200)
        {
            if (_successBlocker) {
                _successBlocker(responseDic);
            }

        }
        else {
            NSError *err = [NSError errorWithDomain:ERROR_DOMAIN
                                               code:[[responseDic objectForKey:@"code"] intValue]
                                           userInfo:responseDic];
            if (_failBlocker) {
                _failBlocker(err);
            }
        }

    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (_failBlocker) {
            _failBlocker(error);
        }
    }];
    [engine enqueueOperation:operation];
}

- (BOOL)checkSavekey:(NSString *)string
{
    NSRange rangeFileName;
    NSRange rangeFileNameOnDic;
    rangeFileName = [string rangeOfString:SUB_SAVE_KEY_FILENAME];
    if ([_params objectForKey:@"save-key"]) {
        rangeFileNameOnDic = [[_params objectForKey:@"save-key"]
                              rangeOfString:SUB_SAVE_KEY_FILENAME];
    }else {
        rangeFileNameOnDic.location = NSNotFound;
    }
    
    
    if(rangeFileName.location != NSNotFound || rangeFileNameOnDic.location != NSNotFound)
    {
        NSString *  message = [NSString stringWithFormat:@"传入file为NSData或者UIImage时,不能使用%@方式生成savekey",
                               SUB_SAVE_KEY_FILENAME];
        NSError *err = [NSError errorWithDomain:ERROR_DOMAIN
                                           code:-1998
                                       userInfo:@{@"message":message}];
        if (_failBlocker) {
            _failBlocker(err);
        }
        return NO;
    }
    return YES;
}

- (NSString *)getPolicyWithSaveKey:(NSString *)savekey {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    [dic setObject:self.bucket forKey:@"bucket"];
    [dic setObject:DATE_STRING(self.expiresIn) forKey:@"expiration"];
    if (savekey && ![savekey isEqualToString:@""]) {
        [dic setObject:savekey forKey:@"save-key"];
    }
    
    if (self.params) {
        for (NSString *key in self.params.keyEnumerator) {
            [dic setObject:[self.params objectForKey:key] forKey:key];
        }
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:nil error:nil];
    return [jsonData base64EncodedString];
}

- (NSString *)getSignatureWithPolicy:(NSString *)policy
{
    NSString *str = [NSString stringWithFormat:@"%@&%@",policy,self.passcode];
    NSString *signature = [[str md5] lowercaseString];
    return signature;
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取拍照的图片
    UIImage* image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//将拍到的图片保存到相册
    }
    //关闭模态视图控制器
    [picker dismissViewControllerAnimated:NO completion:^{
        MIModifyHeadImageViewController *modifyHeadImageVC = [[MIModifyHeadImageViewController alloc] initWithImage:image];
        [[MINavigator navigator] openModalViewController:modifyHeadImageVC animated:YES];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}


@end
