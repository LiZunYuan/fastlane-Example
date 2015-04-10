//
//  CollapseClickCell.m
//  CollapseClick
//
//  Created by Ben Gordon on 2/28/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "CollapseClickCell.h"

@implementation CollapseClickCell

@synthesize contentView = _contentView;
@synthesize titleView = _titleView;
@synthesize titleButton = _titleButton;
@synthesize titleArrow = _titleArrow;
@synthesize index = _index;
@synthesize isClicked = _isClicked;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, 40.0)];
        _titleView.alpha = 1.000;
        _titleView.autoresizesSubviews = YES;
        _titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _titleView.backgroundColor = [UIColor colorWithWhite:0.553 alpha:1.000];
        _titleView.clearsContextBeforeDrawing = YES;
        _titleView.clipsToBounds = NO;
        [self addSubview:_titleView];
        
        _titleArrow = [[CollapseClickArrow alloc] initWithFrame:CGRectMake(frame.size.width - 20, (_titleView.frame.size.height - 10) / 2, 10.0, 10.0)];
        _titleArrow.backgroundColor = [UIColor clearColor];
        [_titleView addSubview:_titleArrow];
        
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.alpha = 1.000;
        _titleButton.frame = CGRectMake(0.0, -1.0, frame.size.width, 42.0);
        _titleButton.backgroundColor = [UIColor clearColor];
        _titleButton.layer.shadowColor = [UIColor colorWithWhite:0.153 alpha:0.300].CGColor;
        _titleLabel.shadowOffset = CGSizeMake(0.0, -1);
        [_titleView addSubview:_titleButton];
        
        _titleLabel = _titleButton.titleLabel;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 20, 40.0)];
        _titleLabel.shadowColor = [UIColor colorWithWhite:0.153 alpha:0.300];
        _titleLabel.shadowOffset = CGSizeMake(0.0, -.5);
        _titleLabel.textColor = [UIColor colorWithWhite:1.000 alpha:1.000];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize: 14];
        [_titleView addSubview:_titleLabel];
        
        _contentView = [[UIView alloc] init];
        _contentView.autoresizesSubviews = YES;
        _contentView.contentMode = UIViewContentModeScaleAspectFill;
        _contentView.frame = CGRectMake(0.0, kCCHeaderHeight, frame.size.width, 100.0);
        _contentView.hidden = NO;
        
        [self addSubview:_contentView];

    }
    return self;
}

+ (CollapseClickCell *)newCollapseClickCellWithTitle:(NSString *)title width:(int)width index:(int)index content:(UIView *)content {
    CollapseClickCell *cell = [[CollapseClickCell alloc] initWithFrame:CGRectMake(0, 0, width, kCCHeaderHeight)];
    
    cell.titleLabel.text = title;
    cell.index = index;
    cell.titleButton.tag = index;
    cell.contentView.frame = CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, cell.contentView.frame.size.width, content.frame.size.height - 10);
    [cell.contentView addSubview:content];
    
    [cell.layer setBorderColor: [UIColor lightGrayColor].CGColor];
    [cell.layer setBorderWidth: 1];
    [cell.layer setMasksToBounds: YES];
    [cell.layer setCornerRadius: 5];
    
    return cell;
}


@end
