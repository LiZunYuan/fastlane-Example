//
//  MIBaseViewController+MIMallAllViewController.m
//  MISpring
//
//  Created by Mac Chow on 13-3-21.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMallAllViewController.h"
#import "MallSearchItemTableViewCell.h"
#import "MIMallModel.h"
#import "MIMallReloadModel.h"

#define MIAPP_ALL_MALLS_UPDATE_INTERVAL -7*24*60*60

@implementation MIMallAllViewController:MIBaseViewController

@synthesize keywords = _keywords;
@synthesize sections = _sections;
@synthesize sectionsData = _sectionsData;
@synthesize mallReloadAllRequest = _mallReloadAllRequest;
@synthesize searchMallsRequest = _searchMallsRequest;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.needRefreshView = YES;
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, self.view.viewHeight - self.navigationBarHeight);
    _baseTableView.backgroundColor = [UIColor whiteColor];
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    _baseTableView.hidden = YES;

    
    self.loading = YES;
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    
    __weak typeof(self) wself = self;
    
    if (self.keywords == nil) {
        _mallReloadAllRequest = [[MIMallReloadRequest alloc] init];
        [_mallReloadAllRequest setType:[NSNumber numberWithBool:FALSE]];
        [_mallReloadAllRequest setLast:[NSNumber numberWithInt:0]];
        [_mallReloadAllRequest setSummary:[NSNumber numberWithBool:TRUE]];
        _mallReloadAllRequest.onCompletion = ^(MIMallReloadModel *model) {
            [NSKeyedArchiver archiveRootObject:model.malls toFile:[[MIMainUser documentPath] stringByAppendingPathComponent:@"all.malls.data"]];
            [wself finishLoadTableViewData:model.malls];
        };
        
        _mallReloadAllRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [wself failLoadTableViewData];
            MILog(@"error_msg=%@",error.description);
        };
        
        NSString *adsDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"all.malls.data"];
        NSDictionary *attrDict = [[NSFileManager defaultManager] attributesOfItemAtPath:adsDataPath error:NULL];
        NSDate *fileModifiedDate = [attrDict objectForKey:NSFileModificationDate];
        MILog(@"MIAPP_HOT_MALLS_UPDATE_INTERVAL=%f", [fileModifiedDate timeIntervalSinceNow]);
        
        if (attrDict != nil && [fileModifiedDate timeIntervalSinceNow] > MIAPP_ALL_MALLS_UPDATE_INTERVAL) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                           {
                               NSArray *malls = [NSKeyedUnarchiver unarchiveObjectWithFile:adsDataPath];
                               dispatch_async(dispatch_get_main_queue(), ^
                                              {
                                                  [self finishLoadTableViewData:malls];
                                              });
                           });
        } else {
            [_mallReloadAllRequest sendQuery];
        }
    } else {
        _searchMallsRequest = [[MIMallGetRequest alloc] init];
        [_searchMallsRequest setQ:self.keywords];
        _searchMallsRequest.onCompletion = ^(MIMallGetModel *model) {
            [wself finishLoadTableViewData:model.malls];
        };
        
        _searchMallsRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            [wself failLoadTableViewData];
            MILog(@"error_msg=%@",error.description);
        };
        [_searchMallsRequest sendQuery];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    if (self.keywords == nil) {
        [self.navigationBar setBarTitle:@"所有商城" textSize:20.0];
    } else {
        [self.navigationBar setBarTitle:self.keywords textSize:20.0];
    }
}

//完成加载时调用的方法
- (void)finishLoadTableViewData:(NSArray *)malls
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    
    if (self.keywords == nil) {
        NSRegularExpression * letterReg = [[NSRegularExpression alloc] initWithPattern:@"^[a-zA-Z]{1}+$" options:NSRegularExpressionCaseInsensitive error:nil];
        self.sections = [[NSMutableArray alloc] initWithCapacity: 30];
        self.sectionsData = [[NSMutableDictionary alloc] initWithCapacity: 30];
        [self.sectionsData setValue: [NSMutableArray arrayWithCapacity:50] forKey: @"#"];
        
        for (MIMallModel *mall in malls) {
            NSString * letter = [[mall.pinyin substringToIndex: 1] uppercaseString];
            NSUInteger numberOfMatches = [letterReg numberOfMatchesInString:letter options:0 range:NSMakeRange(0, 1)];
            if (numberOfMatches == 1 ) {
                if (![self.sections containsObject:letter]) {
                    [self.sections addObject: letter];
                    [self.sectionsData setValue: [NSMutableArray arrayWithCapacity:50] forKey: letter];
                }
                
                NSMutableArray * s = [self.sectionsData objectForKey: letter];
                [s addObject: mall];
            } else {
                NSMutableArray * s = [self.sectionsData objectForKey: @"#"];
                [s addObject:mall];
            }
        }
        
        [self.sections sortUsingComparator:^(NSString *oneLetter, NSString *otherLetter){
            return [oneLetter compare:otherLetter];
        }];
        [self.sections addObject:@"#"];
    } else {
        self.sections = [[NSMutableArray alloc] initWithCapacity: 1];
        self.sectionsData = [[NSMutableDictionary alloc] initWithCapacity: 1];
        [self.sections addObject:self.keywords];
        [self.sectionsData setValue: [NSMutableArray arrayWithArray:malls] forKey: self.keywords];
    }
    
    _baseTableView.hidden = NO;
    [_baseTableView reloadData];
}

- (void)reloadTableViewDataSource
{
    self.loading = YES;
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.keywords == nil) {
        [_mallReloadAllRequest cancelRequest];
        [_mallReloadAllRequest sendQuery];
    } else {
        [_searchMallsRequest cancelRequest];
        [_searchMallsRequest sendQuery];
    }
}

- (void)failLoadTableViewData
{
    [self setOverlayStatus:EOverlayStatusError labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
        [super failLoadTableViewData];
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.keywords == nil) {
        return 20;
    } else {
        return 0;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sections count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.keywords == nil) {
        return _sections;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSDictionary *)[_sectionsData objectForKey: [_sections objectAtIndex: section]] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.keywords == nil) {
        NSString *sectionTitle = [_sections objectAtIndex:section];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        label.shadowOffset = CGSizeMake(0, -0.6);
        label.text = sectionTitle;
        label.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.4f];
        [label setTextAlignment: NSTextAlignmentCenter];
        
        return label;
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MallsCell";
    
    MallSearchItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (cell == nil) {
        cell = [[MallSearchItemTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSString * key = [_sections objectAtIndex: section];
    NSArray * data = (NSArray *)[_sectionsData objectForKey: key];
    NSUInteger row = [indexPath row];
    if (row < [data count]) {
        MallSearchItemTableViewCell *_cell = (MallSearchItemTableViewCell *)cell;
        MIMallModel * model = ((MIMallModel *)[data objectAtIndex: row]);
        
        [_cell.imageView sd_setImageWithURL:[NSURL URLWithString: model.logo] placeholderImage:[UIImage imageNamed:@"mizhewang_logo"]];
        _cell.labelTitle.text = model.name;
        
        float commission;
        if (model.type.integerValue == 1 && model.mobileCommission.floatValue != 0 && self.keywords != nil) {
            //移动商城
            commission = [model.mobileCommission floatValue] / 100;
        } else {
            commission = [model.commission floatValue] / 100;
        }
        
        if (model.mode.intValue == 1) {
            //返利类型为米币
            _cell.labelCommission.text = [NSString stringWithFormat:@"最高返利%.1f%%米币", commission];
        } else {
            if (model.commissionType.intValue == 2) {
                //最高返利为按元计算
                _cell.labelCommission.text = [NSString stringWithFormat:@"最高返利%.1f元", commission];
            } else {
                //最高返利为按比例计算
                _cell.labelCommission.text = [NSString stringWithFormat:@"最高返利%.1f%%", commission];
            }
        }
        _cell.mallName = model.name;
        _cell.mallId = [NSNumber numberWithChar:model.mallId];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MIMallModel * mall = (MIMallModel *) [[_sectionsData objectForKey:[_sections objectAtIndex: [indexPath section]]] objectAtIndex: [indexPath row]];
    if ([[MIMainUser getInstance] checkLoginInfo]) {
        [self goMallShoppingWithMall:mall];
    } else {
        __weak typeof(self) weakSelf = self;
        UIAlertView *alertView = [[UIAlertView alloc] initWithLoginCancelAction:^{
            [weakSelf goMallShoppingWithMall:mall];
        }];
        [alertView show];
    }
}

- (void)goMallShoppingWithMall:(MIMallModel *)mall
{
    mall.mobileCommission = mall.commission;
    NSString *url = [NSString stringWithFormat: @"%@rebate/mobile/%@?uid=%d", [MIConfig globalConfig].goURL, mall.mallId, 1];
    MIMallWebViewController *vc = [[MIMallWebViewController alloc] initWithURL:[NSURL URLWithString:url] mall:mall];
    [[MINavigator navigator] openPushViewController: vc animated:YES];
}

@end
