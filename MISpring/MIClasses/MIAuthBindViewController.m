//
//  MIAuthBindViewController.m
//  MISpring
//
//  Created by 徐 裕健 on 13-9-3.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIAuthBindViewController.h"
#import "MITaobaoAuthViewController.h"
#import "MITaobaoAuth.h"
#import "MISinaWeibo.h"
#import "MITencentAuth.h"

@interface MIAuthBindCell:UITableViewCell

@property(nonatomic, strong) UISwitch * authBindSwitch;

@end

@implementation MIAuthBindCell
@synthesize authBindSwitch;

- (id) initWithreuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        
        authBindSwitch = [[UISwitch alloc] init];
        authBindSwitch.center = CGPointMake(265, 22);
        [self addSubview:authBindSwitch];
    }
    
    return self;
}

@end

@implementation MIAuthBindViewController

- (void)loadView
{
    [super loadView];
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _baseTableView.frame = CGRectMake(0, 0, 320, PHONE_SCREEN_SIZE.height - PHONE_NAVIGATIONBAR_HEIGHT);
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self miSetNavigationBarTitle:@"绑定分享"];
    
    [_baseTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create submit button cell at the end of the table view
    static NSString *cellIdentifier = @"TableViewCellReuseIdentifier";
    MIAuthBindCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[MIAuthBindCell alloc] initWithreuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"ic_taobao"];
        cell.textLabel.text = @"绑定淘宝";
        cell.detailTextLabel.text = @"自动登录淘宝";
        cell.authBindSwitch.on = [[MITaobaoAuth getInstance] isAuthValid];
        [cell.authBindSwitch addTarget:self action:@selector(authBindTaobaoSwitch:) forControlEvents:UIControlEventTouchUpInside];
    } else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"ic_zone"];
        cell.textLabel.text = @"绑定QQ空间";
        cell.detailTextLabel.text = @"分享到QQ空间";
        cell.authBindSwitch.on = [[MITencentAuth getInstance] isAuthValid];
        [cell.authBindSwitch addTarget:self action:@selector(authBindQQSwitch:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"ic_sina"];
        cell.textLabel.text = @"绑定新浪微博";
        cell.detailTextLabel.text = @"分享到新浪微博";
        cell.authBindSwitch.on = [[MISinaWeibo getInstance] isAuthValid];
        [cell.authBindSwitch addTarget:self action:@selector(authBindWeiboSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (void) authBindTaobaoSwitch:(UISwitch *)bindSwitch
{
    MILog(@"bind taobao");
    MITaobaoAuth *taobaoAuth = [MITaobaoAuth getInstance];
    if ([taobaoAuth isAuthValid]) {
        [taobaoAuth logOut];
    } else {
        [taobaoAuth logIn:nil title:nil];
    }
}

- (void) authBindQQSwitch:(UISwitch *)bindSwitch
{
    MILog(@"bind qq");
    MITencentAuth *tencentAuth = [MITencentAuth getInstance];
    if ([tencentAuth isAuthValid]) {
        [tencentAuth logOut];
    } else {
        [tencentAuth logIn:nil];
    }
}

- (void) authBindWeiboSwitch:(UISwitch *)bindSwitch
{
    MILog(@"bind weibo");
    MISinaWeibo *sinaWeibo = [MISinaWeibo getInstance];
    if ([sinaWeibo isAuthValid])
    {
        [sinaWeibo logOut];
    } else {
        [sinaWeibo logIn:nil];
    }
}
@end
