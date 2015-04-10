//
//  MIAboutViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-4-7.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIAboutViewController.h"
#import "MIAppDelegate.h"
#import "MIConfig.h"
#import "MobClick.h"
#import "MIFunctionViewController.h"

@implementation MIAboutViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationBar setBarTitle:@"关于米折"  textSize:20.0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"website_logo"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.viewWidth - 190)/2, 30 + self.navigationBarHeight, 190, 68)];
    imageView.image = image;
    [self.view addSubview: imageView];
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 15, SCREEN_WIDTH, 20)];
    version.backgroundColor = [UIColor clearColor];
    version.font = [UIFont systemFontOfSize:14];
    version.textColor = [UIColor grayColor];
    version.textAlignment = UITextAlignmentCenter;
    version.text = [NSString stringWithFormat:@"当前版本 v%@", [MIConfig globalConfig].version];
    version.shadowColor = [UIColor whiteColor];
    [version setShadowOffset: CGSizeMake(0, -1.0)];
    [self.view addSubview:version];
    
    float tableViewHeight = self.view.viewHeight - self.navigationBarHeight - imageView.viewHeight - 60 - 45;
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _baseTableView.frame = CGRectMake(0, version.bottom + 10, SCREEN_WIDTH, tableViewHeight);
    _baseTableView.backgroundColor = [UIColor whiteColor];
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.scrollEnabled = NO;
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    
    RTLabel *copyRight = [[RTLabel alloc] initWithFrame:CGRectMake(0, self.view.viewHeight - 50, SCREEN_WIDTH, 50)];
    copyRight.backgroundColor = [UIColor clearColor];
    copyRight.font = [UIFont systemFontOfSize:14];
    copyRight.textColor = [UIColor grayColor];
    copyRight.textAlignment = RTTextAlignmentCenter;
    copyRight.text = @"©2011-2014 米折网\n All rights reserved.";
    [self.view addSubview:copyRight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            if ([[Reachability reachabilityForInternetConnection] isReachable]) {
                MIAppDelegate* delegate = (MIAppDelegate*)[[UIApplication sharedApplication] delegate];
                delegate.bAppManualUpdate = YES;
                [MobClick checkUpdate];
            } else {
                [self showSimpleHUD:@"网络不给力"];
            }
            break;
        }
        case 1:
        {
            MIFunctionViewController *vc = [[MIFunctionViewController alloc] init];
            [[MINavigator navigator] openPushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            MIModalWebViewController* vc = [[MIModalWebViewController alloc] initWithURL:[NSURL URLWithString:[MIConfig globalConfig].specialNoticeURL]];
            vc.webPageTitle = @"米折网特别声明";
            [[MINavigator navigator] openModalViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            MIModalWebViewController* vc = [[MIModalWebViewController alloc] initWithURL:[NSURL URLWithString:[MIConfig globalConfig].agreementURL]];
            vc.webPageTitle = @"米折网用户使用协议";
            [[MINavigator navigator] openModalViewController:vc animated:YES];

            break;
        }
        default:
            break;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellReuseIdentifier"];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TableViewCellReuseIdentifier"];
        cell.backgroundColor = [UIColor whiteColor];
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"检查更新";
                MIAppDelegate* delegate = (MIAppDelegate*)[[UIApplication sharedApplication] delegate];
                if (delegate.appNewVersion) {
                    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"有新版本v%@", delegate.appNewVersion];
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                    cell.detailTextLabel.textColor = [UIColor blueColor];
                }
                break;
            }
            case 1:
                cell.textLabel.text = @"功能介绍";
                break;
            case 2:
                cell.textLabel.text = @"特别声明";
                break;
            case 3:
                cell.textLabel.text = @"米折网用户协议";
                break;
            default:
                break;
        }
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;

}
@end
