//
//  BBFindBackView.h
//  BeiBeiAPP
//
//  Created by yujian on 14-10-22.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIFindPasswordDelegate <NSObject>

- (void)confirmFindPassword:(id)event;

@end

@interface MIFindBackView : UIView
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *bNewPasswordTextField;

@property (nonatomic, weak) id<MIFindPasswordDelegate> delegate;

@end
