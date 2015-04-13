//
//  BBFavorDoubleItem.m
//  BeiBeiAPP
//
//  Created by yujian on 14-11-19.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIFavorDoubleItem.h"

@implementation MIFavorDoubleItem

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = [MIUtility colorWithHex:0xe5e5e5].CGColor;
        self.layer.borderWidth = .6;
        self.backgroundColor = [UIColor whiteColor];
        self.exclusiveTouch = YES;
        
        self.itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewWidth)];
        self.itemImageView.clipsToBounds = YES;
        [self.itemImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.itemImageView];
        
        self.favorTitleLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake(2, self.viewWidth + 5, self.viewWidth - 4, 16), 3, 0)];
        self.favorTitleLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByClipping;
        self.favorTitleLabel.font = [UIFont systemFontOfSize:12];
        self.favorTitleLabel.textColor = [MIUtility colorWithHex:0xe505050];
        self.favorTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.favorTitleLabel];
        
        self.priceView = [[UIView alloc] initWithFrame:CGRectMake(0, self.favorTitleLabel.bottom, self.viewWidth, 28)];
        
        self.rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 4, 10, 20)];
        self.rmbLabel.backgroundColor = [UIColor clearColor];
        self.rmbLabel.textColor = [MIUtility colorWithHex:0xff3d00];
        self.rmbLabel.font = [UIFont systemFontOfSize:12];
        self.rmbLabel.text = @"￥";
        [self.priceView addSubview:self.rmbLabel];
        
        self.favorPriceLabel = [[RTLabel alloc] initWithFrame:CGRectMake(15, 5, 142, 20)];
        self.favorPriceLabel.backgroundColor = [UIColor clearColor];
        self.favorPriceLabel.textAlignment = RTTextAlignmentLeft;
        self.favorPriceLabel.textColor = [MIUtility colorWithHex:0xff3d00];
        self.favorPriceLabel.font = [UIFont systemFontOfSize: 19];
        self.favorPriceLabel.userInteractionEnabled = NO;
        [self.priceView addSubview:self.favorPriceLabel];

        self.discountLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake(55, 7, 100, 15), 2, 0)];
        self.discountLabel.font = [UIFont systemFontOfSize:11];
        self.discountLabel.textColor = [MIUtility colorWithHex:0x858585];
        self.discountLabel.right = self.viewWidth - 4;
        self.discountLabel.textAlignment = NSTextAlignmentRight;
        self.discountLabel.backgroundColor = [UIColor clearColor];
        [self.priceView addSubview:self.discountLabel];

        self.originPriceLabel = [[MIDeleteUILabel alloc] initWithFrame: CGRectMake(self.favorPriceLabel.right, 7, 80, 15)];
        self.originPriceLabel.backgroundColor = [UIColor clearColor];
        self.originPriceLabel.textAlignment = NSTextAlignmentLeft;
        self.originPriceLabel.textColor = [MIUtility colorWithHex:0x999999];;
        self.originPriceLabel.font = [UIFont systemFontOfSize: 10];
        self.originPriceLabel.strikeThroughEnabled = YES;
        [self.priceView addSubview:self.originPriceLabel];
        
        [self addSubview:self.priceView];
        
        _deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.viewWidth - 5, self.viewHeight - 5)];
        _deleteView.backgroundColor = [UIColor clearColor];
        _deleteView.userInteractionEnabled = YES;
        _deleteView.image = [UIImage imageNamed:@"ic_favorite_check"];
        _deleteView.contentMode = UIViewContentModeTopLeft;
        [self addSubview:_deleteView];
        
        self.isEditing = NO;
        
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 22)];
        self.tipLabel.bottom = self.itemImageView.bottom;
        [self.tipLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
        self.tipLabel.textAlignment = UITextAlignmentCenter;
        self.tipLabel.font = [UIFont systemFontOfSize:10.0];
        self.tipLabel.textColor = [MIUtility colorWithHex:0xffffff];
        self.tipLabel.hidden = YES;
        [self addSubview:self.tipLabel];
        
        self.tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 13, 13)];
        self.tipImageView.image = [UIImage imageNamed:@"ic_favorite_fall"];
        [self.tipLabel addSubview:self.tipImageView];
        
        self.emptyBacImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        self.emptyBacImageView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1];
        self.emptyBacImageView.contentMode = UIViewContentModeCenter;
        self.emptyBacImageView.userInteractionEnabled = YES;
        self.emptyBacImageView.image = [UIImage imageNamed:@"remind_bg_nothing"];
        self.emptyBacImageView.hidden = YES;
        [self addSubview:self.emptyBacImageView];
        
        [self addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    if (_isEditing)
    {
        _deleteView.hidden = NO;
    }
    else
    {
        _deleteView.hidden = YES;
    }
}

- (void)actionClicked:(id)sender
{
    if (_selectedBlock) {
        _selectedBlock();
    }
}


@end
