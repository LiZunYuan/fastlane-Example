//
//  MIBBSpecialProductCell.h
//  MISpring
//
//  Created by husor on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBBProductItemView.h"

@interface MIBBSpecialProductCell : UITableViewCell
@property (nonatomic, strong) MIBBProductItemView * itemView1;
@property (nonatomic, strong) MIBBProductItemView * itemView2;
@property (nonatomic, strong) NSString *shopImageString;
@property (nonatomic, strong) NSString *shopNameString;
@property (nonatomic, strong) NSString *shopTitleString;
@property (nonatomic, assign) double gmtBegin;
@property (nonatomic, assign) double gmtEnd;
@property (nonatomic, assign) NSInteger eventId;

- (id) initWithreuseIdentifier:(NSString *)reuseIdentifier;
- (void)updateCellView:(MIBBProductItemView *)itemView tuanModel:(id)model;

@end
