//
//  MIShareViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-6-19.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIShareViewController.h"
#import "MIUITextButton.h"
#import "MISinaWeibo.h"
#import "MITencentAuth.h"
#import <TencentOpenAPI/WeiBoAPI.h>

#define keyBoardDefaultHeight  216.0
#define itemBackgroundHeight 80.0
#define itemMarginHeight     10.0

@implementation MIShareViewController
@synthesize shareBackgroundView;
@synthesize statusText;
@synthesize captionLimitLabel;
@synthesize itemViewBackground;
@synthesize itemImageUrl;
@synthesize itemTitle;
@synthesize itemUrl;
@synthesize itemDesc;
@synthesize defaultStatus;
@synthesize itemImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBarRightTextButtonItem:self selector:@selector(goShare:) title:@"发布"];
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(closeModalViewController:) imageKey:@"navigationbar_btn_close"];
    
    shareBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(5, itemMarginHeight + self.navigationBarHeight,
                                                                   310, self.view.viewHeight - keyBoardDefaultHeight - itemMarginHeight*2 - 45)];
    shareBackgroundView.backgroundColor = [UIColor whiteColor];
    shareBackgroundView.layer.cornerRadius = 5.0;
    shareBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    shareBackgroundView.layer.shadowOffset = CGSizeMake(1, 1);
    shareBackgroundView.layer.shadowRadius = 1;
    shareBackgroundView.layer.shadowOpacity = 0.8;
    [self.view addSubview:shareBackgroundView];
    
    CGRect statusFrame = CGRectMake(0, 5,
                                    shareBackgroundView.viewWidth,
                                    shareBackgroundView.viewHeight - itemBackgroundHeight - 2*5);
    statusText =[[UITextView alloc] initWithFrame:statusFrame];
    statusText.contentSize = statusFrame.size;
    statusText.backgroundColor = [UIColor whiteColor];
    statusText.font = [UIFont systemFontOfSize:16];
    statusText.delegate = self;
    [shareBackgroundView addSubview:statusText];
    
    itemViewBackground = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  shareBackgroundView.viewHeight - itemBackgroundHeight,
                                                                  310, itemBackgroundHeight)];
    itemViewBackground.backgroundColor = [UIColor clearColor];
    [shareBackgroundView addSubview:itemViewBackground];
    
    captionLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 290, 15)];
    captionLimitLabel.backgroundColor = [UIColor whiteColor];
    captionLimitLabel.font = [UIFont systemFontOfSize:12];
    captionLimitLabel.textColor = [MIUtility colorWithHex:0x666666];
    captionLimitLabel.textAlignment = UITextAlignmentRight;
    [itemViewBackground addSubview:captionLimitLabel];
    
    UIView *splitLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 310, 1)];
    splitLineView.backgroundColor = [MIUtility colorWithHex:0xf1f1f1];
    [itemViewBackground addSubview:splitLineView];
    
    itemImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10, 22, 50, 50)];
    [itemImageView sd_setImageWithURL:[NSURL URLWithString:itemImageUrl] placeholderImage: [UIImage imageNamed:@"app_share_pic"]];
    itemImageView.clipsToBounds = YES;
    itemImageView.layer.cornerRadius = 3.0;
    [itemViewBackground addSubview:itemImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(70, 20, 235, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.font = [UIFont fontWithName:@"Arial" size:13];
    titleLabel.text = itemTitle;
    [itemViewBackground addSubview:titleLabel];
    
    UILabel *urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, 235, 20)];
    urlLabel.backgroundColor = [UIColor clearColor];
    urlLabel.textColor = [UIColor darkGrayColor];
    urlLabel.font = [UIFont fontWithName:@"Arial" size:12];
    urlLabel.text = itemUrl;
    [itemViewBackground addSubview:urlLabel];
    
    UILabel *sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 55, 235, 20)];
    sourceLabel.backgroundColor = [UIColor clearColor];
    sourceLabel.font = [UIFont fontWithName:@"Arial" size:12];
    sourceLabel.text = @"来自米折";
    [itemViewBackground addSubview:sourceLabel];
    
    
    maxStatusLen = 140 - 20;
    self.statusText.text = self.defaultStatus;
    [self.navigationBar setBarTitle:@"分享到新浪微博"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateCaptionLimitTips];
    [statusText becomeFirstResponder];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeModalViewController: (id) event
{
    [[MINavigator navigator] closeModalViewController:YES completion:nil];
}
     
- (void)goShare:(UIButton *)btn
{
    [MobClick event:kShared label:@"分享到新浪微博"];

    if (statusText.text.length > maxStatusLen) {
        [MINavigator showSimpleHudWithTips:@"字数超过限制！"];
        return;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.yOffset = -100.0f;
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(hud) bhud = hud;
    
    MISinaWeibo *sinaWeibo = [MISinaWeibo getInstance];
    MKNetworkEngine * catsEngine = [[MKNetworkEngine alloc] initWithHostName: kSinaWeiboSDKAPIDomain
                                                          customHeaderFields: nil];
    NSString *status = [NSString stringWithFormat:@"%@ >>%@", statusText.text, itemUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   status, @"status",
                                   sinaWeibo.accessToken, @"access_token",
                                   itemImageUrl, @"url", nil];
    MKNetworkOperation* op = [catsEngine operationWithPath: @"statuses/upload_url_text.json"
                                                    params: params
                                                httpMethod: @"POST" ssl:YES];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [bhud hide:YES];
        NSData* data = completedOperation.responseData;
        if (data) {
            NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSInteger error_code = [[dict objectForKey:@"error_code"] intValue];
            if(error_code == 0) {
                [MINavigator showSimpleHudWithTips:@"分享成功"];
                [[MINavigator navigator] closeModalViewController:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:MiNotifyUserHasShared object:nil];
                }];
                return;
            } else if (error_code == 21314     //Token已经被使用
                       || error_code == 21315  //Token已经过期
                       || error_code == 21316  //Token不合法
                       || error_code == 21317  //Token不合法
                       || error_code == 21327  //token过期
                       || error_code == 21332) //access_token 无效
            {
                [MINavigator showSimpleHudWithTips:@"授权信息过期，请重新登录"];
                [sinaWeibo logOut];
                [[MINavigator navigator] closeModalViewController:YES completion:nil];
                return;
            }
        }
        [weakSelf showSimpleHUD:@"网络繁忙，稍候再试"];
    } errorHandler:^(MKNetworkOperation* completedOperation, NSError *error) {
        [bhud hide:YES];
        [weakSelf showSimpleHUD:@"网络繁忙，稍候再试"];
    }];
    
    [catsEngine enqueueOperation:op];
}

-(void)updateCaptionLimitTips{
    NSInteger captionLen = 0;
    if (statusText.text) {
        captionLen = statusText.text.length;
    }
    captionLimitLabel.text = [NSString stringWithFormat:@"%ld/%ld ", (long)captionLen, (long)maxStatusLen];
    captionLimitLabel.textColor = [UIColor darkGrayColor];
    if (captionLen > maxStatusLen) {
        captionLimitLabel.textColor = [UIColor redColor];
    }
}

#pragma mark - keyboard notification

-(void)keyboardDidHide:(NSNotification *)notification{
    shareBackgroundView.frame = CGRectMake(5, itemMarginHeight + self.navigationBarHeight,
                                           310, self.view.viewHeight - keyBoardDefaultHeight - itemMarginHeight*2 - self.navigationBarHeight);
    CGRect statusFrame = CGRectMake(0, 5,
                                    shareBackgroundView.viewWidth,
                                    shareBackgroundView.viewHeight - itemBackgroundHeight - 2*5);
    statusText.frame = statusFrame;
    statusText.contentSize = statusFrame.size;
    [statusText sizeToFit];

    itemViewBackground.frame = CGRectMake(0,
                                          shareBackgroundView.viewHeight - itemBackgroundHeight,
                                          310, itemBackgroundHeight);
}

-(void)keyboardDidShow:(NSNotification *)notification{
    NSDictionary* info = notification.userInfo;
    NSValue* kbFrameValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];

    shareBackgroundView.frame = CGRectMake(5, itemMarginHeight + self.navigationBarHeight,
                                           310, self.view.viewHeight - [kbFrameValue CGRectValue].size.height - itemMarginHeight*2 - self.navigationBarHeight);
    CGRect statusFrame = CGRectMake(0, 5,
                                    shareBackgroundView.viewWidth,
                                    shareBackgroundView.viewHeight - itemBackgroundHeight - 2*5);
    statusText.frame = statusFrame;
    statusText.contentSize = statusFrame.size;
//    [statusText sizeToFit];
    
    itemViewBackground.frame = CGRectMake(0,
                                          shareBackgroundView.viewHeight - itemBackgroundHeight,
                                          310, itemBackgroundHeight);
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self updateCaptionLimitTips];
}

@end
