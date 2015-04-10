//
//  MIListTableViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 15/3/26.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIListTableViewController.h"
#import "MIRowTableView.h"
#import "MITuanHotGetRequest.h"
#import "MITuanActivityGetRequest.h"


@interface MIListTableViewController ()
{
    NSInteger       _currentIndex;

}
@end

@implementation MIListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBarTitle:self.catName];
    
    MIRowTableView *tableView = [[MIRowTableView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight)];
    [tableView willAppearView];
    [self.view addSubview:tableView];
    
    [self.view bringSubviewToFront:self.navigationBar];
    
    if ([self.target isEqualToString:@"tuan_hot"])
    {
        MITuanHotGetRequest *request = [[MITuanHotGetRequest alloc] init];
        [request setCat:self.data];
        request.onCompletion = ^(MITuanHotGetModel *model) {
            [tableView finishHotLoadTableViewData:model];
        };
        
        request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [tableView failLoadTableViewData];
            MILog(@"error_msg=%@",error.description);
        };
        tableView.request = request;
    }
    else
    {
        MITuanActivityGetRequest *request = [[MITuanActivityGetRequest alloc] init];
        [request setCat:self.data];
        request.onCompletion = ^(MITuanActivityGetModel *model) {
            [tableView finishActivityLoadTableViewData:model];
        };
        
        request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [tableView failLoadTableViewData];
            MILog(@"error_msg=%@",error.description);
        };
        tableView.request = request;
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
