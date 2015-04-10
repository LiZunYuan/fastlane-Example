//
//  MIModifyHeadImageViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 13-12-12.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIModifyHeadImageViewController.h"
#import "UIImage+MIRotation.h"
#import "MIUpYun.h"
#import "MIUserAvatarUpdateRequest.h"
#import "MIUserAvatarUpdateModel.h"

@interface MIModifyHeadImageViewController ()
{
@private
    CGSize _originalImageViewSize;
}

@property (nonatomic, strong) UIImageView *resultImageView;

@end

@implementation MIModifyHeadImageViewController
@synthesize resultImageView,defaultImage;


- (id)initWithImage:(UIImage *)aImage
{
    self = [super init];
    if (self) {
        // Custom initialization
        defaultImage = aImage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, SCREEN_HEIGHT)];
    self.baseView.backgroundColor = [MIUtility colorWithHex:0x444444];
    self.baseView.clipsToBounds = YES;
    [self.view addSubview:self.baseView];
    
    _rooImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.baseView.viewWidth, self.baseView.viewHeight)];
    self.rooImageView.userInteractionEnabled = YES;
    self.rooImageView.autoresizesSubviews = NO;
    [self.baseView addSubview:self.rooImageView];
    
    UIView *topShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, (self.rooImageView.viewHeight - PHONE_SCREEN_SIZE.width)/2-1)];
    topShadowView.backgroundColor = [UIColor blackColor];
    topShadowView.alpha = 0.4;
    [self.baseView addSubview:topShadowView];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, topShadowView.bottom, PHONE_SCREEN_SIZE.width, 1 )];
    topLineView.backgroundColor = [UIColor whiteColor];
    [self.baseView addSubview:topLineView];
    
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, topLineView.top, 1, PHONE_SCREEN_SIZE.width + 2)];
    leftLineView.backgroundColor = [UIColor whiteColor];
    [self.baseView addSubview:leftLineView];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(PHONE_SCREEN_SIZE.width-1, topLineView.top, 1, PHONE_SCREEN_SIZE.width + 2)];
    rightLineView.backgroundColor = [UIColor whiteColor];
    [self.baseView addSubview:rightLineView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.rooImageView.viewHeight/2+PHONE_SCREEN_SIZE.width/2, PHONE_SCREEN_SIZE.width, 1 )];
    bottomLineView.backgroundColor = [UIColor whiteColor];
    [self.baseView addSubview:bottomLineView];
    
    UIView *bottomShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomLineView.bottom, PHONE_SCREEN_SIZE.width, self.rooImageView.viewHeight - bottomLineView.bottom)];
    bottomShadowView.backgroundColor = [UIColor blackColor];
    bottomShadowView.alpha = 0.6;
    [self.baseView addSubview:bottomShadowView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(0, 0, 80, 40);
    cancelButton.centerY = bottomShadowView.centerY;
    [self.baseView addSubview:cancelButton];
    
    UIButton *rotateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotateButton setImage:[UIImage imageNamed:@"rotate_image"] forState:UIControlStateNormal];
    [rotateButton setImage:[UIImage imageNamed:@"rotate_image_highlight"] forState:UIControlStateHighlighted];
    [rotateButton addTarget:self action:@selector(rotateImageView:) forControlEvents:UIControlEventTouchUpInside];
    rotateButton.frame = CGRectMake(0, 0, 18, 18);
    rotateButton.center = bottomShadowView.center;
    [self.baseView addSubview:rotateButton];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"选取" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(finishCroppingImage) forControlEvents:UIControlEventTouchUpInside];
    doneButton.frame = CGRectMake(bottomShadowView.right-80, 0, 80, 40);
    doneButton.centerY = bottomShadowView.centerY;
    [self.baseView addSubview:doneButton];
    
    //拖拽
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImageView:)];
    [self.rooImageView addGestureRecognizer:pan];
    //捏合
    UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaleImageView:)];
    [self.rooImageView addGestureRecognizer:pinch];

    
    [self setImage:defaultImage];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)finishCroppingImage
{
    //先截取屏幕
    UIGraphicsBeginImageContext(PHONE_SCREEN_SIZE);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, PHONE_SCREEN_SIZE.height));
    [self.baseView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //根据上一个截取下来的image截取局部图片
    CGRect rect = CGRectMake(1, (self.baseView.viewHeight-(PHONE_SCREEN_SIZE.width-2))/2, PHONE_SCREEN_SIZE.width-2, PHONE_SCREEN_SIZE.width-2);
    UIGraphicsBeginImageContext(rect.size);
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGContextDrawImage(context, rect, imageRef);
    _croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    [self updateAvatar];
}

- (void)updateAvatar
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.baseView animated:YES];
    hud.detailsLabelText = @"上传中...";
    hud.removeFromSuperViewOnHide = YES;
    
    MIUpYun *uy = [MIUpYun getInstance];
    __weak typeof(self) weakSelf = self;

    uy.successBlocker = ^(id data)
    {
        NSDictionary *jsonDic = (NSDictionary *)data;
        MIUserAvatarUpdateRequest * request = [[MIUserAvatarUpdateRequest alloc] init];
        request.onCompletion = ^(MIUserAvatarUpdateModel *model) {
            [hud setHidden:YES];
            if (model.success.boolValue)
            {
                [weakSelf showSimpleHUD:@"成功上传头像" afterDelay:1.0];
                [MIMainUser getInstance].headURL = model.data;
                [[MIMainUser getInstance] persist];
            }
            else
            {
                [weakSelf showSimpleHUD:@"上传头像失败，请稍后再试" afterDelay:1.0];
            }
            [weakSelf performSelector:@selector(popView) withObject:nil afterDelay:1.0];
        };
        request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [hud setHidden:YES];
            MILog(@"error_msg=%@",error.description);
        };
        [request setAvatarUrl:[jsonDic valueForKey:@"url"]];
        [request sendQuery];
    };
    uy.failBlocker = ^(NSError * error)
    {
        [hud setHidden:YES];

        NSString *message = [error.userInfo objectForKey:@"message"];
        if (message == nil || message.length == 0) {
            message = @"上传头像失败，请稍后再试";
        }
        [weakSelf showSimpleHUD:message afterDelay:1.3];
        MILog(@"%@",error);
    };
    uy.progressBlocker = ^(CGFloat percent,long long requestDidSendBytes)
    { };
    NSTimeInterval interv = [[NSDate date] timeIntervalSince1970];
    NSString *string = [NSString stringWithFormat:@"iPhone%@%f",[MIMainUser getInstance].userId, interv];
    NSString *saveKey = [NSString stringWithFormat:@"/avatar/%@/%@_318x318.jpg", [[NSDate date] stringForYymm], [string md5]];
    [uy uploadImage:self.croppedImage savekey:saveKey];
}
- (void)finishLoadData:(MIUserAvatarUpdateModel *)model
{
    if (model.success.boolValue)
    {
        [self showSimpleHUD:@"成功上传头像" afterDelay:1.0];
        [MIMainUser getInstance].headURL = [NSString stringWithFormat:@"%@!100x100.jpg",model.data];
        [[MIMainUser getInstance] persist];
        [self performSelector:@selector(popView) withObject:nil afterDelay:1.0];
    }
    else
    {
        [self showSimpleHUD:@"上传头像失败，请稍后再试" afterDelay:1.0];
    }
}

- (void)popView
{
    [[MINavigator navigator] closeModalViewController:YES completion:nil];
}

- (void)setImage:(UIImage *)image
{
    float _imageScale = self.rooImageView.frame.size.width / image.size.width;
    self.rooImageView.frame = CGRectMake(0, 0, image.size.width*_imageScale, image.size.height*_imageScale);
    _originalImageViewSize = CGSizeMake(image.size.width*_imageScale, image.size.height*_imageScale);
    self.rooImageView.image = image;
    self.rooImageView.centerY= self.baseView.viewHeight / 2;
}

float _lastTransX = 0.0, _lastTransY = 0.0;
- (void)moveImageView:(UIPanGestureRecognizer *)sender
{
    CGPoint translatedPoint = [sender translationInView:self.baseView];
    
    if([sender state] == UIGestureRecognizerStateBegan) {
        _lastTransX = 0.0;
        _lastTransY = 0.0;
    }
    
    CGAffineTransform trans = CGAffineTransformMakeTranslation(translatedPoint.x - _lastTransX, translatedPoint.y - _lastTransY);
    CGAffineTransform newTransform = CGAffineTransformConcat(self.rooImageView.transform, trans);
    _lastTransX = translatedPoint.x;
    _lastTransY = translatedPoint.y;
    
    self.rooImageView.transform = newTransform;
}


float _lastScale = 1.0;
- (void)scaleImageView:(UIPinchGestureRecognizer *)sender
{
    if([sender state] == UIGestureRecognizerStateBegan) {
        
        _lastScale = 1.0;
        return;
    }
    
    CGFloat scale = [sender scale]/_lastScale;
    
    CGAffineTransform currentTransform = self.rooImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [self.rooImageView setTransform:newTransform];
    
    _lastScale = [sender scale];
}

float _lastRotation = 0.0;
- (void)rotateImageView:(id)sender
{
    _lastRotation += M_PI_2;
    if (_lastRotation == M_PI * 2)
    {
        _lastRotation = 0.0;
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(_lastRotation);

    self.rooImageView.transform = transform;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
