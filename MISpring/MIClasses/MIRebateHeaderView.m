//
//  MIRebateHeaderView.m
//  MISpring
//
//  Created by 曲俊囡 on 14-5-26.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIRebateHeaderView.h"
#import "MITaskViewController.h"

@implementation MIRebateHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        RTLabel *taskTipsLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, 10, 300, 25)];
        taskTipsLabel.text = @"<font face='HelveticaNeue-CondensedBold' size=18.0 color='#FF7B52'>任务返利</font>  天天有钱拿";
        taskTipsLabel.font = [UIFont systemFontOfSize:12.0];
        taskTipsLabel.textColor = [UIColor lightGrayColor];
        taskTipsLabel.backgroundColor = [UIColor clearColor];
        taskTipsLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
        taskTipsLabel.layer.shadowOffset = CGSizeMake(0, -0.8);
        taskTipsLabel.textAlignment = RTTextAlignmentLeft;
        [self addSubview: taskTipsLabel];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, taskTipsLabel.bottom, PHONE_SCREEN_SIZE.width - 20, 40)];
        view.backgroundColor = [UIColor whiteColor];
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 3;
        [self addSubview:view];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7.5, 25, 25)];
        imageView.image = [UIImage imageNamed:@"ic_task_receive_orange"];
        [view addSubview:imageView];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 150, view.viewHeight)];
        title.text = @"动动手指 月赚千元";
        title.textColor = [MIUtility colorWithHex:0x666666];
        title.font = [UIFont systemFontOfSize:14];
        title.backgroundColor = [UIColor clearColor];
        [view addSubview:title];
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 65, view.viewHeight)];
        detailLabel.text = @"马上赚钱";
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.textColor = [UIColor lightGrayColor];
        detailLabel.font = [UIFont systemFontOfSize:12];
        detailLabel.backgroundColor = [UIColor clearColor];
        [view addSubview:detailLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToTask)];
        [view addGestureRecognizer:tap];
    }
    return self;
}

- (void)goToTask
{
    if ([MIMainUser getInstance].loginStatus == MILoginStatusNotLogined) {
        [MINavigator openLoginViewController];
    } else {
        MITaskViewController *taskVC = [[MITaskViewController alloc] initWithNibName:@"MITaskViewController" bundle:nil];
        [[MINavigator navigator] openPushViewController:taskVC animated:YES];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
