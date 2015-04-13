//
//  MIInviteFriendsViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-6-16.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIInviteFriendsViewController.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "WXApi.h"
#import "MISinaWeibo.h"
#import "MITencentAuth.h"
#import "MIShareViewController.h"
#import "MIPartnerGetRequest.h"
#import "MIPartnerGetModel.h"

@implementation MIInviteFriendsViewController
@synthesize awardBgView, shareToFriendsView, awardRuleView;
@synthesize indicatorView = _indicatorView;
@synthesize totalAwardLabel = _totalAwardLabel;
@synthesize validAwardLabel = _validAwardLabel;
@synthesize shareLinkLabel = _shareLinkLabel;
@synthesize partnerGetRequest = _partnerGetRequest;
@synthesize partnerGetModel = _partnerGetModel;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //显示奖励到账信息
    awardBgView = [[UIView alloc] initWithFrame:CGRectMake(8, 8 + self.navigationBarHeight, SCREEN_WIDTH - 16, 55)];
    awardBgView.backgroundColor = [UIColor whiteColor];
    awardBgView.clipsToBounds = YES;
    awardBgView.layer.cornerRadius = 2.0;
    
    //登录信息
    UIView *awardInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 16, 30)];
    awardInfoView.backgroundColor = [UIColor whiteColor];
    awardInfoView.clipsToBounds = YES;
    [awardBgView addSubview:awardInfoView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.center = CGPointMake(SCREEN_WIDTH / 2 - 8, 15);
    [_indicatorView startAnimating];
    [awardInfoView addSubview:_indicatorView];
    
    _totalAwardLabel = [[RTLabel alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH - 16, 30)];
    _totalAwardLabel.backgroundColor = [UIColor clearColor];
    _totalAwardLabel.textAlignment = RTTextAlignmentCenter;
    _totalAwardLabel.font = [UIFont systemFontOfSize:16];
    _totalAwardLabel.text = @"你邀请了0位好友，最高可获<font color='#ff6600'>0元</font>奖励";
    [awardInfoView addSubview:_totalAwardLabel];
    
    _validAwardLabel = [[RTLabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH - 16, 30)];
    _validAwardLabel.backgroundColor = [UIColor clearColor];
    _validAwardLabel.textAlignment = RTTextAlignmentCenter;
    _validAwardLabel.text = @"你的邀请奖励，已收入了<font color='#499d00'>0元</font>";
    [awardInfoView addSubview:_validAwardLabel];
    
    UIView *splitLineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH - 16, 1)];
    splitLineView1.backgroundColor = [MIUtility colorWithHex:0xf1f1f1];
    [awardBgView addSubview:splitLineView1];
    
    RTLabel *awardDetailsTips = [[RTLabel alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH - 16, 25)];
    awardDetailsTips.backgroundColor = [UIColor clearColor];
    awardDetailsTips.textAlignment = RTTextAlignmentCenter;
    awardDetailsTips.font = [UIFont systemFontOfSize:12];
    awardDetailsTips.textColor = [UIColor lightGrayColor];
    awardDetailsTips.text = @"奖励收入明细，去“<font color='#808080'>我的邀请</font>”看看";
    [awardBgView addSubview:awardDetailsTips];
    
    UITapGestureRecognizer *imcomeRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goCheckIncome)];
    [awardDetailsTips addGestureRecognizer:imcomeRecoginzer];
    
    //分享链接
    shareToFriendsView = [[UIView alloc] initWithFrame:CGRectMake(8, awardBgView.bottom + 8, SCREEN_WIDTH - 16, 165)];
    shareToFriendsView.backgroundColor = [UIColor whiteColor];
    shareToFriendsView.layer.cornerRadius = 2.0;
    
    UIImageView *shareLinkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 16, 45)];
    shareLinkView.image = [[UIImage imageNamed:@"ic_bg_address"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 20, 10)];
    shareLinkView.userInteractionEnabled = YES;
    [shareToFriendsView addSubview:shareLinkView];
    
    _shareLinkLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, SCREEN_WIDTH - 24, 45)];
    _shareLinkLabel.backgroundColor = [UIColor clearColor];
    _shareLinkLabel.textAlignment = UITextAlignmentCenter;
    _shareLinkLabel.font = [UIFont systemFontOfSize:14];
    _shareLinkLabel.adjustsFontSizeToFitWidth = YES;
    _shareLinkLabel.contentMode = UIViewContentModeScaleAspectFit;
    _shareLinkLabel.text = @"http://m.mizhe.com";
    [shareLinkView addSubview:_shareLinkLabel];
    
    UITapGestureRecognizer *shareLinkRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyShareLink)];
    [shareLinkView addGestureRecognizer:shareLinkRecoginzer];
    
    RTLabel *copyLinkTips = [[RTLabel alloc] initWithFrame:CGRectMake(5, shareLinkView.bottom, SCREEN_WIDTH - 24, 25)];
    copyLinkTips.backgroundColor = [UIColor clearColor];
    copyLinkTips.textAlignment = RTTextAlignmentCenter;
    copyLinkTips.font = [UIFont systemFontOfSize:12];
    copyLinkTips.textColor = [UIColor lightGrayColor];
    copyLinkTips.text = @"点击链接可以复制到剪切板";
    [shareToFriendsView addSubview:copyLinkTips];
    
    UILabel *splitLineView2 = [[UILabel alloc] initWithFrame:CGRectMake(0, copyLinkTips.bottom - 5, SCREEN_WIDTH - 16, 1)];
    splitLineView2.backgroundColor = [MIUtility colorWithHex:0xf1f1f1];
    [shareToFriendsView addSubview:splitLineView2];
    
    UIButton *shareToWeixinBtn = [self buttonWithFrame:CGRectMake(8, splitLineView2.bottom + 10, (SCREEN_WIDTH - 40) / 2, 36) iconName:@"ic_weixin" title:@"分享到微信"];
    [shareToWeixinBtn addTarget:self action:@selector(shareToWeixin) forControlEvents:UIControlEventTouchUpInside];
    [shareToFriendsView addSubview:shareToWeixinBtn];
    
    UIButton *shareToQQBtn = [self buttonWithFrame:CGRectMake(shareToWeixinBtn.right + 8, splitLineView2.bottom + 10, (SCREEN_WIDTH - 40) / 2, 36) iconName:@"ic_qq" title:@"分享给QQ好友"];
    [shareToQQBtn addTarget:self action:@selector(shareToQQFriends) forControlEvents:UIControlEventTouchUpInside];
    [shareToFriendsView addSubview:shareToQQBtn];
    
    UIButton *shareToQZoneBtn = [self buttonWithFrame:CGRectMake(8, shareToWeixinBtn.bottom + 10, (SCREEN_WIDTH - 40) / 2, 36) iconName:@"ic_zone" title:@"分享到QQ空间"];
    [shareToQZoneBtn addTarget:self action:@selector(shareToQZone) forControlEvents:UIControlEventTouchUpInside];
    [shareToFriendsView addSubview:shareToQZoneBtn];
    
    UIButton *shareToWeiboBtn = [self buttonWithFrame:CGRectMake(shareToQZoneBtn.right + 8, shareToWeixinBtn.bottom + 10, (SCREEN_WIDTH - 40) / 2, 36) iconName:@"ic_sina" title:@"分享到新浪微博"];
    [shareToWeiboBtn addTarget:self action:@selector(shareToWeibo) forControlEvents:UIControlEventTouchUpInside];
    [shareToFriendsView addSubview:shareToWeiboBtn];
    
    //邀请规则信息
    awardRuleView = [[UIView alloc] initWithFrame:CGRectMake(8, shareToFriendsView.bottom + 8, SCREEN_WIDTH - 16, self.view.viewHeight - shareToFriendsView.bottom - 15)];
    awardRuleView.backgroundColor = [UIColor whiteColor];
    awardRuleView.layer.cornerRadius = 2.0;
    
    RTLabel *awardRuleTitle = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 16, 25)];
    awardRuleTitle.backgroundColor = [UIColor clearColor];
    awardRuleTitle.textAlignment = RTTextAlignmentCenter;
    awardRuleTitle.font = [UIFont systemFontOfSize:12];
    awardRuleTitle.text = @"邀请奖<font color='#ff6600' size=18>10</font>元现金";
    [awardRuleView addSubview:awardRuleTitle];
    
    UILabel *splitLineView3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, SCREEN_WIDTH - 16, 1)];
    splitLineView3.backgroundColor = [MIUtility colorWithHex:0xf1f1f1];
    [awardRuleView addSubview:splitLineView3];
    
    UIImage *image = [UIImage imageNamed:@"ic_information"];
    float imageViewHeiht = (SCREEN_WIDTH - 32) * image.size.height / image.size.width;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,
                                                                           (awardRuleView.viewHeight - 25 - 35 - imageViewHeiht) / 2 + splitLineView3.bottom,
                                                                           SCREEN_WIDTH - 32,
                                                                           imageViewHeiht)];
    imageView.image = image;
    [awardRuleView addSubview: imageView];
    
    RTLabel *awardRuleTip = [[RTLabel alloc] initWithFrame:CGRectMake(8, awardRuleView.viewHeight - 35, SCREEN_WIDTH - 32, 35)];
    awardRuleTip.backgroundColor = [UIColor clearColor];
    awardRuleTip.font = [UIFont systemFontOfSize:12.0];
    awardRuleTip.textColor = [UIColor grayColor];
    awardRuleTip.textAlignment = RTTextAlignmentCenter;
    awardRuleTip.lineBreakMode = kCTLineBreakByWordWrapping;
    awardRuleTip.lineSpacing = 3.0;
    awardRuleTip.text = @"每邀请一个新用户，都能让您获得10元！\n邀请越多，奖励越多！";
    [awardRuleView addSubview:awardRuleTip];
    
    [self.view addSubview:self.awardBgView];
    [self.view addSubview:self.shareToFriendsView];
    [self.view addSubview:self.awardRuleView];
    
    
    __weak typeof(self) weakSelf = self;
    _partnerGetRequest = [[MIPartnerGetRequest alloc] init];
    _partnerGetRequest.onCompletion = ^(MIPartnerGetModel *model) {
        [weakSelf setOverlayStatus:EOverlayStatusRemove labelText:nil];
        [weakSelf.indicatorView removeFromSuperview];

        weakSelf.totalAwardLabel.hidden = NO;
        weakSelf.validAwardLabel.hidden = NO;
        weakSelf.awardBgView.hidden = NO;
        weakSelf.shareToFriendsView.hidden = NO;
        weakSelf.awardRuleView.hidden = NO;
        weakSelf.totalAwardLabel.text = [NSString stringWithFormat:@"你邀请了<font color='#ff6600'> %ld </font>位好友", (long)model.count.integerValue];
        weakSelf.validAwardLabel.text = [NSString stringWithFormat:@"奖励收入<font color='#499d00'> %ld </font>元", (long)model.shareSum.integerValue];
        weakSelf.shareLinkLabel.text = model.inviteLink;
        [[NSUserDefaults standardUserDefaults] setObject:model.inviteLink forKey:@"inviteFriendsLink"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    };

    _partnerGetRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
    };

    NSString *inviteLink = [[NSUserDefaults standardUserDefaults] objectForKey:@"inviteFriendsLink"];
    if (inviteLink == nil || inviteLink.length == 0) {
        self.awardBgView.hidden = YES;
        self.shareToFriendsView.hidden = YES;
        self.awardRuleView.hidden = YES;
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    } else {
        _totalAwardLabel.hidden = YES;
        _validAwardLabel.hidden = YES;
        self.shareLinkLabel.text = inviteLink;
    }
    
    [_partnerGetRequest sendQuery];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationBar setBarTitle:@"邀请奖现金"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    activateTimer = [NSTimer scheduledTimerWithTimeInterval: 1.5
                                                     target: self
                                                   selector: @selector(displayAwardInfo)
                                                   userInfo: nil
                                                    repeats: YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [activateTimer invalidate];
    [_partnerGetRequest cancelRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayAwardInfo
{
	if (_totalAwardLabel.top != 30 && _totalAwardLabel.top != 5) {
		_totalAwardLabel.top = 5;
		_validAwardLabel.top = 30;
	}
	
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         _totalAwardLabel.top = (_totalAwardLabel.top == 5 ? -30 : 5);
                         _validAwardLabel.top = (_validAwardLabel.top == 5 ? -30 : 5);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _totalAwardLabel.top = (_totalAwardLabel.top == -30 ? 30 : 5);
                             _validAwardLabel.top = (_validAwardLabel.top == -30 ? 30 : 5);
                         }
                     }];
}

- (void)showAlertViewWithMessage:(NSString *)message cancelItem:(MIButtonItem *)cancelItem otherItem:(MIButtonItem *)otherItem
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:otherItem, nil];
    [alertView show];
}

- (void)goCheckIncome
{
    MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
    cancelItem.action = nil;

    MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"好"];
    affirmItem.action = ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[MIConfig globalConfig].incomeURL]];
    };

    [self showAlertViewWithMessage:@"即将打开Safari前往米折“我的邀请”中查看奖励收入具体情况"
                        cancelItem:cancelItem
                         otherItem:affirmItem];
}

- (void) copyShareLink
{
    [UIPasteboard generalPasteboard].string = _shareLinkLabel.text;
    [self showSimpleHUD:@"已复制链接，去分享给好友吧"];
}

- (UIButton *)buttonWithFrame:(CGRect)frame iconName:(NSString *)icon title:(NSString *)title
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    NSString *btnBgImgName;
    NSString *btnBgHLImgName;

    btnBgImgName = @"ic_bg_invite";
    btnBgHLImgName = @"ic_bg_invite_hl";

    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [button setBackgroundImage:[[UIImage imageNamed:btnBgImgName] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 4, 20, 4)] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:btnBgHLImgName] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 4, 20, 4)] forState:UIControlStateHighlighted];

    UIImage *image = [UIImage imageNamed:icon];
    [button setImage:image forState:UIControlStateNormal];
    CGFloat spacing = 5;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, spacing, 0.0, 0.0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, spacing*2, 0.0, 0.0)];

    button.backgroundColor = [UIColor clearColor];
    return button;
}

- (void)shareToQQFriends
{
    if ([QQApi isQQInstalled]) {
        [MobClick event:kShared label:@"分享给QQ好友"];
        [MobClick event:kInvitation];

        QQApiNewsObject *object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:_shareLinkLabel.text]
                                                           title:@"米折网-千万女性专属的优品特卖会"
                                                     description:@"最近在@米折网 买东西根本停不下来，太划算了， 9.9元包邮，大品牌1折起，每天10点上新，快去看看吧！"
                                                 previewImageURL:[NSURL URLWithString:[MIConfig globalConfig].appSharePicURL]];
        SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:object];

        [QQApiInterface sendReq:req];
    } else {
		[UIPasteboard generalPasteboard].string = _shareLinkLabel.text;
		[self showSimpleHUD:@"您尚未安装QQ，已复制链接到剪切板"];
    }
}

- (void)shareToWeixin
{
    if ([WXApi isWXAppInstalled]) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"米折网-千万女性专属的优品特卖会";
        message.description = @"最近在@米折网 买东西根本停不下来，太划算了， 9.9元包邮，大品牌1折起，每天10点上新，快去看看吧！";
        [message setThumbImage:[UIImage imageNamed:@"app_share_pic"]];

        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = _shareLinkLabel.text;
        message.mediaObject = ext;

        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        
        MIActionSheet *actionSheet = [[MIActionSheet alloc] initWithTitle:@"分享到微信"];
        [actionSheet addButtonWithTitle:@"分享到朋友圈" withBlock:^(NSInteger index) {
            [MobClick event:kShared label:@"分享到朋友圈"];
            [MobClick event:kInvitation];

            req.scene = WXSceneTimeline;
            [WXApi sendReq:req];
        }];

        [actionSheet addButtonWithTitle:@"分享给好友" withBlock:^(NSInteger index) {
            [MobClick event:kShared label:@"分享给微信好友"];
            [MobClick event:kInvitation];

            req.scene = WXSceneSession;
            [WXApi sendReq:req];
        }];

        [actionSheet addButtonWithTitle:NSLocalizedString(@"取消", @"取消") withBlock:^(NSInteger index) {
        }];

        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		
        [actionSheet showInView:self.view];
    } else {
		[UIPasteboard generalPasteboard].string = _shareLinkLabel.text;
		[self showSimpleHUD:@"您尚未安装微信，已复制链接到剪切板"];
    }
}

- (void)shareToQZone
{
    [MobClick event:kInvitation];

    NSString *itemUrl = _shareLinkLabel.text;
    NSString *itemTitle = @"米折网-千万女性专属的优品特卖会";
    NSString *itemImg = [MIConfig globalConfig].appSharePicURL;
    NSString *itemDesc = @"最近在@米折网 买东西根本停不下来，太划算了， 9.9元包邮，大品牌1折起，每天10点上新，快去看看吧！";
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:itemUrl]
                                title:itemTitle
                                description:itemDesc
                                previewImageURL:[NSURL URLWithString:itemImg]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    if (EQQAPISENDFAILD == sent) {
        [MINavigator showSimpleHudWithTips:@"分享失败，请稍候再试"];
    }
}

- (void)shareToWeibo
{
    MISinaWeibo *sinaWeibo = [MISinaWeibo getInstance];
    if ([sinaWeibo isAuthValid])
    {
        [MobClick event:kInvitation];

        MIShareViewController *vc = [[MIShareViewController alloc] init];
        vc.defaultStatus = @"最近在@米折网 买东西根本停不下来，太划算了， 9.9元包邮，大品牌1折起，每天10点上新，快去看看吧！";
        vc.itemTitle = @"米折网-千万女性专属的优品特卖会";
        vc.itemUrl = _shareLinkLabel.text;
        vc.itemDesc = @"国内最大的女性特卖网站，致力于为年轻女性提供时尚又实惠的专属特卖服务！每天10点开抢，不见不散~";
        vc.itemImageUrl = [MIConfig globalConfig].appSharePicLargeURL;
        [[MINavigator navigator] openModalViewController:vc animated:YES];
    } else {
        SEL invoSelector = @selector(shareToWeibo);
        NSMethodSignature* ms = [self methodSignatureForSelector:invoSelector];
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:ms];
        [invocation setTarget:self];
        [invocation setSelector:invoSelector];
        [invocation retainArguments];
        [sinaWeibo logIn:invocation];
    }
}

@end
