//
//  MIZhiDetailViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 13-10-23.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIZhiDetailViewController.h"
#import "MIZhiReplyViewController.h"
#import "MICommentsGetModel.h"
#import "MICommentModel.h"
#import "MICommentAddModel.h"
#import "MIZhiVoteAddModel.h"
#import "MIZhiReportSubmitModel.h"
#import "MIZhiVoteGetModel.h"
#import "URLCache.h"

#define MICommendPageSize  20
#define FirstCellHeight    95
#define ToolViewHeight     44

#pragma mark - MIZhiTitleCell
@interface MIZhiTitleCell : UITableViewCell

@property (nonatomic, strong) UIImageView *zhiImageView;
@property (nonatomic, strong) RTLabel *titleLabel;
@property (nonatomic, strong) UIImageView *statusImage;
@property (nonatomic, strong) RTLabel *sourceLabel;
@property(nonatomic, strong) RTLabel * goodLabel;

@end

@implementation MIZhiTitleCell

@synthesize zhiImageView,titleLabel,statusImage,sourceLabel,goodLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        zhiImageView = [[UIImageView alloc] initWithFrame: CGRectMake(6, 10, 75, 75)];
        zhiImageView.contentMode = UIViewContentModeScaleAspectFill;
        zhiImageView.clipsToBounds = YES;
        [self addSubview:zhiImageView];

        titleLabel = [[RTLabel alloc] initWithFrame: CGRectMake(85, 10, 225, 60)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        titleLabel.font = [UIFont systemFontOfSize: 14];
        [self addSubview:titleLabel];
        
        statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(255, 40, 55, 25)];
        statusImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:statusImage];

        sourceLabel = [[RTLabel alloc] initWithFrame:CGRectMake(85, 70, 110, 15)];
        sourceLabel.backgroundColor = [UIColor clearColor];
        sourceLabel.font = [UIFont systemFontOfSize:12];
        sourceLabel.textColor = [UIColor darkGrayColor];
        sourceLabel.lineBreakMode = kCTLineBreakByTruncatingMiddle;
        sourceLabel.textAlignment = RTTextAlignmentLeft;
        [self addSubview:sourceLabel];
        
        goodLabel = [[RTLabel alloc] initWithFrame: CGRectMake(200, 70, 110, 15)];
        goodLabel.backgroundColor = [UIColor clearColor];
        goodLabel.font = [UIFont systemFontOfSize: 12];
        goodLabel.textAlignment = RTTextAlignmentRight;
        goodLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:goodLabel];
    }
    return self;
}

@end

#pragma mark - MIZhiContentCell

@interface MIZhiContentCell : UITableViewCell

@property (nonatomic, strong) UIImageView *timeImageView;
@property (nonatomic, strong) RTLabel *sourceLabel;
@property (nonatomic, strong) RTLabel *timeLabel;
@property (nonatomic, strong) UIButton *reportButton;
@end

@implementation MIZhiContentCell

@synthesize sourceLabel,timeLabel,timeImageView,reportButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        sourceLabel = [[RTLabel alloc] initWithFrame: CGRectMake(10, 10, 160, 15)];
        sourceLabel.backgroundColor = [UIColor clearColor];
        sourceLabel.textColor = [UIColor lightGrayColor];
        sourceLabel.font = [UIFont systemFontOfSize: 12];
        sourceLabel.lineBreakMode = kCTLineBreakByTruncatingMiddle;
        [self addSubview:sourceLabel];

        timeLabel = [[RTLabel alloc] initWithFrame: CGRectMake(190, 10, 120, 15)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.textAlignment = RTTextAlignmentRight;
        timeLabel.font = [UIFont systemFontOfSize: 12];
        [self addSubview:timeLabel];

        timeImageView = [[UIImageView alloc] initWithFrame: CGRectMake(175, 12, 10, 10)];
        timeImageView.image = [UIImage imageNamed:@"ic_clock_small"];
        [self addSubview:timeImageView];
        
        reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reportButton setTitle:@"缺货/涨价举报" forState:UIControlStateNormal];
        [reportButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        reportButton.titleLabel.font = [UIFont systemFontOfSize:12];
        reportButton.frame = CGRectMake(235, 0, 80, 15);
        [self addSubview:reportButton];
    }
    return self;
}

@end


#pragma mark - MiZhiCommentCell

@interface MiZhiCommentCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) RTLabel *nameLabel;
@property (nonatomic, strong) MICommentModel *commentModel;
@property (nonatomic, strong) RTLabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation MiZhiCommentCell
@synthesize headImageView,nameLabel,timeLabel,commentModel,contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.backgroundColor = [UIColor clearColor];
        
        headImageView = [[UIImageView alloc] initWithFrame: CGRectMake(5, 8, 40, 40)];
        headImageView.contentMode = UIViewContentModeScaleAspectFit;
        headImageView.clipsToBounds = YES;
        [self addSubview:headImageView];
        
        nameLabel = [[RTLabel alloc] initWithFrame: CGRectMake(50, 8, 180, 15)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.lineBreakMode = kCTLineBreakByTruncatingMiddle;
        nameLabel.font = [UIFont systemFontOfSize: 12];
        [self addSubview:nameLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 8, 80, 15)];
        timeLabel.textAlignment = UITextAlignmentRight;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize: 10];
        timeLabel.textColor = [UIColor grayColor];
        [self addSubview:timeLabel];
        
        contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(50, 30, 260, 20)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.lineBreakMode = UILineBreakModeWordWrap;
        contentLabel.font = [UIFont systemFontOfSize:12];
        contentLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:contentLabel];
    }
    return self;
}
- (void)loadData
{
    self.nameLabel.text = [NSString stringWithFormat: @"<font color='#0490A3'>%@</font>",commentModel.nick];
    self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:commentModel.createTime.doubleValue] stringForTimeRelative];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar_img"]];
    contentLabel.viewHeight = commentModel.commentHeight.floatValue + 8;
    if (commentModel.pid.boolValue)//非0表示追评
    {
        contentLabel.text = [[NSString alloc] initWithFormat:@"<font color='#0490A3'>@%@</font> %@", commentModel.toNick, commentModel.comment];
    }
    else
    {
        contentLabel.text = commentModel.comment;
    }
}

@end


#pragma mark - MIZhiDetailViewController

@interface MIZhiDetailViewController ()
{
    BOOL _hasMore;
}

@property (nonatomic, strong) NSMutableArray *commentsArray;
@property (nonatomic, strong) UIButton *goodButton;
@property (nonatomic, assign) NSInteger commendPageSize;
@property (nonatomic, assign) NSInteger voteCount;

@end

@implementation MIZhiDetailViewController
@synthesize zhiModel = _zhiModel;
@synthesize zid = _zid;
@synthesize toolView = _toolView;
@synthesize webView = _webView;
@synthesize buyLabel = _buyLabel;
@synthesize commentsArray = _commentsArray;
@synthesize goodButton = _goodButton;
@synthesize detailGetRequest = _detailGetRequest;
@synthesize commentsGetRequest = _commentsGetRequest;
@synthesize voteAddRequest = _voteAddRequest;
@synthesize voteGetRequest = _voteGetRequest;
@synthesize failToGetComments,voteCount,currentPage,commendPageSize;

- (id)initWithItem:(MIZhiItemModel *)item
{
    self = [super init];
    if (self) {
        // Custom initialization
        _hasMore = NO;
        self.currentPage = 0;
        self.failToGetComments = NO;
        self.commentsArray = [[NSMutableArray alloc] initWithCapacity:20];
        
        if (item)
        {
            self.zhiModel = item;
            self.zid = self.zhiModel.zid.stringValue;
        }
        
        NSString *defaultUserAgent = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultUserAgent];
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:defaultUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationBar setBarTitle:@"爆料详情"];
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight) style:UITableViewStylePlain];
    _baseTableView.separatorColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.backgroundColor = [UIColor whiteColor];
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    self.baseTableView.hidden = !self.zhiModel;
    [self.view sendSubviewToBack:_baseTableView];
    
    UILabel *footerLabelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 56)];
    footerLabelView.textAlignment = UITextAlignmentCenter;
    footerLabelView.textColor = [UIColor lightGrayColor];
    footerLabelView.font = [UIFont systemFontOfSize:14];
    _baseTableView.tableFooterView = footerLabelView;
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 30, 310, self.view.viewHeight - self.navigationBarHeight - FirstCellHeight - ToolViewHeight)];
    self.webView.scrollView.pagingEnabled = YES;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - ToolViewHeight, SCREEN_WIDTH, ToolViewHeight)];
    _toolView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    _toolView.layer.shadowOffset = CGSizeMake(0, -1);
    _toolView.layer.shadowColor = [UIColor grayColor].CGColor;
    _toolView.layer.shadowRadius = 0.5;
    _toolView.layer.shadowOpacity = 0.5;
    [self.view addSubview:_toolView];
    
    _goodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodButton.selected = self.zhiModel.vote.boolValue;
    self.goodButton.adjustsImageWhenHighlighted = NO;
    self.goodButton.showsTouchWhenHighlighted = YES;
    [self.goodButton setImage:[UIImage imageNamed:@"ic_baoliao_zan_large"] forState:UIControlStateNormal];
    [self.goodButton setImage:[UIImage imageNamed:@"ic_baoliao_zan_large_selected"] forState:UIControlStateSelected];
    self.goodButton.frame = CGRectMake(25, 0, 48, 44);
    [self.goodButton addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:self.goodButton];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.adjustsImageWhenHighlighted = NO;
    commentButton.showsTouchWhenHighlighted = YES;
    [commentButton setImage:[UIImage imageNamed:@"ic_baoliao_comment_large"] forState:UIControlStateNormal];
    commentButton.frame = CGRectMake(25 + 24 + 58, 0, 48, 44);
    [commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:commentButton];
    
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardButton.adjustsImageWhenHighlighted = NO;
    forwardButton.showsTouchWhenHighlighted = YES;
    [forwardButton setImage:[UIImage imageNamed:@"ic_baoliao_share"] forState:UIControlStateNormal];
    forwardButton.frame = CGRectMake(25 + (24 + 58) * 2, 0, 48, 44);
    [forwardButton addTarget:self action:@selector(forwardAction:) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:forwardButton];
    
    _buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(25 + (24 + 58) * 2 + 60, self.view.frame.size.height - 72, 60, 60)];
    _buyLabel.hidden = YES;
    _buyLabel.userInteractionEnabled = YES;
    _buyLabel.backgroundColor = [UIColor orangeColor];
    _buyLabel.layer.cornerRadius = 30;
    _buyLabel.layer.masksToBounds = YES;
    _buyLabel.layer.borderWidth = 3;
    _buyLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _buyLabel.text = @"去购买";
    _buyLabel.textAlignment = NSTextAlignmentCenter;
    _buyLabel.textColor = [UIColor whiteColor];
    _buyLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:_buyLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToBuyAction:)];
    [_buyLabel addGestureRecognizer:tap];
    
//    if (!self.zhiModel) {
//        self.buyLabel.hidden = YES;
//        self.toolView.hidden = YES;
//        self.baseTableView.hidden = YES;
//    } else {
//        if (self.zhiModel.url == nil || self.zhiModel.url.length == 0) {
//            self.buyLabel.hidden = YES;
//        } else {
//            self.buyLabel.hidden = NO;
//        }
//    }

    __weak typeof(self) weakSelf = self;
    _reportRequest = [[MIZhiReportSubmitRequest alloc] init];
    _reportRequest.onCompletion = ^(MIZhiReportSubmitModel *model) {
        if (model.success.boolValue == NO) {
            [weakSelf showSimpleHUD:model.message];
        }
        else
        {
            [weakSelf showSimpleHUD:@"感谢举报，小编会核实处理"];
        }
    };
    _reportRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
    };
    [_reportRequest setZid:self.zid];
    
    _commentsGetRequest = [[MICommentsGetRequest alloc] init];
    _commentsGetRequest.onCompletion = ^(MICommentsGetModel *model) {
        [weakSelf loadCommentsCellsData:model];
    };
    _commentsGetRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        weakSelf.loading = NO;
        weakSelf.failToGetComments = YES;
        [weakSelf.baseTableView reloadData];
    };
    
    //DetailRequestRequest
    _detailGetRequest = [[MIZhiItemDetailGetRequest alloc] init];
    _detailGetRequest.onCompletion = ^(MIZhiItemDetailGetModel *model) {
        [weakSelf finishLoadTableViewData:model];
    };
    _detailGetRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };
    [_detailGetRequest setZid:self.zid];
    [_detailGetRequest sendQuery];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWebview) name:MiNotifyWebViewImageLoadSuccess object:nil];
    
    NSInteger cacheSizeMemory = 10*1024*1024; // 10MB
    NSInteger cacheSizeDisk = 32*1024*1024; // 32MB
    if (IOS_VERSION < 8.0) {
        URLCache *sharedCache = [[URLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:nil];
        [NSURLCache setSharedURLCache:sharedCache];
    } else {
        [[NSURLCache sharedURLCache] setMemoryCapacity:cacheSizeMemory];
    }

    if (self.detailModel) {
        [self loadDetailHtmlString];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    [_detailGetRequest cancelRequest];
    [_commentsGetRequest cancelRequest];
    [_voteAddRequest cancelRequest];
    [_voteGetRequest cancelRequest];
    [_reportRequest cancelRequest];

    [self.webView stopLoading];
    if (IOS_VERSION < 8.0) {
        // new for memory cleaning
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
        // new for memory cleanup
        [[NSURLCache sharedURLCache] setMemoryCapacity: 0];
        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
        [NSURLCache setSharedURLCache:sharedCache];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView stopLoading];
}
- (void)reloadWebview
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadDetailHtmlString) object:nil];
        [self performSelector:@selector(loadDetailHtmlString) withObject:nil afterDelay:0.2];
    });
}
- (void)loadDetailHtmlString
{
    [self.webView stopLoading];
    [self.webView loadHTMLString:self.detailModel.desc baseURL:nil];
}
#pragma mark - VoteAction
- (void)zanAction:(UIButton *)sender
{
    [MobClick event:kZhiVoteClicks];
    
    if ([[MIMainUser getInstance] checkLoginInfo]) {
        //VoteRequestRequest
        if (self.zhiModel.vote.boolValue) {
            [self showSimpleHUD:@"你已经投过票了" afterDelay:1.0];
        } else {
            self.goodButton.selected = YES;
            self.zhiModel.vote = [NSNumber numberWithInt:1];
            self.zhiModel.voteCount = [NSNumber numberWithInt:(self.zhiModel.voteCount.intValue + 1)];
            [self.baseTableView reloadData];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                CGAffineTransform newTransform = CGAffineTransformMakeScale(1.5, 1.5);
                [self.goodButton setTransform:newTransform];
                
            }completion:^(BOOL finished){
                
                [UIView animateWithDuration:0.2 animations:^{
                    CGAffineTransform newTransform = CGAffineTransformMakeScale(1.0, 1.0);
                    [self.goodButton setTransform:newTransform];
                }];
                
            }];
            __weak typeof(self) weakSelf = self;
            _voteAddRequest = [[MIZhiItemVoteAddRequest alloc] init];
            _voteAddRequest.onCompletion = ^(MIZhiVoteAddModel *model) {
                if (model.success.boolValue == NO) {
                    [weakSelf showSimpleHUD:model.message afterDelay:1.0];
                }
            };
            _voteAddRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
                MILog(@"error_msg=%@",error.description);
            };
            [_voteAddRequest setZid:self.zid];
            [_voteAddRequest sendQuery];
        }
    } else {
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
        cancelItem.action = ^{

        };
        MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"登录"];
        affirmItem.action = ^{
            [MINavigator openLoginViewController];
        };
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"亲，您还没有登录哦~" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
        [alertView show];
    }
}

#pragma mark - CommentAction
- (void)commentAction:(UIButton *)sender
{
    [MobClick event:kZhiCommClicks];

    if ([[MIMainUser getInstance] checkLoginInfo]) {
        MIZhiReplyViewController *replyView = [[MIZhiReplyViewController alloc] init];
        replyView.delegate = self;
        replyView.toUid = -1;
        replyView.itemId = self.zhiModel.zid.intValue;
        replyView.type = COMMENT_TYPE_ZHI;
        [[MINavigator navigator] openModalViewController:replyView animated:YES];
    }
    else {
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
        cancelItem.action = ^{

        };
        MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"登录"];
        affirmItem.action = ^{
            [MINavigator openLoginViewController];
        };
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"亲，您还没有登录哦~" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
        [alertView show];
    }
}

//CommentDelegate
- (void)finishSendComment:(MICommentModel *)model
{
    [self showSimpleHUD:@"评论成功"];
    [self.commentsArray insertObject:model atIndex:0];
    [self.baseTableView reloadData];
}

#pragma mark - ForwardAction
- (void)forwardAction:(id)params
{
    [MobClick event:kZhiShareClicks];

    NSString *url = [NSString stringWithFormat:@"http://zhi.mizhe.com/deal/%@.html", self.zhiModel.zid];
    NSString *title = [NSString stringWithFormat:@"%@ %@", self.zhiModel.title, self.zhiModel.promotion];
    NSString *smallImg = self.zhiModel.img;
    NSString *largeImg = self.zhiModel.img;
    
    NSString *comment = @"这是我在@米折网 超值爆料发现的，超划算！ 在米折购买还有返利，可以省下不少钱！";
    NSString *desc = @"米折网(mizhe.com),千万女性专属的优品特卖会！拥有专业的买手团队，与数十万淘宝卖家进行合作，每天10点千款上新，全场包邮，10元购和品牌特卖准时开抢，快去看看吧。";
    MIZhiTitleCell *cell = (MIZhiTitleCell *)[self.baseTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [MINavigator showShareActionSheetWithUrl:url title:title desc:desc comment:comment image:cell.zhiImageView smallImg:smallImg largeImg:largeImg inView:self.view platform:@"qq_qzone_weixin_timeline_weibo_copy_gohome"];
}

#pragma mark - GoToBuyAction
- (void)goToBuyAction:(id)sender
{
    if ([[MIMainUser getInstance] checkLoginInfo]) {
        [self goShopping];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithLoginAction:^{
            [self goShopping];
        }];
        [alertView show];
    }
}

- (void)goShopping
{
    [MobClick event:kZhiItemClicks];
    [MIUtility setMuyingTag:@"muying" key:self.cat];
    [MIUtility clickEventWithLog:@"zhi" cid:self.zhiModel.zid.stringValue s:@"1"];
    
    NSString *zhiUrl = [self.zhiModel.url urlEncoder];
    NSURL *zhiURL = [NSURL URLWithString:zhiUrl];
    if ([zhiUrl hasPrefix:@"http://tuan.mizhe.com"]) {
        [MINavigator openShortCutWithDictInfo:@{@"target": @"groupon"}];
    } else if ([zhiUrl hasPrefix:@"http://brand.mizhe.com"]) {
        [MINavigator openShortCutWithDictInfo:@{@"target": @"brand"}];
    } else if ([zhiURL.host isEqualToString:@"www.beibei.com"]) {
        //跳转贝贝客户端
        [MIUtility handleBeibeiUrl:zhiURL];
    } else {
        //去商城购物
        NSString *webTitle;
        if (self.zhiModel.source && self.zhiModel.source.length > 0) {
            webTitle = self.zhiModel.source;
        } else {
            webTitle = @"其它";
        }
        
        MITbWebViewController *vc = [[MITbWebViewController alloc] initWithURL:zhiURL];
        vc.tag = @"zh";
        vc.webTitle = webTitle;
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    }
}

//举报
- (void)toReportThisBaoliao:(id)sender
{
    if (![[MIMainUser getInstance] checkLoginInfo]) {
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
        cancelItem.action = ^{
            
        };
        MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"登录"];
        affirmItem.action = ^{
            [MINavigator openLoginViewController];
        };
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，您还没有登录哦~" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
        [alertView show];
        
    } else {
        MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
        cancelItem.action = ^{
            
        };
        MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"确定"];
        affirmItem.action = ^{
            [_reportRequest sendQuery];
        };
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认举报？" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
        [alertView show];
    }
}
#pragma mark - private methods
- (void)finishLoadTableViewData:(MIZhiItemDetailGetModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];

    self.detailModel = model;
    if (!self.zhiModel)
    {
        self.zhiModel = [[MIZhiItemModel alloc] init];
    }
    self.zhiModel.zid = model.zid;
    self.zhiModel.img = model.img;
    self.zhiModel.url = model.url;
    self.zhiModel.title = model.title;
    self.zhiModel.promotion = model.promotion;
    self.zhiModel.nick = model.nick;
    self.zhiModel.createTime = model.createTime;
    self.zhiModel.status = model.status;
    self.zhiModel.source = model.source;
    self.zhiModel.sourceId = model.sourceId;
    self.zhiModel.vote = model.vote;
    self.zhiModel.voteCount = model.voteCount;
    self.zhiModel.commentCount = model.commentCount;
    
    self.toolView.hidden = NO;
    self.baseTableView.hidden = NO;
    self.goodButton.selected = model.vote.boolValue;
    [self.webView loadHTMLString:model.desc baseURL:nil];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
    [self.baseTableView reloadData];
    
    if (model.commentCount.integerValue > 0) {
        //CommentsGetRequet
        _hasMore = YES;
    } else {
        _hasMore = NO;
    }

    [self getZhiVoteRequest];
    if (self.zhiModel.url == nil || self.zhiModel.url.length == 0) {
        self.buyLabel.hidden = YES;
    } else {
        self.buyLabel.hidden = NO;
        if (self.zhiModel.status.integerValue != 1) {
            _buyLabel.backgroundColor = [UIColor grayColor];
        }
    }
}

- (void)failLoadTableViewData
{
    [self setOverlayStatus:EOverlayStatusReload labelText:nil];
}

- (void)reloadTableViewDataSource{
    [super reloadTableViewDataSource];
    
    [_detailGetRequest sendQuery];
}

- (void)getZhiVoteRequest
{
    if ([[MIMainUser getInstance] checkLoginInfo]) {
        __weak typeof(self) weakSelf = self;
        _voteGetRequest = [[MIZhiVoteGetRequest alloc] init];
        _voteGetRequest.onCompletion = ^(MIZhiVoteGetModel *model) {
            if (model.vote.boolValue) {
                weakSelf.goodButton.selected = YES;
                weakSelf.zhiModel.vote = [NSNumber numberWithInt:1];
                weakSelf.zhiModel.voteCount = [NSNumber numberWithInt:(weakSelf.zhiModel.voteCount.intValue + 1)];
            }
        };
        _voteGetRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
            MILog(@"error_msg=%@",error.description);
        };
        [_voteGetRequest setZid:self.zid];
        [_voteGetRequest sendQuery];
    }
}

- (void)requestForCommentsWithPage:(NSInteger)page
{
    self.loading = YES;
    [_commentsGetRequest setType:COMMENT_TYPE_ZHI];
    [_commentsGetRequest setItemId:self.zid];
    [_commentsGetRequest setPage:page];
    [_commentsGetRequest setPageSize:MICommendPageSize];
    [_commentsGetRequest sendQuery];
}

- (void)loadCommentsCellsData:(MICommentsGetModel *)model
{
    self.loading = NO;
    self.failToGetComments = NO;

    currentPage = model.page.integerValue;
    commendPageSize = model.pageSize.integerValue;
    if (model.comments.count != 0) {
        [self.commentsArray addObjectsFromArray:(NSMutableArray *)model.comments];
    }
    
    if (self.commentsArray.count != 0)
    {
        if ((0 == model.comments.count) || (model.comments.count < model.pageSize.intValue)) {
            _hasMore = NO;
            UILabel *footerLabelView = (UILabel *)self.baseTableView.tableFooterView;
            footerLabelView.text = @"没有评论啦";
        } else {
            _hasMore = YES;
        }
    }
    [self.baseTableView reloadData];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    MILog(@"url=%@,host=%@", request.URL.absoluteString,request.URL.host);
    NSString *absoluteString = request.URL.absoluteString;
    if ([absoluteString isEqualToString:@"about:blank"]) {
        return YES;
    } else {
        if ([absoluteString hasPrefix:@"http://zhi.mizhe.com/deal/"]) {
            NSRegularExpression *zhiDealExp = [NSRegularExpression regularExpressionWithPattern:@"mizhe\\.com\\/deal/([0-9]+)\\.htm" options:NSRegularExpressionCaseInsensitive error: nil];
            NSArray *matches = [zhiDealExp matchesInString:absoluteString options:NSMatchingReportCompletion range:NSMakeRange(0, [absoluteString length])];
            if ([matches count] > 0) {
                MIZhiDetailViewController *detailView = [[MIZhiDetailViewController alloc] initWithItem:nil];
                detailView.zid = [absoluteString substringWithRange:[matches[0] rangeAtIndex:1]];
                [[MINavigator navigator] openPushViewController:detailView animated:YES];
            }
        } else if ([request.URL.host isEqualToString:@"www.beibei.com"]) {
            //跳转贝贝客户端
            [MIUtility handleBeibeiUrl:request.URL];
        } else if ([absoluteString hasPrefix:@"img:"]) {
            NSString *imgUrl = [absoluteString substringFromIndex:4];
            [self viewImageWithUrl:imgUrl];
        } else {
            MITbWebViewController * webVC = [[MITbWebViewController alloc] initWithURL:request.URL];
            webVC.tag = @"zh";
            webVC.webTitle = @"更多爆料详情";
            [[MINavigator navigator] openPushViewController: webVC animated:YES];
        }
        return NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    MILog(@"zhi detailes webViewDidFinishLoad");
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    //添加捕获网页图片script
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \""
     "var img = document.getElementsByTagName('img');"
     "for ( var i=0; i < img.length; i++ ) "
     "{img[i].addEventListener("
     "\'click\', "
     "function () {if ( this.parentElement.tagName.toUpperCase() !== 'A' )"
     "{document.location.href='img:'+this.src;}},"
     "true);}"
     "\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    //先将webView高度改小，以得到内容的最适高度
    self.webView.viewHeight = 1;
    NSString *fitHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    self.webView.viewHeight = [fitHeight floatValue];
    [self.baseTableView reloadData];
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    //非网络原因
    if(error.code != -999 && error.code != 102 && error.code != 101) {
        //服务器页面抛出错误error，-999属于请求未完成（刷新过快），102属于网络错误
        //此两个错误不做异常处理
        [self setOverlayStatus:EOverlayStatusError labelText:nil];
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1 + 2;
    if (self.commentsArray.count)
    {
        rows = self.commentsArray.count + 2;
        if (commendPageSize == MICommendPageSize && _hasMore)
        {
            rows++;
        }
    }
    return rows;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        return FirstCellHeight;
    }
    else if ( 1 == indexPath.row)
    {
        return self.webView.scrollView.size.height + 35 + 20;
    }
    else if (_hasMore && (indexPath.row == (self.commentsArray.count + 2)))
    {
        return 56;
    }
    else
    {
        if (self.commentsArray.count && self.commentsArray.count > indexPath.row - 2)
        {
            MICommentModel *commentModel = (MICommentModel *)[self.commentsArray objectAtIndex:indexPath.row - 2 ];
            NSString *content = commentModel.comment;
            if (commentModel.pid.boolValue)//非0表示追评
            {
                content = [[NSString alloc] initWithFormat:@"@%@ %@", commentModel.toNick, commentModel.comment]; 
            }
            CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(260, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            commentModel.commentHeight = @(size.height);
            return (size.height > 0 ? size.height : 15) + 40;
        }
        else
        {
            return 56;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *titleCellIdentifier = @"titleCell";
    static NSString *contentCellIdentifier = @"contentCell";
    static NSString *commentCellIdentifier = @"commentCell";
    static NSString *LoadMoreIdentifier = @"LoadMoreCellReuseIdentifier";
    static NSString *noCommentIdentifier = @"noCommentCell";
    if (_hasMore && (indexPath.row == (self.commentsArray.count + 2)))
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreIdentifier];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicatorView.center = CGPointMake(100, 28);
            indicatorView.tag = 999;
            [cell addSubview:indicatorView];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = @"更多评论";
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *) [cell viewWithTag:999];
        [activityView stopAnimating];
        return cell;
    } else if (0 == indexPath.row) {
        MIZhiTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
        if (!cell) {
            cell = [[MIZhiTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellIdentifier];
        }

        NSString *imgUrl = [[NSString alloc] initWithFormat:@"%@!150x150.jpg", self.zhiModel.img];
        [cell.zhiImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_avatar_img"]];
        cell.titleLabel.text = [[NSString alloc] initWithFormat:@"%@ <font color='#bb1800'>%@</font>", self.zhiModel.title, self.zhiModel.promotion];
        if (self.zhiModel.source && 0 != [[self.zhiModel.source stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
            cell.sourceLabel.text = [[NSString alloc] initWithFormat:@"来自%@", self.zhiModel.source];
        } else {
            cell.sourceLabel.text = @"来自其它";
        }
        
        cell.goodLabel.text = [[NSString alloc] initWithFormat:@"<font color='#ff6600'>%@</font>人觉得值", self.zhiModel.voteCount.stringValue];
        if (self.zhiModel.status.integerValue == 2)
        {
            cell.statusImage.image = [UIImage imageNamed:@"ic_zhi_soldout"];
            cell.statusImage.hidden = NO;
        }
        else if (self.zhiModel.status.integerValue == 4)
        {
            cell.statusImage.image = [UIImage imageNamed:@"ic_zhi_outoftime"];
            cell.statusImage.hidden = NO;
        }
        else {
            cell.statusImage.hidden = YES;
        }

        return cell;
    } else if (1 == indexPath.row) {
        MIZhiContentCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifier];
        if (!cell)
        {
            cell = [[MIZhiContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentCellIdentifier];
            [cell addSubview:self.webView];
        }
        cell.reportButton.top = self.webView.bottom;
        [cell.reportButton addTarget:self action:@selector(toReportThisBaoliao:) forControlEvents:UIControlEventTouchUpInside];

        if (self.zhiModel.nick && 0 != [[self.zhiModel.nick stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
            cell.sourceLabel.text = [NSString stringWithFormat: @"感谢 <font>%@</font> 的爆料",self.zhiModel.nick];
        }
        cell.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:self.zhiModel.createTime.doubleValue] stringForTimeRelative];
        CGSize labelSize = [cell.timeLabel.text sizeWithFont:cell.timeLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH, 10) lineBreakMode:NSLineBreakByWordWrapping];
        cell.timeLabel.left = 310 - labelSize.width;
        cell.timeLabel.viewWidth = labelSize.width;
        cell.timeImageView.left = cell.timeLabel.left - 15;
        return cell;
    }
    else
    {
        if (self.commentsArray.count && self.commentsArray.count > indexPath.row - 2)
        {
            MiZhiCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
            if (!cell)
            {
                cell = [[MiZhiCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellIdentifier];
            }
            cell.commentModel = (MICommentModel *)[self.commentsArray objectAtIndex:indexPath.row - 2];
            [cell loadData];
            return cell;
        } 
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noCommentIdentifier];
            if(!cell){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            if (self.zhiModel.commentCount.integerValue == 0) {
                cell.textLabel.text = @"哇塞，居然还没有评论，马上抢沙发！";
            } else {
                if (self.failToGetComments) {
                    cell.textLabel.text = @"加载评论失败，点此重试";
                } else if (![[Reachability reachabilityForInternetConnection] isReachable]) {
                    cell.textLabel.text = @"网络未连接";
                } else {
                    cell.textLabel.text = @"加载评论中...";
                }
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (indexPath.row == (self.commentsArray.count + 2) && _hasMore && !self.loading) {
        if (!self.failToGetComments) {
            UIActivityIndicatorView *activityView = (UIActivityIndicatorView *) [cell viewWithTag:999];
            [activityView startAnimating];
            cell.textLabel.text = @"正在加载更多...";
            
            [self requestForCommentsWithPage:(currentPage + 1)];
        } else {
            cell.textLabel.text = @"加载评论失败，点此重试";
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //回复评论
    if (0 == self.zhiModel.commentCount.integerValue)
    {
        if (2 == indexPath.row) {
            [self commentAction:nil];
            return;
        }
    } else {
        if (indexPath.row == (self.commentsArray.count + 2) && self.failToGetComments) {
            self.failToGetComments = NO;
            [self.baseTableView reloadData];
            [self requestForCommentsWithPage:(currentPage + 1)];
            return;
        }
    }
    
    if (indexPath.row > 1 && (indexPath.row != (self.commentsArray.count + 2)))
    {
        if ([[MIMainUser getInstance] checkLoginInfo] && self.commentsArray.count > indexPath.row - 2) {
            MICommentModel *commentModel = (MICommentModel *)[self.commentsArray objectAtIndex:indexPath.row - 2];
            MIZhiReplyViewController *replyView = [[MIZhiReplyViewController alloc] init];
            replyView.delegate = self;
            replyView.name = commentModel.nick;
            replyView.toUid = commentModel.uid.intValue;
            replyView.itemId = self.zhiModel.zid.intValue;
            replyView.commentId = commentModel.commentId.intValue;
            [[MINavigator navigator] openModalViewController:replyView animated:YES];
        } else {
            MIButtonItem *cancelItem = [MIButtonItem itemWithLabel:@"取消"];
            cancelItem.action = ^{
                
            };
            MIButtonItem *affirmItem = [MIButtonItem itemWithLabel:@"登录"];
            affirmItem.action = ^{
                [MINavigator openLoginViewController];
            };
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"亲，您还没有登录哦~" cancelButtonItem:cancelItem otherButtonItems:affirmItem, nil];
            [alertView show];
        }
    }
}

#pragma mark - 预览大图

- (void) dismissImageView {
    
    [UIView transitionWithView:self.view
                      duration:.35
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        [_popupImageViewContainer setAlpha:0];
                        [_popupImageView setAlpha:0];
                    }
                    completion:^(BOOL finished){
                        [_popupImageView removeFromSuperview];
                        _popupImageView = nil;
                        [_popupImageViewContainer removeFromSuperview];
                        _popupImageViewContainer = nil;
                        
                    }];
    
    
}

- (void) viewImageWithUrl: (NSString *) imgUrl {
    
    UIWindow *window = self.view.window;
    CGRect tabViewBounds = window.bounds;
    
    //Depending on your view hierachy, you may need to tweak the origin of the window frame
    _popupImageViewContainer = [[UIView alloc] initWithFrame:tabViewBounds];
    [_popupImageViewContainer setBackgroundColor:[UIColor colorWithWhite:0.01 alpha:0.90]];
    [_popupImageViewContainer setAlpha:0];
    [window addSubview:_popupImageViewContainer];
    
    //Place image in UIImageView with frame transformed from tableview
    _popupImageView = [[UIImageView alloc] init];
    _popupImageView.clipsToBounds = YES;
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgUrl];
    if (image == nil) {
        NSURL *url = [NSURL URLWithString:imgUrl];
        
        /* And this is our request */
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:10.0f];
        
        /* Try to get a cached response to our request. This might come back as nil */
        NSCachedURLResponse *response =[[NSURLCache sharedURLCache] cachedResponseForRequest:request];
        image = [UIImage imageWithData:response.data];
    }
    if (image) {
        [[SDImageCache sharedImageCache] removeImageForKey:imgUrl fromDisk:NO];
        _popupImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_popupImageView setFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
        _popupImageView.contentMode = UIViewContentModeScaleAspectFit;
        _popupImageView.image = image;
    } else {
        [_popupImageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        [_popupImageView setCenter:self.view.center];
        _popupImageView.contentMode = UIViewContentModeScaleAspectFill;
        _popupImageView.image = [UIImage imageNamed:@"default_avatar_img"];
    }
    
    [_popupImageView setAlpha:0];
    [_popupImageViewContainer addSubview:_popupImageView];
    
    [UIView transitionWithView:self.view
                      duration:.5
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        
                        [_popupImageView setAlpha:1];
                        [_popupImageViewContainer setAlpha:1];
                    }
                    completion:^(BOOL finished){
                        [UIView transitionWithView:self.view
                                          duration:.2
                                           options:UIViewAnimationOptionCurveEaseOut
                                        animations:^{
                                            _popupImageView.contentMode = UIViewContentModeScaleAspectFit;
                                            [_popupImageView setFrame:tabViewBounds];
                                            if (image) {
                                                [_popupImageView setImage:image];
                                            } else {
                                                [_popupImageView sd_setImageWithURL: [NSURL URLWithString:imgUrl] placeholderImage: [_popupImageView image]];
                                            }
                                        }
                         //Once animation is complete, we remove the image and place it in a scrollview so users can zoom
                                        completion:^(BOOL finished){
                                            UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:_popupImageViewContainer.bounds];
                                            scroll.userInteractionEnabled = YES;
                                            scroll.maximumZoomScale = 3.0;
                                            scroll.minimumZoomScale = 0.99;
                                            scroll.bouncesZoom = YES;
                                            scroll.delegate = self;
                                            [_popupImageView removeFromSuperview];
                                            [scroll addSubview:_popupImageView];
                                            [_popupImageView setUserInteractionEnabled:YES];
                                            
                                            //Users can dismiss the popup through the tapping gesture
                                            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissImageView)];
                                            [scroll addGestureRecognizer:tapGesture];
                                            [_popupImageViewContainer addSubview:scroll];
                                        }];
                    }];
}
#pragma mark - scrollView && page
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    for (UIView *imageView in scrollView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            return imageView;
        }
    }
    return nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    //Close the imageview if the user tries to zoom out, this is optional
    for (UIView *imageView in scrollView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            if (scale < 1) {
                //[self dismissImageView];
                [scrollView setZoomScale:1 animated:YES];
            }
        }
    }
}


@end
