//
//  MIUpdateGradeViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 13-11-21.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIUpdateGradeViewController.h"
#import "MIPartnerGetModel.h"
#import "MIUserVipApplyModel.h"
#import "MIInviteFriendsViewController.h"

@interface MIUpdateGradeViewController ()

@property (nonatomic, strong) NSArray *memberStringArray;

@end

@implementation MIUpdateGradeViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _memberStringArray = [[NSArray alloc] initWithObjects:@"普通会员",@"铜牌会员",@"银牌会员",@"金牌会员",@"白金会员",@"钻石会员", nil];
    }
    return self;
}


- (void)inviteFriendsAction
{
    [MobClick event:kInvited];
    MIInviteFriendsViewController* vc = [[MIInviteFriendsViewController alloc] init];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}

- (void)goToShopAction
{
    [[MINavigator navigator] goMainScreenFromAnyByIndex:MAIN_SCREEN_INDEX_HOMEPAGE info:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBarTitle:@"我要升级"];
    
    /**********************************************/
    _mainBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, self.navigationBarHeight, PHONE_SCREEN_SIZE.width - 20, PHONE_SCREEN_SIZE.height - self.navigationBarHeight - PHONE_STATUSBAR_HEIGHT)];
    self.mainBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainBackgroundView];
    
    UIView *bgReminderView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.mainBackgroundView.viewWidth, 60)];
    bgReminderView.backgroundColor = [UIColor blackColor];
    bgReminderView.alpha = 0.7;
    bgReminderView.layer.cornerRadius = 4;
    bgReminderView.layer.masksToBounds = YES;
    [self.mainBackgroundView addSubview:bgReminderView];
    
    _reminderLabel = [[RTLabel alloc] initWithFrame:CGRectMake(0,20, bgReminderView.viewWidth, 20)];
    self.reminderLabel.backgroundColor = [UIColor clearColor];
    self.reminderLabel.textAlignment = kCTCenterTextAlignment;
    self.reminderLabel.textColor = [UIColor whiteColor];
    self.reminderLabel.font = [UIFont boldSystemFontOfSize:14];
    [bgReminderView addSubview:self.reminderLabel];
    
    /**********************************************/
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, bgReminderView.bottom + 10, self.mainBackgroundView.viewWidth, 300)];
    bgView.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.15].CGColor;
    bgView.layer.borderWidth = .8;
    bgView.layer.cornerRadius = 4;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.mainBackgroundView addSubview:bgView];
    
    //邀请好友返利
    _numOfRebateFriendsLabel = [[RTLabel alloc] initWithFrame:CGRectMake(0, 20, bgView.viewWidth, 40)];
    self.numOfRebateFriendsLabel.backgroundColor = [UIColor clearColor];
    self.numOfRebateFriendsLabel.textColor = [UIColor darkGrayColor];
    self.numOfRebateFriendsLabel.font = [UIFont systemFontOfSize:14];
    self.numOfRebateFriendsLabel.textAlignment = kCTCenterTextAlignment;
    self.numOfRebateFriendsLabel.lineSpacing = 5;
    [bgView addSubview:self.numOfRebateFriendsLabel];
    
    MICommonButton *inviteButton = [[MICommonButton alloc] initWithFrame: CGRectMake(85, self.numOfRebateFriendsLabel.bottom + 10, 150, 36)];
    inviteButton.centerX = bgView.centerX;
    inviteButton.alpha = 0.95;
    [inviteButton setTitle:@"继续邀请好友" forState:UIControlStateNormal];
    inviteButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [inviteButton addTarget:self action:@selector(inviteFriendsAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:inviteButton];
    
    //或
    UILabel *orLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, inviteButton.bottom, 20, 60)];
    orLabel.backgroundColor = [UIColor clearColor];
    orLabel.text = @"或";
    orLabel.textColor = [MIUtility colorWithHex:0xAFAFAF];
    orLabel.textAlignment = NSTextAlignmentCenter;
    orLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:orLabel];
    
    UIView *before = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 100, 0.5)];
    before.backgroundColor = [MIUtility colorWithHex:0xD3D3D3];
    before.centerY = orLabel.centerY;
    [bgView addSubview:before];
    
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(orLabel.right+10, 0, 100, 0.5)];
    back.backgroundColor = [MIUtility colorWithHex:0xD3D3D3];
    back.centerY = orLabel.centerY;
    [bgView addSubview:back];
    
    
    //购物拿返利
    _incomeOfRebateLabel = [[RTLabel alloc] initWithFrame:CGRectMake(0, orLabel.bottom, bgView.viewWidth, 40)];
    self.incomeOfRebateLabel.backgroundColor = [UIColor clearColor];
    self.incomeOfRebateLabel.textColor = [UIColor darkGrayColor];
    self.incomeOfRebateLabel.font = [UIFont systemFontOfSize:14];
    self.incomeOfRebateLabel.textAlignment = kCTCenterTextAlignment;
    self.incomeOfRebateLabel.lineSpacing = 5;
    [bgView addSubview:self.incomeOfRebateLabel];
    
    MICommonButton *shopRebateButton = [[MICommonButton alloc] initWithFrame:CGRectMake(85, self.incomeOfRebateLabel.bottom + 10, 150, 36)];
    shopRebateButton.centerX = bgView.centerX;
    shopRebateButton.alpha = 0.95;
    [shopRebateButton setTitle:@"去购物，拿返利" forState:UIControlStateNormal];
    shopRebateButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [shopRebateButton addTarget:self action:@selector(goToShopAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:shopRebateButton];
    
    self.mainBackgroundView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    _request = [[MIPartnerGetRequest alloc] init];
    _request.onCompletion = ^(MIPartnerGetModel *model) {
        [weakSelf finishLoadPartner:model];
    };
    _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf setOverlayStatus:EOverlayStatusError labelText:nil];
        MILog(@"error_msg=%@",error.description);
    };
    [_request sendQuery];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_request cancelRequest];
    [_applyRequest cancelRequest];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)finishLoadPartner:(MIPartnerGetModel *)model
{
    BOOL vipUpdate = NO;
    
    //邀请好友数
    if (model.inviteSum.integerValue >= self.vipModel.inviteSum.integerValue)
    {
        vipUpdate = YES;
        self.numOfRebateFriendsLabel.text = [NSString stringWithFormat:@"有返利好友数%@人<font color='#499D00'>（已达成）</font>\n<font size=12.0 color='#AFAFAF'>当前您的返利好友%@人</font>",self.vipModel.inviteSum,model.inviteSum];
    }
    else
    {
        self.numOfRebateFriendsLabel.text = [NSString stringWithFormat:@"有返利好友数%@人（未达成）\n<font size=12.0 color='#AFAFAF'>当前您的返利好友%@人</font>",self.vipModel.inviteSum,model.inviteSum];
    }
    
    //返利收入
    if ([MIMainUser getInstance].incomeSum.floatValue/100 >= self.vipModel.incomeSum.floatValue)
    {
        vipUpdate = YES;
        self.incomeOfRebateLabel.text = [NSString stringWithFormat:@"返利收入%@元<font color='#499D00'>（已达成）</font>\n<font size=12.0 color='#AFAFAF'>当前您的返利总数%.2f元</font>",self.vipModel.incomeSum,[MIMainUser getInstance].incomeSum.floatValue/100];
    }
    else
    {
        self.incomeOfRebateLabel.text = [NSString stringWithFormat:@"返利收入%@元（未达成）\n<font size=12.0 color='#AFAFAF'>当前您的返利总数%.2f元</font>",self.vipModel.incomeSum,[MIMainUser getInstance].incomeSum.floatValue/100];
    }
    
    if (vipUpdate) {
        [self requestForApplyVIP];
    } else if(self.memberStringArray.count > _indexOfGrade){
        self.reminderLabel.text =  [NSString stringWithFormat:@"升级到 <font color='#ff6600'>%@</font> 需要满足以下其中一个条件",[self.memberStringArray objectAtIndex:_indexOfGrade]];
        [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
        self.mainBackgroundView.hidden = NO;
    }
}

- (void)requestForApplyVIP
{
    __weak typeof(self) weakSelf = self;
    _applyRequest = [[MIUserVIPApplyRequest alloc] init];
    _applyRequest.onCompletion = ^(MIUserVipApplyModel *model) {
        [weakSelf finishApplyVip:model];
    };
    _applyRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf setOverlayStatus:EOverlayStatusError labelText:nil];
        MILog(@"error_msg=%@",error.description);
    };
    [_applyRequest setVipLevel:_indexOfGrade];
    [_applyRequest sendQuery];
}
- (void)finishApplyVip:(MIUserVipApplyModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    self.mainBackgroundView.hidden = NO;
    MILog(@"%@",model.message);
    if (self.memberStringArray.count > _indexOfGrade) {
        if (model.success.boolValue)
        {
            self.reminderLabel.text =  [NSString stringWithFormat:@"恭喜您！您已经成功升级为 <font color='#ff6600'>%@</font>",[self.memberStringArray objectAtIndex:_indexOfGrade]];
            
            [MIMainUser getInstance].grade = @(_indexOfGrade);
            [[MIMainUser getInstance] persist];
        }
        else
        {
            self.reminderLabel.text =  [NSString stringWithFormat:@"升级到 <font color='#ff6600'>%@</font> 需要满足以下其中一个条件",[self.memberStringArray objectAtIndex:_indexOfGrade]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
