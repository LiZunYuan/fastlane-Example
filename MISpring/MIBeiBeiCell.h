//
//  MIBeiBeiCell.h
//  MISpring
//
//  Created by husor on 14-10-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBeiBeiItemView.h"
@interface MIBeiBeiCell : UITableViewCell

@property(nonatomic, strong) MIBeiBeiItemView * itemView1;
@property(nonatomic, strong) MIBeiBeiItemView * itemView2;

- (id) initWithreuseIdentifier:(NSString *)reuseIdentifier;

@end
