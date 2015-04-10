//
//  MallSearchItemTableViewCell.m
//  MISpring
//
//  Created by Mac Chow on 13-3-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MallSearchItemTableViewCell.h"

@implementation MallSearchItemTableViewCell

@synthesize mallId;
@synthesize mallName;
@synthesize imageView;
@synthesize labelTitle;
@synthesize labelCommission;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imageView = [[UIImageView alloc] initWithFrame: CGRectMake(10, 12, 80, 40)];
        
        labelTitle = [[UILabel alloc] initWithFrame: CGRectMake(100, 3, 200, 40)];
        labelTitle.lineBreakMode = UILineBreakModeWordWrap;
        labelTitle.numberOfLines = 0;
        labelTitle.font = [UIFont systemFontOfSize: 14];
        
        labelCommission = [[UILabel alloc] initWithFrame: CGRectMake(100, 31, 200, 20)];
        labelCommission.textColor = [UIColor lightGrayColor];
        labelCommission.font = [UIFont systemFontOfSize: 12];
        
        [self addSubview: imageView];
        [self addSubview: labelTitle];
        [self addSubview: labelCommission];
    }
    return self;
}

@end
