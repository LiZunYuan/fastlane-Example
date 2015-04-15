//
//  MIVIPCenterViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 13-11-20.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIVIPCenterViewController.h"
#import "MIUserVipLevelGetModel.h"
#import "MIVipModel.h"
#import "MIUpYun.h"
#import "MIUpdateGradeViewController.h"
#import "MIModifyNickNameViewController.h"

#define MIAPP_ALL_MALLS_UPDATE_INTERVAL -7*24*60*60

@interface UpdateGradeCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) MIVipModel *vipModel;
@property (nonatomic, strong) UIImageView *gradeImageView;
@property (nonatomic, strong) RTLabel *rebatePersentLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation UpdateGradeCell
@synthesize gradeImageView,rebatePersentLabel,statusLabel,index,vipModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        gradeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12.5, 8, 10.5)];
        [self addSubview:gradeImageView];
        
        rebatePersentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(gradeImageView.right + 4, 11, 162, 20)];
        rebatePersentLabel.backgroundColor = [UIColor clearColor];
        rebatePersentLabel.textColor = [UIColor grayColor];
        rebatePersentLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:rebatePersentLabel];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80 - 20, 5, 60, 25)];
        statusLabel.layer.cornerRadius = 2;
        statusLabel.layer.masksToBounds = YES;
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:statusLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wantToUpdate)];
        [statusLabel addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)wantToUpdate
{
    [MobClick event:kVipUpdateClicks];

    MIUpdateGradeViewController *updateView = [[MIUpdateGradeViewController alloc] init];
    updateView.indexOfGrade = index;
    updateView.vipModel = vipModel;
    [[MINavigator navigator] openPushViewController:updateView animated:YES];
}

@end


#pragma mark -MIVIPCenterViewController
@interface MIVIPCenterViewController ()

@property (nonatomic, strong) NSArray *memberStringArray;
@property (nonatomic, strong) NSArray *memberColorStringArray;
@property (nonatomic, strong) NSArray *memberColorIntArray;
@end

@implementation MIVIPCenterViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _memberStringArray = [[NSArray alloc] initWithObjects:@"普通会员",@"铜牌会员",@"银牌会员",@"金牌会员",@"白金会员",@"钻石会员", nil];
        _memberColorStringArray = [[NSArray alloc] initWithObjects:@"#9b9b9b",@"#c39155",@"#f7a10f",@"#ed6b12",@"#e12c15",@"#be1586", nil];
        _memberColorIntArray = [[NSArray alloc] initWithObjects:@(0x9b9b9b),@(0xc39155),@(0xf7a10f),@(0xed6b12),@(0xe12c15),@(0xbe1586), nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger grade = [MIMainUser getInstance].grade.integerValue;
    NSString *currentGradeImagePath = [NSString stringWithFormat:@"ic_vip_v%ld",(long)grade];
    self.currentGradeImageView.image = [UIImage imageNamed:currentGradeImagePath];
    self.circleImageView.transform = CGAffineTransformMakeTranslation(((PHONE_SCREEN_SIZE.width - 20 - 20 * 2)/5.0 - 2) * grade, 0);
    
    if (self.memberStringArray.count > grade) {
        self.gradeLabel.text = [self.memberStringArray objectAtIndex:grade];
        NSInteger textColor = [[self.memberColorIntArray objectAtIndex:grade] integerValue];
        self.gradeLabel.textColor = [MIUtility colorWithHex:textColor];
    }
    
    UILabel *persentRebateLabel = (UILabel *)[self.firstView viewWithTag:100+grade];
    persentRebateLabel.textColor = [MIUtility colorWithHex:0xed6b12];
    
    if ([MIMainUser getInstance].headURL && ([MIMainUser getInstance].headURL.length != 0))
    {
        NSString *headUrl = [NSString stringWithFormat:@"%@!100x100.jpg", [MIMainUser getInstance].headURL];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString: headUrl] placeholderImage:[UIImage imageNamed:@"ic_my_square"]];
        MILog(@"%@",headUrl);
    }
    
    NSString *userName = (([MIMainUser getInstance].nickName == nil) || ([MIMainUser getInstance].nickName.length == 0)) ? [MIMainUser getInstance].loginAccount : [MIMainUser getInstance].nickName;
    NSRange range = [userName rangeOfString:@"@"];
    if (range.location != NSNotFound) {
        userName = [userName substringToIndex:range.location];
    }
    self.nickNameLabel.text = userName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBarTitle:@"个人中心"];
    
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight)];
    self.baseScrollView.showsVerticalScrollIndicator = YES;
    self.baseScrollView.contentSize = CGSizeMake(PHONE_SCREEN_SIZE.width, 575);
    [self.view sendSubviewToBack:self.baseScrollView];
    
    UIView *userInfoBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, PHONE_SCREEN_SIZE.width - 20, 120)];
    userInfoBgView.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.15].CGColor;
    userInfoBgView.layer.borderWidth = .8;
    userInfoBgView.layer.cornerRadius = 4;
    userInfoBgView.layer.masksToBounds = YES;
    userInfoBgView.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:userInfoBgView];
    //修改头像
    UIView *avatarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width - 20, 60)];
    avatarBgView.backgroundColor = [UIColor clearColor];
    [userInfoBgView addSubview:avatarBgView];
    
    UITapGestureRecognizer *modifyHeadImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyHeadImage)];
    [avatarBgView addGestureRecognizer:modifyHeadImage];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    [avatarBgView addSubview:self.avatarImageView];
    
    UILabel *modifyAvatarLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarBgView.viewWidth - 60 - 30, 0, 60, 60)];
    modifyAvatarLabel.backgroundColor = [UIColor clearColor];
    modifyAvatarLabel.text = @"修改头像";
    modifyAvatarLabel.textColor = [UIColor lightGrayColor];
    modifyAvatarLabel.textAlignment = NSTextAlignmentLeft;
    modifyAvatarLabel.font = [UIFont systemFontOfSize:14];
    [avatarBgView addSubview:modifyAvatarLabel];
    
    UIImageView *modifyAvatarArrows = [[UIImageView alloc] initWithFrame:CGRectMake(modifyAvatarLabel.right+5, 0, 10, 15)];
    modifyAvatarArrows.centerY = modifyAvatarLabel.centerY;
    modifyAvatarArrows.image = [UIImage imageNamed:@"ic_avatar_arrow"];
    [avatarBgView addSubview:modifyAvatarArrows];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 59.4, userInfoBgView.viewWidth, 0.6)];
    lineView1.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.15];
    [userInfoBgView addSubview:lineView1];
    
    //修改昵称
    UIView *nickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, avatarBgView.bottom, PHONE_SCREEN_SIZE.width - 20, 60)];
    nickBgView.backgroundColor = [UIColor clearColor];
    [userInfoBgView addSubview:nickBgView];
    
    UITapGestureRecognizer *modifyNick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyNick)];
    [nickBgView addGestureRecognizer:modifyNick];
    
    _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, nickBgView.viewWidth - 20 - 100, 20)];
    _nickNameLabel.backgroundColor = [UIColor clearColor];
    _nickNameLabel.textColor = [UIColor darkGrayColor];
    _nickNameLabel.font = [UIFont systemFontOfSize:16];
    [nickBgView addSubview:_nickNameLabel];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.nickNameLabel.bottom, nickBgView.viewWidth - 20 - 100, 20)];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.text = [MIMainUser getInstance].loginAccount;
    emailLabel.textColor = [UIColor lightGrayColor];
    emailLabel.font = [UIFont systemFontOfSize:12];
    emailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [nickBgView addSubview:emailLabel];
    
    UILabel *modifyNickLabel = [[UILabel alloc] initWithFrame:CGRectMake(nickBgView.viewWidth - 60 - 30, 0, 60, 60)];
    modifyNickLabel.backgroundColor = [UIColor clearColor];
    modifyNickLabel.text = @"修改昵称";
    modifyNickLabel.textColor = [UIColor lightGrayColor];
    modifyNickLabel.textAlignment = NSTextAlignmentLeft;
    modifyNickLabel.font = [UIFont systemFontOfSize:14];
    [nickBgView addSubview:modifyNickLabel];
    
    UIImageView *modifyNickArrows = [[UIImageView alloc] initWithFrame:CGRectMake(modifyNickLabel.right+5, 0, 10, 15)];
    modifyNickArrows.centerY = modifyNickLabel.centerY;
    modifyNickArrows.image = [UIImage imageNamed:@"ic_avatar_arrow"];
    [nickBgView addSubview:modifyNickArrows];
    
    //VIP会员特权
    _firstView = [[UIView alloc] initWithFrame:CGRectMake(10, 140, PHONE_SCREEN_SIZE.width - 20, 160)];
    self.firstView.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.15].CGColor;
    self.firstView.layer.borderWidth = .8;
    self.firstView.layer.cornerRadius = 4;
    self.firstView.layer.masksToBounds = YES;
    self.firstView.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:self.firstView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.firstView.viewWidth, 25)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"VIP会员特权";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.firstView addSubview:titleLabel];
    
    UIImageView *vipGradeLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, _firstView.viewWidth - 20 * 2, 8)];
    vipGradeLineImageView.image = [UIImage imageNamed:@"ic_vip_level_indicator"];
    [self.firstView addSubview:vipGradeLineImageView];
    
    
    UIImageView *v0ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(vipGradeLineImageView.left-3, vipGradeLineImageView.top - 15, 8, 10.5)];
    v0ImageView.image = [UIImage imageNamed:@"ic_vip_v0"];
    [self.firstView addSubview:v0ImageView];
    
    
    UIImageView *v5ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(vipGradeLineImageView.right-3, vipGradeLineImageView.top - 15, 8, 10.5)];
    v5ImageView.image = [UIImage imageNamed:@"ic_vip_v5"];
    [self.firstView addSubview:v5ImageView];
    
    
    _circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9, 9)];
    self.circleImageView.image = [UIImage imageNamed:@"ic_vip_cricle"];
    [vipGradeLineImageView addSubview:self.circleImageView];
    
    for (NSInteger i = 0; i < 6; i++)
    {
        UILabel *persentRebateLabel = [[UILabel alloc] initWithFrame:CGRectMake(12 + (vipGradeLineImageView.viewWidth / 5.0 - 3) * i, 80, 40, 12)];
        persentRebateLabel.backgroundColor = [UIColor clearColor];
        persentRebateLabel.tag = 100+i;
        persentRebateLabel.textColor = [UIColor grayColor];
        persentRebateLabel.font = [UIFont systemFontOfSize:12];
        [self.firstView addSubview:persentRebateLabel];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 104, self.firstView.viewWidth, 0.6)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.15];
    [self.firstView addSubview:lineView];
    
    UILabel *currentGradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(v0ImageView.left, 115, 60, 15)];
    currentGradeLabel.backgroundColor = [UIColor clearColor];
    currentGradeLabel.text = @"当前等级：";
    currentGradeLabel.textColor = [UIColor grayColor];
    currentGradeLabel.font = [UIFont systemFontOfSize:12];
    [self.firstView addSubview:currentGradeLabel];
    
    _currentGradeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentGradeLabel.right, 116, 8, 10.5)];
    [self.firstView addSubview:self.currentGradeImageView];
    
    _gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.currentGradeImageView.right+2, currentGradeLabel.top, 100, currentGradeLabel.viewHeight)];
    self.gradeLabel.backgroundColor = [UIColor clearColor];
    self.gradeLabel.font = [UIFont systemFontOfSize:12];
    [self.firstView addSubview:self.gradeLabel];
    
    UILabel *gradePrivilegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentGradeLabel.left, 135, currentGradeLabel.viewWidth, currentGradeLabel.viewHeight)];
    gradePrivilegeLabel.backgroundColor = [UIColor clearColor];
    gradePrivilegeLabel.text = @"等级特权：";
    gradePrivilegeLabel.textColor = [UIColor grayColor];
    gradePrivilegeLabel.font = [UIFont systemFontOfSize:12];
    [self.firstView addSubview:gradePrivilegeLabel];
    
    _privilegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(gradePrivilegeLabel.right, gradePrivilegeLabel.top, 200, gradePrivilegeLabel.viewHeight)];
    self.privilegeLabel.backgroundColor = [UIColor clearColor];
    self.privilegeLabel.textColor = [UIColor grayColor];
    self.privilegeLabel.font = [UIFont systemFontOfSize:12];
    [self.firstView addSubview:self.privilegeLabel];
    
    _gradeTableView = [[UITableView alloc] initWithFrame:CGRectMake(10,310, PHONE_SCREEN_SIZE.width - 20,255) style:UITableViewStylePlain];
    self.gradeTableView.scrollEnabled = NO;
    self.gradeTableView.delegate = self;
    self.gradeTableView.dataSource = self;
    self.gradeTableView.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.15].CGColor;
    self.gradeTableView.layer.borderWidth = .8;
    self.gradeTableView.backgroundColor = [UIColor whiteColor];
    self.gradeTableView.layer.cornerRadius = 4;
    self.gradeTableView.layer.masksToBounds = YES;
    self.gradeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.baseScrollView addSubview:self.gradeTableView];
	// Do any additional setup after loading the view.
    
    NSString *adsDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"vip.rules.data"];
    NSDictionary *attrDict = [[NSFileManager defaultManager] attributesOfItemAtPath:adsDataPath error:NULL];
    NSDate *fileModifiedDate = [attrDict objectForKey:NSFileModificationDate];
    MILog(@"MIAPP_HOT_MALLS_UPDATE_INTERVAL=%f", [fileModifiedDate timeIntervalSinceNow]);
    
    if (attrDict != nil && [fileModifiedDate timeIntervalSinceNow] > MIAPP_ALL_MALLS_UPDATE_INTERVAL)
    {
        NSArray *vips = [NSKeyedUnarchiver unarchiveObjectWithFile:adsDataPath];
        [self finishLoadMemberRules:vips];
    }
    else
    {
        //request
        __weak typeof(self) weakSelf = self;
        _request = [[MIUserVIPLevelRequest alloc] init];
        _request.onCompletion = ^(MIUserVipLevelGetModel *model) {
            [NSKeyedArchiver archiveRootObject:model.vips toFile:[[MIMainUser documentPath] stringByAppendingPathComponent:@"vip.rules.data"]];
            [weakSelf finishLoadMemberRules:model.vips];
        };
        _request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [weakSelf setOverlayStatus:EOverlayStatusError labelText:nil];
            MILog(@"error_msg=%@",error.description);
        };
        [_request sendQuery];
        [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_request cancelRequest];
}
- (void)modifyNick
{
    [MobClick event:kUpdateNickClicks];
    
    MIModifyNickNameViewController *modifyNickVC = [[MIModifyNickNameViewController alloc] initWithNickName:[MIMainUser getInstance].nickName];
    [[MINavigator navigator] openPushViewController:modifyNickVC animated:YES];
}
- (void)modifyHeadImage
{
    MIUpYun *upYun = [MIUpYun getInstance];
    [upYun modifyHeadImage];
}

- (void)goToHowToUpdateView
{
    MIModalWebViewController* vc = [[MIModalWebViewController alloc] initWithURL:[NSURL URLWithString:[MIConfig globalConfig].howToUpdateLevelURL]];
    vc.webPageTitle = @"如何升级";
    [[MINavigator navigator] openModalViewController:vc animated:YES];
}

- (void)finishLoadMemberRules:(NSArray *)vips
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    _vips = [[NSArray alloc] initWithArray:vips];
    for (NSInteger i = 0; i < vips.count; i++)
    {
        ((UILabel *)[self.firstView viewWithTag:100+i]).text = [NSString stringWithFormat:@"+%.0f%@",((MIVipModel *)[vips objectAtIndex:i]).extraRate.floatValue*100,@"%"];
    }
    if (vips.count > [MIMainUser getInstance].grade.integerValue) {
        MIVipModel * vipModel = [vips objectAtIndex:[MIMainUser getInstance].grade.integerValue];
        NSInteger extraRate = vipModel.extraRate.floatValue *100;
        if (0 == extraRate)
        {
            self.privilegeLabel.text = @"无特权";
        }
        else
        {
            if (vipModel.doubleCoin.boolValue) {
                self.privilegeLabel.text = [NSString stringWithFormat: @"淘宝返利加送%ld%@ 米币奖励翻倍",(long)extraRate,@"%"];
            } else {
                self.privilegeLabel.text = [NSString stringWithFormat: @"淘宝返利加送%ld%@",(long)extraRate,@"%"];
            }
        }
    }
    [self.gradeTableView reloadData];
}


#pragma mark - UITabelView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
     return 6;
 }
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellIdentifier = @"cell";
     UpdateGradeCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
     if (cell == nil) {
         cell = [[UpdateGradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
     }
    NSString *currentGradeImagePath = [NSString stringWithFormat:@"ic_vip_v%ld",(long)indexPath.row];
    cell.gradeImageView.image = [UIImage imageNamed:currentGradeImagePath];
    if (self.vips.count > indexPath.row && self.memberStringArray.count > indexPath.row) {
        NSInteger extraRate = ((MIVipModel *)[self.vips objectAtIndex:indexPath.row]).extraRate.floatValue*100;
        NSString *colorString = [self.memberColorStringArray objectAtIndex:indexPath.row];
        NSString *memberString = [self.memberStringArray objectAtIndex:indexPath.row];
        if (0 == indexPath.row)
        {
            cell.rebatePersentLabel.text = [NSString stringWithFormat:@"<font color='%@'>%@</font>  无特权",colorString,memberString];
        }
        else
        {
            cell.rebatePersentLabel.text = [NSString stringWithFormat: @"<font color='%@'>%@</font>  返利加送%ld%@",colorString,memberString,(long)extraRate,@"%"];
        }
        
    }
    
    if (indexPath.row < [MIMainUser getInstance].grade.intValue)
    {
        cell.statusLabel.backgroundColor = [UIColor clearColor];
        cell.statusLabel.text = @"/";
        cell.statusLabel.textColor = [UIColor grayColor];
        cell.statusLabel.userInteractionEnabled = NO;
    }
    else if (indexPath.row == [MIMainUser getInstance].grade.intValue)
    {
        cell.statusLabel.backgroundColor = [UIColor clearColor];
        cell.statusLabel.text = @"当前等级";
        cell.statusLabel.textColor = [MIUtility colorWithHex:0xff6600];
        cell.statusLabel.userInteractionEnabled = NO;
    }
    else
    {
        cell.statusLabel.backgroundColor = [MIUtility colorWithHex:0xFFA727];
        cell.statusLabel.text = @"我要升级";
        cell.statusLabel.textColor = [UIColor whiteColor];
        cell.statusLabel.userInteractionEnabled = YES;
    }
    cell.index = indexPath.row;
    if (self.vips.count > indexPath.row) {
        cell.vipModel = (MIVipModel *)[self.vips objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.viewWidth, 40)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, view.viewHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"VIP会员等级及特权";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:titleLabel];
    
    UILabel *howToUpdate = [[UILabel alloc] initWithFrame:CGRectMake(view.viewWidth - 80, 0, 80, view.viewHeight)];
    howToUpdate.backgroundColor = [UIColor clearColor];
    howToUpdate.text = @"如何升级？";
    howToUpdate.textColor = [MIUtility colorWithHex:0x226c91];
    howToUpdate.font = [UIFont boldSystemFontOfSize:14];
    howToUpdate.userInteractionEnabled = YES;
    [view addSubview:howToUpdate];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToHowToUpdateView)];
    [howToUpdate addGestureRecognizer:tap];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.4, view.viewWidth, 0.6)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.15];
    [view addSubview:lineView];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
