//
//  MIScanViewController.h
//  MISpring
//
//  Created by husor on 14-12-11.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZBarSDK.h"

@interface MIScanViewController : MIBaseViewController<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,ZBarReaderViewDelegate>

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, strong) ZBarReaderView *readerView;
@property (nonatomic, strong) ZBarCameraSimulator *simulator;
@property (nonatomic, strong) UIView *tipBg;
@property (nonatomic, strong) UIView *shadowView;

@end
