//
//  MIMsgCenterViewController.m
//  MISpring
//
//  Created by 徐 裕健 on 14-1-3.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIMsgCenterViewController.h"
#import "MIZhiDetailViewController.h"
#import "MIZhiReplyViewController.h"
#import "MICommentReceiveGetModel.h"
#import "MIMsgCommentModel.h"

#pragma mark - CommentsTableCell
@interface MICommentTableCell : UITableViewCell<MICommentDelegate>

@property (nonatomic, strong) MIMsgCommentModel *commentModel;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) RTLabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) RTLabel *contentLabel;
@property (nonatomic, strong) UIImageView *itemBackgroundView;
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *itemTitle;

@end

@implementation MICommentTableCell
@synthesize commentModel,backgroundView,headImageView,nameLabel,descLabel,contentLabel,itemBackgroundView,itemImageView,itemTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 175)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backgroundView];
        
        UITapGestureRecognizer *tapGesReg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapAction)];
        [backgroundView addGestureRecognizer:tapGesReg];
        
        headImageView = [[UIImageView alloc] initWithFrame: CGRectMake(5, 6, 40, 40)];
        headImageView.contentMode = UIViewContentModeScaleAspectFit;
        headImageView.clipsToBounds = YES;
        [backgroundView addSubview:headImageView];
        
        nameLabel = [[RTLabel alloc] initWithFrame: CGRectMake(55, 8, 240, 20)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.lineBreakMode = kCTLineBreakByTruncatingMiddle;
        nameLabel.font = [UIFont systemFontOfSize: 14];
        nameLabel.textColor = [UIColor darkGrayColor];
        [backgroundView addSubview:nameLabel];
        
        descLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 25, 240, 20)];
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.font = [UIFont systemFontOfSize: 12];
        descLabel.textColor = [UIColor grayColor];
        [backgroundView addSubview:descLabel];
        
        contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(5, 50, SCREEN_WIDTH - 30, 25)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.lineBreakMode = UILineBreakModeWordWrap;
        contentLabel.font = [UIFont systemFontOfSize:16];
        [backgroundView addSubview:contentLabel];
        
        itemBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 70, SCREEN_WIDTH - 30, 100)];
        UIImage *backgroundImage = [[UIImage imageNamed:@"msg_comment_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 22, 9, 2238)];
        itemBackgroundView.image = backgroundImage;
        [backgroundView addSubview:itemBackgroundView];
        
        itemImageView = [[UIImageView alloc] initWithFrame: CGRectMake(5, 15, 80, 80)];
        itemImageView.contentMode = UIViewContentModeScaleAspectFit;
        itemImageView.clipsToBounds = YES;
        [itemBackgroundView addSubview:itemImageView];
        
        itemTitle = [[UILabel alloc] initWithFrame:CGRectMake(90, 15, 195, 50)];
        itemTitle.backgroundColor = [UIColor clearColor];
        itemTitle.lineBreakMode = UILineBreakModeWordWrap;
        itemTitle.numberOfLines = 0;
        itemTitle.font = [UIFont systemFontOfSize:14.0];
        itemTitle.textColor = [UIColor grayColor];
        [itemBackgroundView addSubview:itemTitle];
    }
    return self;
}

- (void)commentTapAction
{
    NSString *title;
    MIActionSheetBlock block;
    if (commentModel.type.integerValue == 2) {
        title = @"查看爆料";
        block = ^(NSInteger index) {
            MIZhiDetailViewController *detailView = [[MIZhiDetailViewController alloc] initWithItem:nil];
            detailView.zid = commentModel.relateId.stringValue;
            [[MINavigator navigator] openPushViewController:detailView animated:YES];
        };
    } else {
        title = @"暂不支持查看详情";
        block = ^(NSInteger index) {
            [MINavigator showSimpleHudWithTips:@"暂不支持查看详情哦~"];
        };
    }
    
    MIActionSheet *actionSheet = [[MIActionSheet alloc] initWithTitle:nil];
    [actionSheet addButtonWithTitle:@"回复评论" withBlock:^(NSInteger index) {
        MIZhiReplyViewController *replyView = [[MIZhiReplyViewController alloc] init];
        replyView.delegate = self;
        replyView.name = commentModel.nick;
        replyView.toUid = commentModel.uid.intValue;
        replyView.itemId = commentModel.relateId.intValue;
        replyView.commentId = commentModel.commentId.intValue;
        replyView.type = commentModel.type.intValue;
        replyView.placeHolderLabel.text = [NSString stringWithFormat:@"回复：%@",commentModel.nick];
        [[MINavigator navigator] openModalViewController:replyView animated:YES];
    }];
    
    [actionSheet addButtonWithTitle:title withBlock:block];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"取消", @"取消") withBlock:^(NSInteger index) {
    }];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.window];
}

#pragma mark - MICommentDelegate
- (void)finishSendComment:(MICommentModel *)model
{
    [MINavigator showSimpleHudWithTips:@"评论成功"];
}

@end

@implementation MIMsgCenterViewController
@synthesize commentsArray, request, tipsView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBarTitle:@"消息中心"];
    
    self.needRefreshView = YES;
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _baseTableView.frame = CGRectMake(0, self.navigationBarHeight, self.view.viewWidth, self.view.viewHeight - self.navigationBarHeight);
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.backgroundView.alpha = 0;
    _baseTableView.hidden = YES;
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    _baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 10)];
    [self.view sendSubviewToBack:_baseTableView];
    
    BOOL remoteNotificationEnable;
    if (IOS_VERSION >= 8.0) {
        remoteNotificationEnable = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    } else {
        remoteNotificationEnable = [[UIApplication sharedApplication] enabledRemoteNotificationTypes] != UIRemoteNotificationTypeNone;
    }
    
    if (remoteNotificationEnable != YES) {
        NSString *tips;
        if (IOS_VERSION >= 7.0) {
            tips = @"您现在无法收到评论、返利到账等消息通知，请到系统“设置”-“通知中心”-“米折”中开启";
        } else {
            tips = @"您现在无法收到评论、返利到账等消息通知，请到系统“设置”-“通知”-“米折”中开启";
        }
        
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 40, 45)];
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.font = [UIFont systemFontOfSize:14.0];
        tipsLabel.textAlignment = UITextAlignmentCenter;
        tipsLabel.textColor = [UIColor grayColor];
        tipsLabel.shadowColor = [UIColor whiteColor];
        tipsLabel.shadowOffset = CGSizeMake(0, -1.0);
        tipsLabel.numberOfLines = 0;
        tipsLabel.text = tips;
        _baseTableView.tableHeaderView = tipsLabel;
    } else {
        _baseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 5)];
    }
    
    tipsView = [[MIOrderNoteView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight)];
    tipsView.hidden = YES;
    tipsView.noteTile.text = @"暂时还没查到有消息记录哦~</font>";
    [tipsView.noteButton setTitle:@"逛逛今日特卖" forState:UIControlStateNormal];
    [tipsView.noteButton addTarget:self action:@selector(goZhiShopping) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tipsView];

    
    _loading = YES;
    _currentPage = 1;
    commentsArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    __weak typeof(self) weakSelf = self;
    request = [[MICommentReceiveGetRequest alloc] init];
    request.onCompletion = ^(MICommentReceiveGetModel *model) {
        [weakSelf finishLoadTableViewData:model];
    };
    
    request.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [weakSelf failLoadTableViewData];
        MILog(@"error_msg=%@",error.description);
    };
    
    [request setPage:1];
    [request setPageSize:10];
    [request sendQuery];
    
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [request cancelRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) goZhiShopping
{
    [[MINavigator navigator] goMainScreenFromAnyByIndex:MAIN_SCREEN_INDEX_HOMEPAGE info:nil];
}

#pragma mark - Data Source Loading / loading Methods
- (void)reloadTableViewDataSource
{
    if (self.loading) {
        [request cancelRequest];
    }
    
    self.loading = YES;
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    _currentPage = 1;
    [request setPage:_currentPage];
    [request sendQuery];
}

- (void)loadMoreTableViewDataSource
{
    if (([commentsArray count] != 0) && _hasMore) {
        //只有当前有数据的前提下才会触发加载更多
        self.loading = YES;
        [request setPage:++_currentPage];
        [request sendQuery];
        [_baseTableView reloadData];
    }
}

- (void)finishLoadTableViewData:(MICommentReceiveGetModel *)model
{
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    
    if (self.loading) {
        self.loading = NO;
        [super finishLoadTableViewData];
    }
    
    if (model.page.integerValue == 1) {
        [commentsArray removeAllObjects];
    }
    
    if (model.msgComments != nil && model.count != 0) {
        [commentsArray addObjectsFromArray:model.msgComments];
    }
    
    if ([commentsArray count] != 0) {
        if (model.msgComments.count < model.pageSize.intValue) {
            _hasMore = NO;
        } else {
            _hasMore = YES;
        }
        
        tipsView.hidden = YES;
        _baseTableView.hidden = NO;
        [_baseTableView reloadData];
    } else {
        _baseTableView.hidden = YES;
        tipsView.hidden = NO;
    }
}

- (void)failLoadTableViewData
{
    if (self.loading) {
        self.loading = NO;
        [super failLoadTableViewData];
    }
    
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if ([self.commentsArray count] == 0) {
        [self setOverlayStatus:EOverlayStatusError labelText:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = commentsArray.count;
    if (rows > 0 && _hasMore) {
        rows++;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hasMore && (commentsArray.count == indexPath.row)) {
        return 50; //加载更多的cell高度
    } else if(self.commentsArray.count > indexPath.row){
        MIMsgCommentModel *commentModel = [self.commentsArray objectAtIndex:indexPath.row];
        NSString *content = commentModel.comment;
        CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(290, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        commentModel.commentHeight = @(size.height);
        return (size.height > 0 ? size.height : 20) + 170;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_hasMore && (commentsArray.count == indexPath.row)) {
        static NSString *activityIndicatorIdentifier = @"loadCellReuseIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityIndicatorIdentifier];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityIndicatorIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];

            UIButton *contentView = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 45)];
            contentView.userInteractionEnabled = NO;
            contentView.backgroundColor = [UIColor whiteColor];
            contentView.titleLabel.font = [UIFont systemFontOfSize:14];
            contentView.layer.cornerRadius = 3.0;
            contentView.clipsToBounds = YES;
            [cell addSubview:contentView];
            
            UILabel *loadMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 45)];
            loadMoreLabel.textAlignment = UITextAlignmentCenter;
            loadMoreLabel.font = [UIFont systemFontOfSize:14];
            loadMoreLabel.tag = 1002;
            [contentView addSubview:loadMoreLabel];
            
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            spinner.center = CGPointMake(80, 22.5);
            spinner.tag = 1001;
            [contentView addSubview:spinner];
        }
        
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[cell viewWithTag:1001];
        UILabel *loadMoreLabel = (UILabel *)[cell viewWithTag:1002];
        if (self.loading) {
            loadMoreLabel.text = @"加载中...";
            [spinner startAnimating];
        } else {
            loadMoreLabel.text = @"查看更多...";
            [spinner stopAnimating];
        }
        
        return cell;
    } else {
        static NSString *TableIdentifier = @"commentsCellReuseIdentifier";
        MICommentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TableIdentifier];
        if (!cell)
        {
            cell = [[MICommentTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:TableIdentifier];
        }

        MIMsgCommentModel *commentModel = commentsArray[indexPath.row];
        cell.commentModel = commentModel;
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.avatar] placeholderImage:[UIImage imageNamed:@"ic_my_avatar"]];
        cell.nameLabel.text = commentModel.nick;
        NSString *time = [[NSDate dateWithTimeIntervalSince1970:commentModel.gmtCreate.doubleValue] stringForTimeRelative];
        if (commentModel.pid && commentModel.pid.integerValue > 0) {
            cell.descLabel.text = [[NSString alloc] initWithFormat:@"%@ 回复了你的评论", time];
        } else {
            cell.descLabel.text = [[NSString alloc] initWithFormat:@"%@ 评论了你的信息", time];
        }
        cell.contentLabel.viewHeight = commentModel.commentHeight.floatValue + 5;
        cell.contentLabel.text = commentModel.comment;
        cell.itemBackgroundView.top = cell.contentLabel.bottom;
        cell.backgroundView.viewHeight = commentModel.commentHeight.floatValue + 160;
        [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.img] placeholderImage:[UIImage imageNamed:@"img_loading_small"]];
        cell.itemTitle.text = commentModel.title;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_hasMore && (commentsArray.count == indexPath.row) && !self.loading) {
        [self loadMoreTableViewDataSource];
    }
}

@end
