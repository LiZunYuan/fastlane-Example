//
//  MITuanItemsCell.h
//  MISpring
//
//  Created by 曲俊囡 on 14-5-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITuanItemView.h"

@interface MITuanItemsCell : UITableViewCell

@property(nonatomic, strong) MITuanItemView * itemView1;
@property(nonatomic, strong) MITuanItemView * itemView2;

- (id) initWithreuseIdentifier:(NSString *)reuseIdentifier;

@end
