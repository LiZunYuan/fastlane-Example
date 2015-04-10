//
//  BBBindEmailView.h
//  BeiBeiAPP
//
//  Created by yujian on 14-10-22.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIBindEmailDelegate <NSObject>

- (void)confirmBindEmail:(id)event;

@end

@interface MIBindEmailView : UIView
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) id<MIBindEmailDelegate> delegate;
@end
