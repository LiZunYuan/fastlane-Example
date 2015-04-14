//
//  MIScanViewController.m
//  MISpring
//
//  Created by husor on 14-12-11.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIScanViewController.h"
#define ENABLE_NATIVE_SCANNER  YES
@interface MIScanViewController ()

@end

@implementation MIScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    self.view.frame = CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, SCREEN_HEIGHT);
    self.view.backgroundColor = [UIColor blackColor];
    
    if ([MIUtility isCameraEnable]) {
        if (IOS_VERSION >= 7.0 && !TARGET_IPHONE_SIMULATOR && ENABLE_NATIVE_SCANNER) {
            [self setupCamera];
        } else {
            _readerView = [[ZBarReaderView alloc]init];
            _readerView.frame = self.view.frame;
            _readerView.readerDelegate = self;
            
            CGRect scanCropRect = CGRectMake(0, self.view.centerY - SCREEN_WIDTH*7/8/2.0, SCREEN_WIDTH, SCREEN_WIDTH*7/8/2.0);
            _readerView.scanCrop = [self getCropRect:scanCropRect inFrame:self.view.frame];
            _readerView.torchMode = NO;
            [self.view addSubview:_readerView];
            
            if (TARGET_IPHONE_SIMULATOR) {
                _simulator = [[ZBarCameraSimulator alloc]initWithViewController:self];
                _simulator.readerView = _readerView;
            }
        }
    }
    
    UIImageView * centerView = [[UIImageView alloc]init];
    centerView.image = [UIImage imageNamed:@"richscan_bg"];
    centerView.center = CGPointMake(self.view.centerX, self.view.centerY - 20);
    centerView.bounds = CGRectMake(0, 0, SCREEN_WIDTH*2/3.0, SCREEN_WIDTH*2/3.0);
    [self.view addSubview:centerView];
    
    UIView *bg1 = [[UIView alloc] init];
    bg1.frame = CGRectMake(0, 0, self.view.viewWidth, centerView.top);
    bg1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:bg1];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 25, 40, 40);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ic_richscan_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *explainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    explainBtn.frame = CGRectMake(self.view.viewWidth - 15 - 40, 25, 40, 40);
    [explainBtn setBackgroundImage:[UIImage imageNamed:@"ic_richscan_explain"] forState:UIControlStateNormal];
    [explainBtn addTarget:self action:@selector(giveTips) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:explainBtn];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"扫码获取更多商品信息";
    title.bounds = CGRectMake(0, 0, 150, 30);
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:14];
    title.center = CGPointMake(self.view.centerX, centerView.top -15 - 20);
    [self.view addSubview:title];
    
    UIImageView *richScan1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_richscan_1"]];
    richScan1.bounds = CGRectMake(0, 0, 25, 25);
    richScan1.centerY = title.centerY;
    richScan1.right = title.left - 10;
    [self.view addSubview:richScan1];
    
    UIImageView *richScan2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_richscan_2"]];
    richScan2.bounds = CGRectMake(0, 0, 25, 25);
    richScan2.centerY = title.centerY;
    richScan2.left = title.right + 10;
    [self.view addSubview:richScan2];
    
    UIView *bg2 = [[UIView alloc] init];
    bg2.frame = CGRectMake(0, centerView.bottom, self.view.viewWidth, self.view.viewHeight - centerView.bottom);
    bg2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:bg2];
    
    UIView *bg3 = [[UIView alloc]init];
    bg3.frame = CGRectMake(0, centerView.top, centerView.left, centerView.viewHeight);
    bg3.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:bg3];
    
    UIView *bg4 = [[UIView alloc]init];
    bg4.frame = CGRectMake(centerView.right, centerView.top, self.view.viewWidth - centerView.right, centerView.viewHeight);
    bg4.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:bg4];
    
    UILabel *prompt = [[UILabel alloc]init];
    prompt.backgroundColor = [UIColor clearColor];
    prompt.bounds = CGRectMake(0, 0, 300, 30);
    prompt.textColor = [UIColor whiteColor];
    prompt.text = @"[把二维码对准红色线条，即可扫描]";
    prompt.font = [UIFont boldSystemFontOfSize:14];
    prompt.textAlignment = NSTextAlignmentCenter;
    prompt.centerX = self.view.centerX;
    prompt.centerY = centerView.bottom + 40;
    [self.view addSubview:prompt];
    
    _shadowView = [[UIView alloc]init];
    _shadowView.frame = CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight);
    _shadowView.backgroundColor = [MIUtility colorWithHex:0x000000];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeTips)];
    [_shadowView addGestureRecognizer:tap];
    [self.view addSubview:_shadowView];
    _shadowView.alpha = 0;
    
    _tipBg = [[UIView alloc]init];
    _tipBg.bounds = CGRectMake(0, 0, 264*SCREEN_WIDTH/320.0, 248*SCREEN_WIDTH/320.0);
    _tipBg.centerX = self.view.centerX;
    _tipBg.top = title.bottom;
    _tipBg.backgroundColor = [UIColor whiteColor];
    _tipBg.layer.cornerRadius = 5;
    _tipBg.clipsToBounds = YES;
    [self.view addSubview:_tipBg];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"ic_qr_close"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(self.view.centerX + _tipBg.viewWidth/2.0 - 35 - 28*SCREEN_WIDTH/320.0 , 5, 30, 30);
    closeBtn.backgroundColor = [UIColor clearColor];
    [closeBtn addTarget:self action:@selector(closeTips) forControlEvents:UIControlEventTouchUpInside];
    [_tipBg addSubview:closeBtn];
    
    UIImageView *tipsImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qr_tips_img"]];
    tipsImg.bounds = CGRectMake(0, 0, 150*SCREEN_WIDTH/320.0, 150*SCREEN_WIDTH/320.0);
    tipsImg.centerY = 100*SCREEN_WIDTH/320.0;
    tipsImg.centerX = _tipBg.viewWidth/2.0;
    [_tipBg addSubview:tipsImg];
    
    UILabel *scanTip = [[UILabel alloc]init];
    scanTip.backgroundColor = [UIColor clearColor];
    scanTip.textColor = [MIUtility colorWithHex:0x333333];
    scanTip.bounds = CGRectMake(0, 0, 240*SCREEN_WIDTH/320.0, 40);
    scanTip.centerX = _tipBg.viewWidth/2.0;
    scanTip.centerY = tipsImg.bottom + (15 + 10)*SCREEN_WIDTH/320.0;
    scanTip.numberOfLines = 2;
    scanTip.textAlignment = NSTextAlignmentCenter;
    scanTip.text = @"在米折网明日预告中，点击开抢提醒扫描二维码，把喜欢的东东装进口袋";
    scanTip.font = [UIFont systemFontOfSize:15];
    [_tipBg addSubview:scanTip];
    _tipBg.alpha = 0;

}

-(void)giveTips
{
    
    [UIView animateWithDuration:0.3 animations:^{
        _shadowView.alpha = 0.8;
        _tipBg.alpha = 1;
    } completion:^(BOOL finished) {
        if (IOS_VERSION >= 7.0 && !TARGET_IPHONE_SIMULATOR && ENABLE_NATIVE_SCANNER) {
            [_session stopRunning];
        }
        else {
            [_readerView stop];
        }
    }];
}

-(void)closeTips
{
    [UIView animateWithDuration:0.3 animations:^{
        _shadowView.alpha = 0;
        _tipBg.alpha = 0;
    } completion:^(BOOL finished) {
        if (IOS_VERSION >= 7.0 && !TARGET_IPHONE_SIMULATOR && ENABLE_NATIVE_SCANNER) {
            [_session startRunning];
        }
        else{
            [_readerView start];
        }
    }];
}

-(CGRect)getCropRect:(CGRect)rect inFrame:(CGRect)frame
{
    return CGRectMake(rect.origin.x / frame.size.width,
                      rect.origin.y / frame.size.height,
                      rect.size.width / frame.size.width,
                      rect.size.height / frame.size.height);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 检查是否授权相机
    if (![MIUtility isCameraEnable]) {
        MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"知道了"];
        affirmItem.action = ^{
            // 关闭自己
            [[MINavigator navigator] closeModalViewController:YES completion:^{
            }];
            
        };
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头"
                                                            message:@"请在手机“设置”-“隐私”-“相机”中打开"
                                                   cancelButtonItem:nil
                                                   otherButtonItems:affirmItem, nil];
        [alertView show];
        return;
    }
    
    if (IOS_VERSION >= 7.0 && !TARGET_IPHONE_SIMULATOR && ENABLE_NATIVE_SCANNER) {
        [_session startRunning];
    }
    else{
        [_readerView start];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 检查是否授权相机
    if (![MIUtility isCameraEnable]) {
        return;
    }
    
    if (IOS_VERSION >= 7.0 && !TARGET_IPHONE_SIMULATOR && ENABLE_NATIVE_SCANNER) {
        [_session stopRunning];
    }
    else {
        [_readerView stop];
    }
}

#pragma mark - ZBarReaderViewDelegate
- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    [MobClick event:kScanClicks];
    for (ZBarSymbol *symbol in symbols) {
        //  symbol.data是NSString类型
        MILog(@"%@",symbol.data);
        
        if (symbol.data) {
            [_readerView stop];
            
            if ([MIUtility isScannableURLString:symbol.data]) {
                [[MINavigator navigator] closeModalViewController:NO completion:^{
                    [[MINavigator navigator] openScanViewController:symbol.data];
                }];
            } else {
                // 无效的二维码
                MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"确定"];
                affirmItem.action = ^{
                    [_readerView start];
                };
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[NSString stringWithFormat:@"无效的二维码:%@", symbol.data]
                                                           cancelButtonItem:nil
                                                           otherButtonItems:affirmItem, nil];
                [alertView show];
                
            }
        }
        break;
    }
}

-(void)cancelButtonAction
{
    [[MINavigator navigator] closeModalViewController:YES completion:^{
        
    }];
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.bounds;//CGRectMake(self.view.centerX - 195/2.0 +3 ,self.view.centerY -195/2.0 -30+3,189,189);
    [self.view.layer insertSublayer:self.preview atIndex:0];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [MobClick event:kScanClicks];
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    MILog(@"%@",stringValue);
    if (stringValue) {
        [_session stopRunning];
        if ([MIUtility isScannableURLString:stringValue]) {
            [[MINavigator navigator] closeModalViewController:NO completion:^{
                [[MINavigator navigator] openScanViewController:stringValue];
            }];
        } else {
            // 无效的二维码
            MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"确定"];
            affirmItem.action = ^{
                [_session startRunning];
            };
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[NSString stringWithFormat:@"无效的二维码:%@", stringValue]
                                                       cancelButtonItem:nil
                                                       otherButtonItems:affirmItem, nil];
            [alertView show];
            
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
