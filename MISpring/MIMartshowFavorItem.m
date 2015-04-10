//
//  BBMartshowFavorItem.m
//  BeiBeiAPP
//
//  Created by yujian on 14-11-27.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIMartshowFavorItem.h"
#import "MIBrandViewController.h"

@implementation MIMartshowFavorItem

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = [MIUtility colorWithHex:0xe5e5e5].CGColor;
        self.layer.borderWidth = .6;
        self.backgroundColor = [UIColor whiteColor];
        self.exclusiveTouch = YES;
        
        _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewWidth)];
        [self addSubview:_itemImageView];
        
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 22)];
        self.tipLabel.bottom = self.itemImageView.bottom;
        [self.tipLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
        self.tipLabel.textAlignment = UITextAlignmentCenter;
        self.tipLabel.font = [UIFont systemFontOfSize:10.0];
        self.tipLabel.textColor = [MIUtility colorWithHex:0xffffff];
        [self addSubview:self.tipLabel];
//        self.tipLabel.bottom = self.bottom - 4;
        
        _martshowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, _itemImageView.bottom + 10, 50, 25)];
        [self addSubview:self.martshowIcon];
        
        _martshowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _itemImageView.bottom + 10, self.viewWidth - _martshowIcon.right - 5, 12)];
        _martshowLabel.left = _martshowIcon.right + 5;
        _martshowLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:self.martshowLabel];
        
        _discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 10)];
        _discountLabel.font = [UIFont systemFontOfSize:10.0];
        _discountLabel.textColor = [MIUtility colorWithHex:0x999999];
        _discountLabel.left = _martshowLabel.left;
        _discountLabel.top = _martshowLabel.bottom + 4;
        [self addSubview:self.discountLabel];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 1)];
//        line.backgroundColor = [MIUtility colorWithHex:0xe5e5e5];
//        line.top = _martshowIcon.bottom + 8;
//        [self addSubview:line];

        
        _deleteView = [[MIFavorDeleteView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _deleteView.backgroundColor = [UIColor clearColor];
        _deleteView.deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 19, 19)];
        _deleteView.deleteImageView.image = [UIImage imageNamed:@"ic_favorite_check"];
        [_deleteView addSubview:_deleteView.deleteImageView];
        [self addSubview:_deleteView];
        
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
    MIBrandViewController *vc = [[MIBrandViewController alloc] initWithAid:_model.aid.intValue];
//    vc.cat = _model.cat;
    vc.origin = _model.origin.integerValue;
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}


@end
