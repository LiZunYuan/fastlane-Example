//
//  MIZhiReplyViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 13-10-24.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIZhiReplyViewController.h"
#import "MICommentAddModel.h"

#define keyBoardDefaultHeight  216.0
#define itemMarginHeight     10.0
#define maxInputLen       140

@interface MIZhiReplyViewController ()

@end

@implementation MIZhiReplyViewController
@synthesize name,toUid,itemId,commentId,type,delegate;
@synthesize commentBackgroundView;
@synthesize inputText;
@synthesize captionLimitLabel;
@synthesize placeHolderLabel;
@synthesize commentAddRequest = _commentAddRequest;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [inputText becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *placeHolderText;
    if (name != nil) {
        placeHolderText = [NSString stringWithFormat:@"回复：%@", name];
        [self.navigationBar setBarTitle:@"回复评论"];
    } else {
        placeHolderText = @"写评论，给其他米粉一些帮助吧~";
        [self.navigationBar setBarTitle:@"发表评论"];
    }
    
    [self.navigationBar setBarRightTextButtonItem:self selector:@selector(goToSend:) title:@"发送"];
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(closeModalViewController:) imageKey:@"navigationbar_btn_close"];
    
    commentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(5, itemMarginHeight + self.navigationBarHeight, 310, self.view.viewHeight - keyBoardDefaultHeight - itemMarginHeight*2 - self.navigationBarHeight)];
    commentBackgroundView.backgroundColor = [UIColor whiteColor];
    commentBackgroundView.layer.cornerRadius = 5.0;
    commentBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    commentBackgroundView.layer.shadowOffset = CGSizeMake(1, 1);
    commentBackgroundView.layer.shadowRadius = 1;
    commentBackgroundView.layer.shadowOpacity = 0.8;
    [self.view addSubview:commentBackgroundView];
    
    CGRect statusFrame = CGRectMake(0, 5,
                                    commentBackgroundView.viewWidth,
                                    commentBackgroundView.viewHeight - 20);
    inputText =[[UITextView alloc] initWithFrame:statusFrame];
    inputText.contentSize = statusFrame.size;
    inputText.backgroundColor = [UIColor whiteColor];
    inputText.font = [UIFont systemFontOfSize:16];
    inputText.delegate = self;
    [commentBackgroundView addSubview:inputText];
    
    placeHolderLabel = [[RTLabel alloc] initWithFrame:CGRectMake(8, 15, statusFrame.size.width - 20, 20)];
    placeHolderLabel.backgroundColor = [UIColor clearColor];
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    placeHolderLabel.textAlignment = UITextAlignmentLeft;
    placeHolderLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    placeHolderLabel.font = [UIFont boldSystemFontOfSize:16];
    placeHolderLabel.text = placeHolderText;
    [commentBackgroundView addSubview:placeHolderLabel];
    
    captionLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, commentBackgroundView.viewHeight - 15, 290, 15)];
    captionLimitLabel.backgroundColor = [UIColor whiteColor];
    captionLimitLabel.font = [UIFont systemFontOfSize:12];
    captionLimitLabel.textColor = [MIUtility colorWithHex:0x666666];
    captionLimitLabel.textAlignment = UITextAlignmentRight;
    [commentBackgroundView addSubview:captionLimitLabel];
    [self updateCaptionLimitTips];
}

-(void)updateCaptionLimitTips
{
    NSInteger captionLen = 0;
    if (inputText.text) {
        captionLen = inputText.text.length;
    }
    captionLimitLabel.text = [NSString stringWithFormat:@"%ld/%d ", (long)captionLen, maxInputLen];
    captionLimitLabel.textColor = [UIColor darkGrayColor];
    if (captionLen > maxInputLen) {
        captionLimitLabel.textColor = [UIColor redColor];
    }
}

- (void)closeModalViewController: (id) event
{
    [[MINavigator navigator] closeModalViewController:YES completion:nil];
}
- (void)goToSend:(id)sender
{
    if (inputText.text == nil || [inputText.text.trim isEqualToString:@""]) {
        [self showSimpleHUD:@"评论内容不能为空哦~"];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.yOffset = -100.0f;
    
    //VoteRequestRequest
    __weak typeof(self) weakSelf = self;
    _commentAddRequest = [[MICommentAddRequest alloc] init];
    _commentAddRequest.onCompletion = ^(MICommentAddModel *model) {
        [hud setHidden:YES];
        [weakSelf finishComment:model];
    };
    _commentAddRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        [hud setHidden:YES];
        MILog(@"error_msg=%@",error.description);
    };
    [_commentAddRequest setItemId:itemId];
    [_commentAddRequest setType:type];
    if (toUid != -1)
    {
        [_commentAddRequest setTouid:toUid];
        [_commentAddRequest setPid:commentId];
    }
   
    [_commentAddRequest setComment:inputText.text];
    [_commentAddRequest sendQuery];
    
}
- (void)finishComment:(MICommentAddModel *)model
{
    if (model.success.boolValue)
    {
        [[MINavigator navigator] closeModalViewController:YES completion:^{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[model.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            MICommentModel *dataModel = [MIUtility convertDisctionary2Object: dic className: @"MICommentModel"];
            if ([delegate respondsToSelector:@selector(finishSendComment:)])
            {
                [delegate finishSendComment:dataModel];
            }
        }];
    }
    else
    {
        [self showSimpleHUD:model.message];
    }
}

#pragma mark keyboard notification

-(void)keyboardDidHide:(NSNotification *)notification{
    commentBackgroundView.frame = CGRectMake(5, itemMarginHeight + self.navigationBarHeight,
                                           310, self.view.viewHeight - keyBoardDefaultHeight - itemMarginHeight*2 - self.navigationBarHeight);
    CGRect statusFrame = CGRectMake(0, 5,
                                    commentBackgroundView.viewWidth,
                                    commentBackgroundView.viewHeight - 20);
    inputText.frame = statusFrame;
    inputText.contentSize = statusFrame.size;
    captionLimitLabel.Frame = CGRectMake(10, commentBackgroundView.viewHeight - 15, 290, 15);
}

-(void)keyboardDidShow:(NSNotification *)notification{
    NSDictionary* info = notification.userInfo;
    NSValue* kbFrameValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    
    commentBackgroundView.frame = CGRectMake(5, itemMarginHeight + self.navigationBarHeight,
                                           310, self.view.viewHeight - [kbFrameValue CGRectValue].size.height - itemMarginHeight*2 - self.navigationBarHeight);
    
    CGRect statusFrame = CGRectMake(0, 5,
                                    commentBackgroundView.viewWidth,
                                    commentBackgroundView.viewHeight - 20);
    inputText.frame = statusFrame;
    inputText.contentSize = statusFrame.size;
    captionLimitLabel.Frame = CGRectMake(10, commentBackgroundView.viewHeight - 15, 290, 15);
}

#pragma mark UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateCaptionLimitTips];
    if (textView.text.length == 0)
    {
        placeHolderLabel.hidden = NO;
    }
    else
    {
        placeHolderLabel.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
