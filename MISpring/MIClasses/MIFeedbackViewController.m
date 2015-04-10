//
//  MIFeedbackViewController.m
//  MiZheHD
//
//  Created by 徐 裕健 on 13-8-7.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIFeedbackViewController.h"
#import "MIAppDelegate.h"

#define Max_Bubble_Width   250
#define MISETTING_UMENG_FEEDBACK_NEWREPLIES   @"UmengFeedBackNewsReplies"

@interface MIBubbleCell : UITableViewCell

@property (nonatomic, assign) BOOL bubbleOut;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *bubbleBkgImageView;
@property (nonatomic, strong) UILabel *bubblelabel;

- (void)reloadAllViewFrameWithText:(NSString *)text bubbleType:(BOOL)bubbleOut;

@end

@implementation MIBubbleCell
@synthesize bubbleOut = _bubbleOut;
@synthesize timeLabel;
@synthesize bubbleBkgImageView;
@synthesize bubblelabel;


- (id) initWithreuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;

        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, PHONE_SCREEN_SIZE.width, 23)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = UITextAlignmentCenter;
        timeLabel.font = [UIFont boldSystemFontOfSize:10];
        timeLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:timeLabel];
        
        bubbleBkgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:bubbleBkgImageView];
        
        bubblelabel = [[UILabel alloc] initWithFrame:bubbleBkgImageView.frame];
        bubblelabel.font = [UIFont boldSystemFontOfSize:15];
        bubblelabel.numberOfLines = 0;
        bubblelabel.lineBreakMode = NSLineBreakByWordWrapping;
        bubblelabel.backgroundColor = [UIColor clearColor];
        [bubbleBkgImageView addSubview:bubblelabel];

    }
    return self;
}

- (void)reloadAllViewFrameWithText:(NSString *)text bubbleType:(BOOL)bubbleOut
{
    if (0 == [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
    {
        return;
    }
    
    CGSize size = [text sizeWithFont:bubblelabel.font constrainedToSize:CGSizeMake(Max_Bubble_Width, 4000) lineBreakMode:NSLineBreakByWordWrapping];
    bubblelabel.text = text;

    UIImage *bubble;
    //聊天框
    if(!bubbleOut){
        bubbleBkgImageView.frame = CGRectMake(PHONE_SCREEN_SIZE.width - size.width - 35.0f, timeLabel.bottom, size.width+30.0f, size.height + 20.0f);
        bubblelabel.frame = CGRectMake(10.0,10.0,size.width,size.height);

        bubble = [[UIImage imageNamed:@"bubble-square-outgoing"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 18.0f, 16.0f, 23.0f)];
    }
    else
    {
        bubbleBkgImageView.frame = CGRectMake(5.0f, timeLabel.bottom, size.width + 30.0f, size.height + 20.0f);
        bubblelabel.frame = CGRectMake(20.0,10.0,size.width,size.height);

        bubble = [[UIImage imageNamed:@"bubble-square-incoming"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 25.0f, 16.0f, 23.0f)];
    }
    [bubbleBkgImageView setImage:bubble];

}

@end

@interface MIFeedbackViewController ()

@property (nonatomic, strong) NSMutableArray *feedBackArray;

@end

@implementation MIFeedbackViewController
@synthesize umengFeedback;
//@synthesize navigationBarView;
@synthesize feedBackTextField;
@synthesize manualSetOffSet;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    umengFeedback = [UMFeedback sharedInstance];
    [umengFeedback setAppkey:kUmengAppKey delegate:self];
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight - 48) style:UITableViewStylePlain];
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    self.baseTableView.backgroundColor = RGBCOLOR(226, 226, 226);
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view sendSubviewToBack:_baseTableView];
    
    UIView *inputFieldBack = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.view.viewHeight - 48, PHONE_SCREEN_SIZE.width, 48)];
    [self.view addSubview:inputFieldBack];
    
    UIImage *textfieldBg = [[UIImage imageNamed:@"feedback_inputbox"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 67, 16, 67)];
    feedBackTextField = [[UITextField  alloc] initWithFrame:CGRectMake(8.0f, 8.0f, PHONE_SCREEN_SIZE.width - 16, 32)];
    feedBackTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 32)];
    feedBackTextField.leftViewMode = UITextFieldViewModeAlways;
    feedBackTextField.delegate = self;
    feedBackTextField.background = textfieldBg;
    feedBackTextField.backgroundColor = [UIColor whiteColor];
    feedBackTextField.font = [UIFont boldSystemFontOfSize:16];
    feedBackTextField.textColor = [UIColor blackColor];
    feedBackTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
    feedBackTextField.keyboardType = UIKeyboardTypeDefault;
    feedBackTextField.returnKeyType = UIReturnKeySend;
    feedBackTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    feedBackTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    feedBackTextField.placeholder = @"用的不爽，吐槽一下。";
    [inputFieldBack addSubview:feedBackTextField];
    
    [self.navigationBar setBarTitle:@"意见反馈"];
    [self.navigationBar setBarLeftButtonItem:self selector:@selector(popViewFromNavigation) imageKey:@"navigationbar_btn_back"];
    [self.navigationBar setBarRightTextButtonItem:self selector:@selector(sendFeedBack) title:@"发送"];

    _feedBackArray = [[NSMutableArray alloc] initWithCapacity:10];
    [self.feedBackArray addObject:@{@"type": @"dev_reply" ,@"content":@"有问题欢迎随时点击客服在线哦，请关注米折微博和微信：@米折网，优惠活动早知道！还可以与米姑娘进行互动。"}];
    [umengFeedback get];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.removeFromSuperViewOnHide = YES;
    _hud.yOffset = -100.0f;
}

#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendFeedBack];
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (manualSetOffSet != YES) {
        [self.feedBackTextField resignFirstResponder];
    }
}
#pragma mark keyboard notification

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* info = notification.userInfo;

    [UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.baseTableView.viewHeight = self.view.viewHeight - self.navigationBarHeight - 48;
        [feedBackTextField superview].top = self.baseTableView.bottom;
    }];
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary* info = notification.userInfo;
    NSValue* kbFrameValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    manualSetOffSet = YES;
    
    [UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.baseTableView.viewHeight = self.view.viewHeight - self.navigationBarHeight - 48 - ([kbFrameValue CGRectValue].size.height);
        [feedBackTextField superview].top = self.baseTableView.bottom;
    } completion:^(BOOL finished){
        [self.baseTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.feedBackArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        manualSetOffSet = NO;
    }];
}

#pragma mark - tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";
	MIBubbleCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (!cell) {
        cell = [[MIBubbleCell alloc] initWithreuseIdentifier:cellIdentifier];
    }
    
    if (self.feedBackArray.count > indexPath.row)
    {
        if (0 == indexPath.row)
        {
            cell.timeLabel.text = @"亲，客服工作时间为周一至周五09:00~18:00";
        }
        else
        {
            NSString *dateTitle = [[self.feedBackArray objectAtIndex:indexPath.row] objectForKey:@"datetime"];
            NSString *dateFormatTime = [[dateTitle dateFromStatusFormat] stringForSectionTitle3];
            if (dateFormatTime && dateFormatTime.length > 0) {
                cell.timeLabel.text = dateFormatTime;
            } else {
                cell.timeLabel.text = dateTitle;
            }
        }
        
        BOOL bubbleOut = [[[self.feedBackArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"dev_reply"];
        [cell reloadAllViewFrameWithText:[[self.feedBackArray objectAtIndex:indexPath.row] objectForKey:@"content"] bubbleType:bubbleOut];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.feedBackArray.count > indexPath.row) {
        CGSize size = [[[self.feedBackArray objectAtIndex:indexPath.row] objectForKey:@"content"] sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(Max_Bubble_Width, 4000) lineBreakMode:NSLineBreakByWordWrapping];
        
        return size.height + 20.0 + 25.0;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feedBackArray.count;
}

- (void)popViewFromNavigation
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendFeedBack
{
    if (feedBackTextField.text.length == 0) {
        [self showSimpleHUD:@"请先输入反馈内容" afterDelay:1.3];
        return;
    }
    
    if (_hud) {
        [_hud hide:YES];
        _hud = nil;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.removeFromSuperViewOnHide = YES;
    _hud.yOffset = -100.0f;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:feedBackTextField.text forKey:@"content"];
    NSDictionary *contact = [NSDictionary dictionaryWithObjectsAndKeys:[MIMainUser getInstance].loginAccount, @"email", [MIMainUser getInstance].userId, @"uid", nil];
    [dictionary setObject:contact forKey:@"contact"];
    [umengFeedback post:dictionary];
}

#pragma mark - UMFeedbackDataDelegate
- (void)postFinishedWithError:(NSError *)error
{
    [_hud hide:YES];
    
    NSString *dateString = [[NSDate date]  stringForYyyymmddhhmmss];
    [self.feedBackArray addObject:@{@"type": @"feedBack" ,@"content":feedBackTextField.text,@"datetime":dateString}];
    [self.baseTableView reloadData];
    [self.baseTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.feedBackArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.feedBackTextField.text = @"";
    
    if (error) {
        [self showSimpleHUD:@"发送失败，请稍后再试" afterDelay:1.3];
    } else {
        [self showSimpleHUD:@"发送成功，谢谢您反馈" afterDelay:1.3];
    }
}
- (void)getFinishedWithError:(NSError *)error
{
    [_hud hide:YES];
    if (!error)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey: MISETTING_UMENG_FEEDBACK_NEWREPLIES];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.feedBackArray addObjectsFromArray:umengFeedback.topicAndReplies];
        [self.baseTableView reloadData];
        NSIndexPath* ipath = [NSIndexPath indexPathForRow: (self.feedBackArray.count - 1) inSection: 0];
        [self.baseTableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    }
    else
    {
        [self showSimpleHUD:@"获取反馈失败，请稍后再试" afterDelay:1.3];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
