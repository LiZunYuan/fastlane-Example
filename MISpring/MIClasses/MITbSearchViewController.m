//
//  MITbSearchViewController.m
//  MISpring
//
//  Created by Yujian Xu on 13-4-10.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbSearchViewController.h"

@interface MITbSuggestTableViewCell: UITableViewCell

@end

@implementation MITbSuggestTableViewCell

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    //    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, [MIUtility colorWithHex:0xEFEFEF].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 0.8));
}
@end

@interface MITbSearchViewController ()

@property(nonatomic, strong) NSString * _lastSearchString;
@property(nonatomic, strong) NSMutableArray * _suggestNums;
@property(nonatomic, strong) NSMutableArray * _suggests;
@property(nonatomic, strong) MKNetworkEngine* _suggestEngine;
@property(nonatomic, strong) MKNetworkOperation* _operation;

@end

@implementation MITbSearchViewController
@synthesize searchBar = _searchBar;
@synthesize searchDisplay = _searchDisplay;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self._suggestEngine = [[MKNetworkEngine alloc] initWithHostName:@"suggest.taobao.com" customHeaderFields:nil];
        [self._suggestEngine useCache];
        self._suggestNums = [[NSMutableArray alloc] init];
        self._suggests = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT, PHONE_SCREEN_SIZE.width, PHONE_NAVIGATION_BAR_ITEM_HEIGHT)];
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.placeholder = @"输入关键字，搜索拿返利";
    _searchBar.delegate = self;
    _searchBar.translucent = YES;
    _searchBar.showsCancelButton = YES;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.tintColor = [UIColor lightGrayColor];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    if (IOS_VERSION >= 7.0) {
        _searchBar.barTintColor = [UIColor whiteColor];
        for(UIView *subview in [[[self.searchBar subviews] objectAtIndex:0] subviews])
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subview removeFromSuperview];
                break;
            }
        }
    } else {
        [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
    }
    [_searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"search_bar_textfield_indexbg"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal];
    [self.navigationBar addSubview:_searchBar];
    
    _searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:nil];
    _searchDisplay.delegate = self;
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], UITextAttributeTextColor,nil]
        forState:UIControlStateNormal];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, _searchBar.bottom, self.view.viewWidth, self.view.viewHeight - _searchBar.viewHeight)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _rebate = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_search_fanli"]];
    _rebate.frame = CGRectMake(10, 15 , PHONE_SCREEN_SIZE.width - 20, 120);
    [_bgView addSubview:_rebate];
    
    UIButton *howToCopy = [UIButton buttonWithType:UIButtonTypeCustom];
    howToCopy.backgroundColor = [UIColor clearColor];
    howToCopy.frame = CGRectMake(0, _rebate.bottom+5 , PHONE_SCREEN_SIZE.width, 30);
    [howToCopy setTitle:@"小贴士：如何复制商品标题?" forState:UIControlStateNormal];
    [howToCopy setTitleColor:[MIUtility colorWithHex:0x999999] forState:UIControlStateNormal];
    howToCopy.titleLabel.font = [UIFont systemFontOfSize:16];
    [howToCopy addTarget:self action:@selector(howToCopy:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:howToCopy];
        
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, self.view.viewHeight - self.navigationBarHeight);
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.backgroundColor = [UIColor whiteColor];
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    _baseTableView.alpha = 0;
    
    _alertView = [[[NSBundle mainBundle] loadNibNamed:@"MIChooseAlertView" owner:self options:nil] objectAtIndex:0];
    self.alertView.frame = CGRectMake(0, 0, self.alertView.viewWidth, self.alertView.viewHeight);
    self.alertView.center = CGPointMake(PHONE_SCREEN_SIZE.width / 2, SCREEN_HEIGHT / 2);
    self.alertView.hidden = YES;
    self.alertView.delegate = self;
    self.alertView.ischoosed = NO;
    [self.alertView.chooseBtn addTarget:self action:@selector(chooseUnremind) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.alertView];
}

-(void)howToCopy:(UIButton *)button
{
    NSString *fanliCourse = @"http://h5.mizhe.com/help/course.html";
    MITbWebViewController* vc = [[MITbWebViewController alloc] initWithURL:[NSURL URLWithString:fanliCourse]];
    vc.webTitle = @"淘宝返利教程";
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    //不显示返回图标
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_searchBar becomeFirstResponder];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - UISearchDisplayDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //一旦SearchBar輸入內容有變化，則執行這個方法，詢問要不要重裝searchResultTableView的數據
    if (searchString == nil || [searchString.trim isEqualToString:@""]) {
        self._lastSearchString = @"";
        [self._suggests removeAllObjects];
        [self._suggestNums removeAllObjects];
        [self.baseTableView reloadData];
        _baseTableView.alpha = 0;
        return NO;
    }
    _baseTableView.alpha = 1;
    self._lastSearchString = searchString;
    if ([self._operation isExecuting]) {
        [self._operation cancel];
        self._operation = nil;
    }
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:searchString, @"q", @"utf-8", @"code", @"1", @"extras", nil];
    self._operation = [self._suggestEngine operationWithPath: @"sug" params: params httpMethod:@"GET" ssl:NO];
    [self._suggests removeAllObjects];
    [self._suggestNums removeAllObjects];
    [self._suggests addObject:[NSString stringWithFormat:@"查找“%@”", searchString]];
    [self._suggestNums addObject:@""];
    __weak typeof(self) weakSelf = self;
    [self._operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSData* data = completedOperation.responseData;
        if([data length] > 0) {
            NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray* suggests = [obj objectForKey:@"result"];
            for (NSArray* suggest in suggests) {
                [weakSelf._suggests addObject:suggest[0]];
                [weakSelf._suggestNums addObject:suggest[1]];
            }
            
            [weakSelf.baseTableView reloadData];
            [weakSelf.baseTableView setContentOffset:CGPointZero animated:YES];
        }
    } errorHandler:^(MKNetworkOperation* completedOperation, NSError *error) {
    }];
    
    [self._suggestEngine enqueueOperation:self._operation];
    
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    MILog(@"scrollViewWillBeginDragging");
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - searchResultsTableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self._suggests count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        NSUInteger row = [indexPath row];
        if (row != 0) {
            cell.textLabel.text = [self._suggests objectAtIndex:row];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"约%@个宝贝", [self._suggestNums objectAtIndex:row]];
        } else {
            cell.textLabel.text = [self._suggests objectAtIndex:row];
            cell.detailTextLabel.text = [self._suggestNums objectAtIndex:row];
        }
    }
    @catch (NSException *exception) {
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"suggestsCell";
    
    MITbSuggestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) {
        cell = [[MITbSuggestTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:11];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [_searchBar resignFirstResponder];
    
    NSString *keyword;
    if (indexPath.row == 0) {
        keyword = self._lastSearchString;
    } else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        keyword = cell.textLabel.text;
    }
    
    if ([[MIMainUser getInstance] checkLoginInfo]) {
        [self openTaobaoViewController:keyword];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithLoginRebateAction:^{
            [self openTaobaoViewController:keyword];
        }];
        [alertView show];
    }
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    if (IOS_VERSION < 7.0) {
        for (UIView *subView in _searchBar.subviews){
            if([subView isKindOfClass:[UIButton class]]){
                [(UIButton*)subView setTitle:@"取消" forState:UIControlStateNormal];
                UIImage *barButton = [[UIImage imageNamed:@"barButtonLight"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, 15, 10)];
                UIImage *barButtonPressed = [[UIImage imageNamed:@"barButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, 15, 10)];
                [(UIButton*)subView setBackgroundImage:barButton forState:UIControlStateNormal];
                [(UIButton*)subView setBackgroundImage:barButtonPressed forState:UIControlStateHighlighted];
                break;
            }
        }
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchDisplay setActive:NO];
    [searchBar setShowsCancelButton:NO animated:NO];
    [[MINavigator navigator] closePopViewControllerAnimated:NO];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *keyword = searchBar.text;
    if ([[MIMainUser getInstance] checkLoginInfo]) {
        [self openTaobaoViewController:keyword];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithLoginRebateAction:^{
            [self openTaobaoViewController:keyword];
        }];
        [alertView show];
    }
}

// 根据搜索关键词打开查看淘宝商品界面
- (void)openTaobaoViewController:(NSString *)keyword
{
    if (keyword == nil || keyword.length == 0) {
        return;
    }
    
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"(http://|https://|www\\.)([a-zA-z0-9\\.\\-%/\\?&_=\\+#:~!,\'\\*\\^$]+)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regExp matchesInString:keyword options:NSMatchingReportCompletion range:NSMakeRange(0, keyword.length)];
    
    if (matches && matches.count > 0) {
        NSString *url = [keyword substringWithRange:[matches[0] rangeAtIndex:0]];
        NSString *trimmedKeywords = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (url.length == trimmedKeywords.length) {
            [[[UIAlertView alloc] initWithMessage:@"根据淘宝最新规则，不支持根据网址查询返利，请选用宝贝关键字查询"] show];
        } else {
            NSMutableString *keywordString = [NSMutableString stringWithString:keyword];
            for (NSTextCheckingResult *result  in matches) {
                NSRange range = NSMakeRange(0, keywordString.length);
                url = [keyword substringWithRange:[result rangeAtIndex:0]];
                [keywordString replaceOccurrencesOfString:url withString:@"" options:NSCaseInsensitiveSearch range:range];
            }
            
            NSString *status = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchAlertTipsNotShow"];
            if(status != nil && [status isEqualToString:@"1"]) {
                [self taobaoSearchWithKeyword:keywordString];
            } else {
                self.taobaoKeyWord = keywordString;
                keywordString = [NSMutableString stringWithFormat:@"是否以“%@”作为关键字搜索", keywordString];
                self.alertView.hidden = NO;
                self.alertView.titleLabel.text = @"提示";
                self.alertView.messageLabel.text = keywordString;
                [self.alertView.goAheadButton setTitle:@"确定" forState:UIControlStateNormal];
                [self.alertView.goBackToCartButton setTitle:@"取消" forState:UIControlStateNormal];
                [UIView animateWithDuration:0.3 animations:^{
                    self.alertView.alphaView.alpha = 0.35;
                    self.alertView.bgView.center = self.alertView.center;
                }];
            }
        }
    } else {
        [self taobaoSearchWithKeyword:keyword];
    }
}

- (void)closeShippingAlertView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alertView.alphaView.alpha = 0;
        self.alertView.bgView.top = self.view.viewHeight;
    } completion:^(BOOL finished) {
        self.alertView.hidden = YES;
        self.alertView.bgView.top = -self.alertView.viewHeight;
    }];
}

- (void)goAhead
{
    if (self.alertView.ischoosed)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"SearchAlertTipsNotShow"];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alertView.alphaView.alpha = 0;
        self.alertView.bgView.top = self.view.viewHeight;
    } completion:^(BOOL finished) {
        self.alertView.hidden = YES;
        self.alertView.bgView.top = -self.alertView.viewHeight;
        [self taobaoSearchWithKeyword:self.taobaoKeyWord];
    }];
}

- (void)goBackToCart
{
    [self closeShippingAlertView];
}

- (void)chooseUnremind
{
    if (!self.alertView.ischoosed)
    {
        [self.alertView.chooseBtn setImage:[UIImage imageNamed:@"cart_square_selected"] forState:UIControlStateNormal];
        self.alertView.ischoosed = YES;
    }
    else
    {
        [self.alertView.chooseBtn setImage:[UIImage imageNamed:@"cart_square_unchosed"] forState:UIControlStateNormal];
        self.alertView.ischoosed = NO;
    }
}

- (void)taobaoSearchWithKeyword:(NSString *)keyword
{
    NSString *userid = [[MIMainUser getInstance].userId stringValue];
    if (userid == nil || userid.length == 0) {
        userid = @"1";
    }
    
    NSString *s8 = @"http://s8.m.taobao.com/munion/search.htm?q=%@&pid=%@&unid=%@";
    NSString *sUrl = [NSString stringWithFormat:s8, [keyword urlEncode:NSUTF8StringEncoding], [MIConfig globalConfig].searchPid, userid];
    NSURL *sURL = [NSURL URLWithString:sUrl];
    MITbWebViewController * webVC = [[MITbWebViewController alloc] initWithURL:sURL];
    [webVC setWebTitle:[NSString stringWithFormat:@"淘宝返利-%@", keyword]];
    [[MINavigator navigator] openPushViewController: webVC animated:YES];
}

@end
