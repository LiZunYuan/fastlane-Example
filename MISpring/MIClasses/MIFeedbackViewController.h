//
//  MIFeedbackViewController.h
//  MiZheHD
//
//  Created by 徐 裕健 on 13-8-7.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "UMFeedback.h"
#import "RTLabel.h"

@interface MIFeedbackViewController : MIBaseViewController<UITextFieldDelegate, UMFeedbackDataDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *_hud;
}

@property (nonatomic, assign) BOOL manualSetOffSet;
@property (nonatomic, strong) UITableView *baseTableView;
@property (nonatomic, strong) UMFeedback *umengFeedback;
//@property (nonatomic, strong) MINavigationBar *navigationBarView;
@property (nonatomic, strong) UITextField *feedBackTextField;
@end
