//
//  MIMallDetailController.m
//  MISpring
//
//  Created by Mac Chow on 13-4-1.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMallDetailController.h"

#import "MBProgressHUD.h"
#import "MIMainUser.h"

@interface MIMallDetailController ()

@end

@implementation MIMallDetailController
@synthesize mallInfoReq = _mallInfoReq;
@synthesize mall = _mall;
@synthesize mallInfo = _mallInfo;
@synthesize labelTitle = _labelTitle;
@synthesize imgLogo = _imgLogo;
@synthesize labelCommission = _labelCommission;
@synthesize accordion = _accordion;

@synthesize textDesc = _textDesc;
@synthesize webCommissionDesc = _webCommissionDesc;
@synthesize webCommissionNote = _webCommissionNote;
@synthesize textVisited = _textVisited;

static NSArray * listTexts;

+ (void)initialize
{
    listTexts = @[@"返利详情", @"商城信息", @"注意事项"];
}

-(id) initWithMallModel: (MIMallModel *) mall{
    self = [super init];
    if (self != nil) {
        self.mall = mall;
    }

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBar setBarTitle:@"商城详情" textSize:20.0];
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 10 + self.navigationBarHeight, 86, 50)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    [backGroundView.layer setBorderWidth: 0.8];
    [backGroundView.layer setBorderColor: [[UIColor colorWithWhite:0.3 alpha:0.2] CGColor]];
    [backGroundView.layer setCornerRadius: 4];
    [backGroundView.layer setMasksToBounds: YES];
    [self.view addSubview:backGroundView];
    
    _imgLogo = [[UIImageView alloc] init];
    [_imgLogo setFrame: CGRectMake(3, 5, 80, 40)];
    [_imgLogo sd_setImageWithURL:[NSURL URLWithString: _mall.logo] placeholderImage:[UIImage imageNamed:@"mizhewang_logo"]];
    [backGroundView addSubview: _imgLogo];
    
    _labelTitle = [[UILabel alloc] init];
    _labelTitle.text = _mall.name;
    [_labelTitle setFrame: CGRectMake(100, 15 + self.navigationBarHeight, 205, 20)];
    [_labelTitle setFont:[UIFont systemFontOfSize: 16]];
    [_labelTitle setBackgroundColor: [UIColor clearColor]];
    [self.view addSubview: _labelTitle];
    
    _labelCommission = [[UILabel alloc] init];
    [_labelCommission setFont: [UIFont systemFontOfSize:12]];
    [_labelCommission setFrame: CGRectMake(100, 35 + self.navigationBarHeight, 205, 15)];
    [_labelCommission setTextColor: [UIColor orangeColor]];
    [_labelCommission setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview: _labelCommission];
    
    _textVisited = [[UILabel alloc] init];
    _textVisited.textColor = [UIColor lightGrayColor];
    _textVisited.adjustsFontSizeToFitWidth = YES;
    _textVisited.minimumFontSize = 12;
    [_textVisited setFont: [UIFont systemFontOfSize: 14]];
    [_textVisited setFrame: CGRectMake(10, 65 + self.navigationBarHeight, SCREEN_WIDTH - 20, 20)];
    [_textVisited setBackgroundColor: [UIColor clearColor]];
    [self.view addSubview: _textVisited];
    
    if (_mall.commission && _mall.commission.floatValue > 0) {
        float commission = [_mall.commission floatValue] / 100;
        if (_mall.mode.intValue == 1) {
            //返利类型为米币
            _labelCommission.text = [NSString stringWithFormat:@"最高返利%.1f%%米币（米币可以兑现哦）", commission];
            _labelCommission.font = [UIFont systemFontOfSize: 10];
        } else {
            if (_mall.commissionType.intValue == 2) {
                //最高返利为按元计算
                _labelCommission.text = [NSString stringWithFormat:@"最高返利%.1f元", commission];
            } else {
                //最高返利为按比例计算
                _labelCommission.text = [NSString stringWithFormat:@"最高返利%.1f%%", commission];
            }
        }
    }
    
    _accordion = [[CollapseClick alloc] init];
    [_accordion setFrame:CGRectMake(10, 95 + self.navigationBarHeight, SCREEN_WIDTH - 20, self.view.viewHeight - self.navigationBarHeight - 95)];
    _accordion.CollapseClickDelegate = self;
    [self.view addSubview: _accordion];
    
    CGFloat contentHeiht = _accordion.viewHeight - kCCHeaderHeight*3 - 20;
    _textDesc = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH - 20, contentHeiht)];
    _textDesc.bounces = NO;
    [_textDesc setContentSize: CGSizeMake(SCREEN_WIDTH - 20, contentHeiht)];
    [_textDesc setEditable: NO];
    [_textDesc setDirectionalLockEnabled:YES];
    [_textDesc setShowsHorizontalScrollIndicator: NO];
    
    _webCommissionDesc = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH - 20, contentHeiht)];
    _webCommissionDesc.scrollView.bounces = NO;
    _webCommissionDesc.delegate = self;
    
    _webCommissionNote = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH - 20, contentHeiht)];
    _webCommissionNote.scrollView.bounces = NO;
    _webCommissionNote.delegate = self;

    
    _mallInfoReq = [[MIMallInfoRequest alloc] init];
    [_mallInfoReq setMallId: _mall.mallId];

    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(PHONE_SCREEN_SIZE.width / 2, (self.view.viewHeight - self.navigationBarHeight - 150) / 2 + 120);
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    __weak typeof(self) weakSelf = self;
    _mallInfoReq.onCompletion = ^(MIMallInfoModel* model) {
        [activityIndicator removeFromSuperview];
        weakSelf.mallInfo = model;

        weakSelf.labelTitle.text = model.name;
        [weakSelf.imgLogo sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"mizhewang_logo"]];
        [weakSelf.textVisited setText: [NSString stringWithFormat:@"已有%@人通过米折网去往%@购物", model.visited, weakSelf.mall.name]];
        [weakSelf.textDesc setText: model.desc];
        [weakSelf.webCommissionDesc loadHTMLString: model.commissionDesc  baseURL: Nil];
        [weakSelf.webCommissionNote loadHTMLString: model.commissionNote  baseURL: Nil];
        [weakSelf.accordion reloadCollapseClick];
        [weakSelf.accordion openCollapseClickCellAtIndex:0 animated:YES];
        
        float commission;
        if (model.type.integerValue == 1 && model.mobileCommission.floatValue != 0) {
            //移动商城
            commission = [model.mobileCommission floatValue] / 100;
        } else {
            commission = [model.commission floatValue] / 100;
        }
        
        if (model.commissionMode.intValue == 1) {
            //返利类型为米币
            weakSelf.labelCommission.text = [NSString stringWithFormat:@"最高返利%.1f%%米币（米币可以兑现哦）", commission];
            weakSelf.labelCommission.font = [UIFont systemFontOfSize: 10];
        } else {
            if (model.commissionType.intValue == 2) {
                //最高返利为按元计算
                weakSelf.labelCommission.text = [NSString stringWithFormat:@"最高返利%.1f元", commission];
            } else {
                //最高返利为按比例计算
                weakSelf.labelCommission.text = [NSString stringWithFormat:@"最高返利%.1f%%", commission];
            }
        }
    };

    _mallInfoReq.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [activityIndicator removeFromSuperview];
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.mallInfo == nil) {
        [_mallInfoReq sendQuery];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mallInfoReq cancelRequest];
}

#pragma mark - CollapseClick
-(int)numberOfCellsForCollapseClick
{
    return 3;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index
{
    return [listTexts objectAtIndex:index];
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index
{
    switch (index) {
        case 0:
            return _webCommissionDesc;
            break;
        case 1:
            return _textDesc;
            break;
        case 2:
            return _webCommissionNote;
            break;
        default:
            return Nil;
    }
}

-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
    return [UIColor colorWithWhite:.96 alpha:1];
}

-(UIColor *)colorForTitleLabelAtIndex:(int)index {
    return [UIColor darkGrayColor];
}

-(UIColor *)colorForTitleArrowAtIndex:(int)index {
    return [UIColor colorWithWhite:.8 alpha:1];
}

-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open {
    NSMutableArray *array = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2], nil];
    [array removeObjectAtIndex:index];
    [_accordion closeCollapseClickCellsWithIndexes:array animated:NO];
}


-(UIColor *)colorForViewBorder:(int)index {
    return [UIColor colorWithWhite:.8 alpha:1];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}
@end