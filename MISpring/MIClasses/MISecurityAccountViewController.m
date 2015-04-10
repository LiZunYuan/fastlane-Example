//
//  MISecurityAccountViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 13-11-13.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MISecurityAccountViewController.h"
#import "MIUserGetModel.h"
#import "MIPhoneSettingViewController.h"
#import "MIAlipaySettingViewController.h"
#import "NSString+NSStringEx.h"

@interface CustomCell : UITableViewCell

@property (nonatomic, strong) UILabel *bindingLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 12.5, 15, 15)];
        [self addSubview:self.headImageView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 304 - 80, 20)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:self.titleLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 304 - 40, 20)];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.textColor = [UIColor grayColor];
        self.detailLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:self.detailLabel];
        
        _bindingLabel = [[UILabel alloc] initWithFrame:CGRectMake(295 - 60, 10, 60, 20)];
        self.bindingLabel.backgroundColor = [UIColor clearColor];
        self.bindingLabel.text = @"去绑定";
        self.bindingLabel.textColor = [UIColor redColor];
        self.bindingLabel.font = [UIFont boldSystemFontOfSize:14];
        self.bindingLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:self.bindingLabel];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 59, 304 - 10, 1)];
        lineView.image = [[UIImage imageNamed:@"ic_line"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self addSubview:lineView];
    }
    return self;
}

@end

@interface MISecurityAccountViewController ()

@end

@implementation MISecurityAccountViewController
@synthesize headView, contentview;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.baseTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_request cancelRequest];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBarTitle:@"安全检测"];
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(8, self.navigationBarHeight + 10, 304, 60)];
    headView.backgroundColor = [UIColor blackColor];
    headView.alpha = 0.7;
    headView.layer.cornerRadius = 3;
    headView.layer.masksToBounds = YES;
    headView.hidden = YES;
    
    _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, headView.viewWidth - 10, 60)];
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    self.remindLabel.backgroundColor = [UIColor clearColor];
    self.remindLabel.textColor = [UIColor whiteColor];
    self.remindLabel.font = [UIFont systemFontOfSize:12];
    self.remindLabel.numberOfLines = 0;
    self.remindLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [headView addSubview:self.remindLabel];
    [self.view addSubview:headView];
    
    contentview = [[UIView alloc] initWithFrame:CGRectMake(8, headView.bottom + 10, 304, self.view.viewHeight - (headView.bottom + 10) - 10)];
    contentview.backgroundColor = [UIColor whiteColor];
    contentview.hidden = YES;
    [self.view addSubview:contentview];
    
    _baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, contentview.viewWidth, 180) style:UITableViewStylePlain];
    _baseTableView.separatorColor = [UIColor grayColor];
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.scrollEnabled = NO;
    [contentview addSubview:self.baseTableView];;
    
    RTLabel *footLabel = [[RTLabel alloc] initWithFrame:CGRectMake(0, contentview.viewHeight - 25, contentview.viewWidth, 25)];
    footLabel.backgroundColor = [UIColor clearColor];
    footLabel.text = @"手机暂不支持修改绑定，如需修改请前往<u color=blue>mizhe.com</u>";
    footLabel.textAlignment = RTTextAlignmentCenter;
    footLabel.textColor = [UIColor lightGrayColor];
    footLabel.font = [UIFont systemFontOfSize:12];
    footLabel.userInteractionEnabled = YES;
    [contentview addSubview:footLabel];
    if ([MIMainUser getInstance].phoneNum && ![[MIMainUser getInstance].phoneNum isEqualToString:@""]) {
        footLabel.hidden = NO;
    }else{
        footLabel.hidden = YES;
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMiZhe)];
    [footLabel addGestureRecognizer:singleTap];

    __weak typeof(self) weakSelf = self;
    _request = [[MIUserGetRequest alloc] init];
    _request.onCompletion = ^(MIUserGetModel * model) {
        [weakSelf finishLoadTableViewData:model];
    };
    _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };
    [_request sendQuery];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];

}
- (void)finishLoadTableViewData:(MIUserGetModel *)data
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    [[MIMainUser getInstance] saveUserInfo:data];
    
    headView.hidden = NO;
    contentview.hidden = NO;
    if (data.userName && data.userName.length && (![data.userName hasSuffix:@"@open.mizhe"])
        && data.tel && data.tel.length
        && data.alipay && data.alipay.length)
    {
        self.remindLabel.text = @"太棒了！您已完成所有的安全选项设置，可以放心的购物！";
    }
    else
    {
        self.remindLabel.text = @"为了保证您的账户安全，请及时完成以下安全选项，打造安全的米折账户。";
    }
    [self.baseTableView reloadData];
}

- (void)failLoadTableViewData
{
    [self setOverlayStatus:EOverlayStatusError labelText:nil];
}

- (void)gotoMiZhe
{
    MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
    cancelItem.action = nil;
    
    MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"好"];
    affirmItem.action = ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[MIConfig globalConfig].securityCenterURL]];
    };
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"米姑娘提示"
                                                        message:@"即将打开Safari前往米折网安全中心"
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:affirmItem, nil];
    [alertView show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MIMainUser *mainUser = [MIMainUser getInstance];
    switch (indexPath.row)
    {
        case 0:
            if ((mainUser.loginAccount == nil) || (mainUser.loginAccount.length == 0) || ([mainUser.loginAccount hasSuffix:@"@open.mizhe"]))
            {
                cell.bindingLabel.hidden = NO;
                cell.titleLabel.text = @"未绑定邮箱";
                cell.detailLabel.text = @"忘记密码时，此邮箱可以帮您找回密码。";
                cell.headImageView.image = [UIImage imageNamed:@"ic_undo"];
            }
            else
            {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.bindingLabel.hidden = YES;
                cell.titleLabel.text = @"已绑定邮箱";
                cell.detailLabel.text = [mainUser.loginAccount getSimpleEmailString];
                cell.headImageView.image = [UIImage imageNamed:@"ic_done"];
            }
            break;
        case 1:
            if ((mainUser.phoneNum == nil) || (mainUser.phoneNum.length == 0))
            {
                cell.bindingLabel.hidden = NO;
                cell.titleLabel.text = @"未绑定手机";
                cell.detailLabel.text = @"绑定手机后，可有效保障您的账户和资金安全！";
                cell.headImageView.image = [UIImage imageNamed:@"ic_undo"];
            }
            else
            {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.bindingLabel.hidden = YES;
                cell.titleLabel.text = @"已绑定手机";
                cell.detailLabel.text = [mainUser.phoneNum getSimpleEmailString];
                cell.headImageView.image = [UIImage imageNamed:@"ic_done"];
            }
            break;
        case 2:
            if ((mainUser.alipay == nil) || (mainUser.alipay.length == 0))
            {
                cell.bindingLabel.hidden = NO;
                cell.titleLabel.text = @"未绑定支付宝";
                cell.detailLabel.text = @"绑定后，返利收入将确保提现到您的支付宝上。";
                cell.headImageView.image = [UIImage imageNamed:@"ic_undo"];
            }
            else
            {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.bindingLabel.hidden = YES;
                cell.titleLabel.text = @"已绑定支付宝";
                cell.detailLabel.text = [mainUser.alipay getSimpleEmailString];
                cell.headImageView.image = [UIImage imageNamed:@"ic_done"];
            }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MIMainUser *mainUser = [MIMainUser getInstance];
    switch (indexPath.row)
    {
        case 0:
            if ((mainUser.loginAccount == nil) || (mainUser.loginAccount.length == 0) || ([mainUser.loginAccount hasSuffix:@"@open.mizhe"]))
            {
                [MINavigator openBindEmailViewController];
            }
            break;
        case 1:
            if ((mainUser.phoneNum == nil) || (mainUser.phoneNum.length == 0))
            {
                MIPhoneSettingViewController *vc = [[MIPhoneSettingViewController alloc] init];
                [[MINavigator navigator] openPushViewController:vc animated:YES];
            }
            break;
        case 2:
            if ((mainUser.alipay == nil) || (mainUser.alipay.length == 0))
            {
                if ((mainUser.loginAccount == nil) || (mainUser.loginAccount.length == 0) || ([mainUser.loginAccount hasSuffix:@"@open.mizhe"]))
                {
                    [self showSimpleHUD:@"请先绑定邮箱" afterDelay:1.3];
                } else if ((mainUser.phoneNum == nil) || (mainUser.phoneNum.length == 0))
                {
                    [self showSimpleHUD:@"请先绑定手机号码" afterDelay:1.3];
                } else
                {
                    MIAlipaySettingViewController *vc = [[MIAlipaySettingViewController alloc] init];
                    vc.barTitle = @"绑定支付宝";
                    [[MINavigator navigator] openPushViewController:vc animated:YES];
                }
            }
            break;
        default:
            break;
    }
}
//
//- (NSString *)getSimpleStringFrom:(NSString *)aString
//{
//    NSString *simpleString;
//    if ([aString rangeOfString:@"@"].location != NSNotFound)
//    {
//        if ([aString substringToIndex:[aString rangeOfString:@"@"].location].length > 2)
//        {
//            simpleString = [aString stringByReplacingCharactersInRange:NSMakeRange(2, [aString rangeOfString:@"@"].location- 2) withString:@"***"];
//        }
//        else
//        {
//            simpleString = [aString stringByReplacingCharactersInRange:NSMakeRange(1, [aString rangeOfString:@"@"].location- 1) withString:@"***"];
//        }
//    }
//    else
//    {
//        if (aString.length >= 11) {
//            simpleString = [aString stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//        } else if (aString.length > 2) {
//            simpleString = [aString stringByReplacingCharactersInRange:NSMakeRange(1, aString.length - 2) withString:@"***"];
//        } else {
//            simpleString = [aString stringByReplacingCharactersInRange:NSMakeRange(1, aString.length - 1) withString:@"***"];
//        }
//    }
//    
//    return simpleString;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
