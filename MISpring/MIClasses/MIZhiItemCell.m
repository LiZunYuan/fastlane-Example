//
//  MIZhiItemCell.m
//  MISpring
//
//  Created by 徐 裕健 on 13-10-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIZhiItemCell.h"
#import "MIZhiDetailViewController.h"
#import "MIZhiItemVoteAddRequest.h"
#import "MIZhiVoteAddModel.h"

@implementation MIZhiItemCell
@synthesize itemModel;
@synthesize itemImage;
@synthesize itemTitle;
@synthesize statusImage;
@synthesize commentLabel;
@synthesize voteImageView;
@synthesize voteLabel;
@synthesize timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];

        UIButton *contentView = [[UIButton alloc] initWithFrame:CGRectMake(8, 3, 304, 114)];
        contentView.backgroundColor = [UIColor clearColor];
        [contentView setBackgroundImage:[[UIImage imageNamed:@"bg_order_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)] forState:UIControlStateNormal];
        [contentView setBackgroundImage:[[UIImage imageNamed:@"bg_order_highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)] forState:UIControlStateHighlighted];
        [contentView addTarget:self action:@selector(goDetailViewController) forControlEvents:UIControlEventTouchUpInside];
      
        itemImage = [[UIImageView alloc] initWithFrame: CGRectMake(10, 10, 94, 94)];
        itemImage.contentMode = UIViewContentModeScaleAspectFill;
        itemImage.clipsToBounds = YES;
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, 185, 20)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = [UIColor lightGrayColor];
        
        itemTitle = [[RTLabel alloc] initWithFrame: CGRectMake(110, 25, 185, 55)];
        itemTitle.backgroundColor = [UIColor clearColor];
        itemTitle.userInteractionEnabled = NO;
        itemTitle.lineSpacing = 1.0;
        itemTitle.lineBreakMode = RTTextLineBreakModeCharWrapping;
        itemTitle.font = [UIFont systemFontOfSize: 14];
        itemTitle.textColor = [UIColor darkGrayColor];
              
        statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(240, 75, 55, 25)];
        statusImage.contentMode = UIViewContentModeScaleAspectFill;

        //comment
        UIButton *commentBkgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBkgBtn.frame = CGRectMake(110, 85, 60, 20);
        [commentBkgBtn addTarget:self action:@selector(goDetailViewController) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_comment_small"]];
        commentImageView.frame = CGRectMake(1, 0, 14, 14);
        [commentBkgBtn addSubview:commentImageView];
        
        commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 70, 20)];
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.font = [UIFont systemFontOfSize:12];
        commentLabel.textColor = [UIColor grayColor];
        [commentBkgBtn addSubview:commentLabel];
        commentImageView.centerY = commentLabel.centerY;
      
        //vote
        UIButton *voteBkgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        voteBkgBtn.frame = CGRectMake(170, 85, 70, 20);
        [voteBkgBtn addTarget:self action:@selector(voteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        voteImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_zan_small"]];
        voteImageView.frame = CGRectMake(1, 0, 14, 14);
        [voteBkgBtn addSubview:voteImageView];
        
        voteLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 70, 20)];
        voteLabel.backgroundColor = [UIColor clearColor];
        voteLabel.font = [UIFont systemFontOfSize:12];
        voteLabel.textColor = [UIColor grayColor];
        [voteBkgBtn addSubview:voteLabel];
        voteImageView.centerY  = voteLabel.centerY;
       
        [contentView addSubview: itemImage];
        [contentView addSubview: itemTitle];
        [contentView addSubview: statusImage];
        [contentView addSubview: commentBkgBtn];
        [contentView addSubview: voteBkgBtn];
        [contentView addSubview: timeLabel];
        [self addSubview:contentView];
    }
    return self;
}

- (void)goDetailViewController
{
    [MobClick event:kZhiItemViews];
    [MIUtility clickEventWithLog:@"zhi" cid:itemModel.zid.stringValue s:@"4"];

    MIZhiDetailViewController *detailViewController = [[MIZhiDetailViewController alloc] initWithItem:self.itemModel];
    detailViewController.cat = self.cat;
    [[MINavigator navigator] openPushViewController:detailViewController animated:YES];
}

- (void)voteAction:(UIButton *)sender
{
    [MobClick event:kZhiVoteClicks];

    if ([[MIMainUser getInstance] checkLoginInfo])
    {
        //VoteRequestRequest
        if (self.itemModel.vote.boolValue) {
            self.voteLabel.text = self.itemModel.voteCount.stringValue;
            self.voteImageView.image = [UIImage imageNamed:@"ic_zan_middle"];
            [MINavigator showSimpleHudWithTips:@"你已经投过票了" afterDelay:1.0];
        } else {            
            self.itemModel.vote = [NSNumber numberWithInt:1];
            self.itemModel.voteCount = [NSNumber numberWithInt:(self.itemModel.voteCount.intValue + 1)];
            self.voteLabel.text = self.itemModel.voteCount.stringValue;
            self.voteImageView.image = [UIImage imageNamed:@"ic_zan_middle"];
            [UIView animateWithDuration:0.3 animations:^{
                
                CGAffineTransform newTransform = CGAffineTransformMakeScale(1.6, 1.6);
                [self.voteImageView setTransform:newTransform];
                
            } completion:^(BOOL finished){
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    CGAffineTransform newTransform = CGAffineTransformMakeScale(1.0, 1.0);
                    [self.voteImageView setTransform:newTransform];
                }];
                
            }];

            MIZhiItemVoteAddRequest *voteAddRequest = [[MIZhiItemVoteAddRequest alloc] init];
            voteAddRequest.onCompletion = ^(MIZhiVoteAddModel *model) {
                if (model.success.boolValue == NO) {
                    [MINavigator showSimpleHudWithTips:model.message afterDelay:1.0];
                }
            };
            voteAddRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
                MILog(@"error_msg=%@",error.description);
            };
            [voteAddRequest setZid:[NSString stringWithFormat:@"%@", self.itemModel.zid]];
            [voteAddRequest sendQuery];
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

@end
