//
//  MIModifyNickNameViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-19.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"
#import "MIUserNickUpdateRequest.h"

@interface MIModifyNickNameViewController : MIBaseViewController<UITextFieldDelegate>

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) MIUserNickUpdateRequest *request;

- (id)initWithNickName:(NSString *)aNickName;

@end
