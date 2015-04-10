//
//  MIBBMartshowSegment.m
//  MISpring
//
//  Created by husor on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBBMartshowSegment.h"

@implementation MIBBSegmentSubview
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, frame.size.width - 40, frame.size.height)];
        [self addSubview:self.titleLabel];
        self.status = BBSelectedStateNormal;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, (frame.size.height-11.5)/2.0, 6, 11.5)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];

        _hLine = [[UIView alloc] initWithFrame:CGRectMake(self.viewWidth - 1, 5, 1, self.viewHeight - 10)];
        _hLine.backgroundColor = RGBACOLOR(229,229,229,0.75);
        [self addSubview:_hLine];
    }
    return self;
    
}

- (void) setLayout:(NSInteger)offset
{
    _hLine.frame = CGRectMake(self.viewWidth - 1, 5, 1, self.viewHeight - 10);
    _imageView.left = _imageView.left + offset/2;
    _titleLabel.left = _titleLabel.left + offset/2;
}

@end

@implementation MIBBMartshowSegment
{
    MIBBMartsShowSegmentStatus *_statusObj;
    NSMutableArray *_segmentBtnArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *wLine = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width , 1)];
        wLine.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.45];
        [self addSubview:wLine];
    }
    return self;
}


- (void)initWithSubViews
{
    // Initialization code
    _statusObj = [[MIBBMartsShowSegmentStatus alloc] init];
    _segmentBtnArray = [[NSMutableArray alloc] initWithCapacity:0];
    if (self.titleArray.count == 0)
    {
        self.titleArray = @[@"人气",@"价格",@"折扣",@"显示有货"];
    }
    self.segmentIndexCount = self.titleArray.count;
    if (self.segmentTypeArray.count == 0) {
        self.segmentTypeArray = @[@(DownArrowType),@(UpArrowType1),@(UpArrowType2),@(RoundArrowType)];
    }
    
    if (self.segmentTypeArray.count != self.titleArray.count) {
        return;
    }
    
    _statusObj.filterStatus = @(0);
    _statusObj.inStockStatus = @(0);
    [_segmentBtnArray removeAllObjects];
    MIBBSegmentSubview *currentTab = nil;
    NSInteger totalWidth = 0;
    for (NSInteger i = 0; i < [self.titleArray count]; i++)
    {
        NSString *titleStr = [self.titleArray objectAtIndex:i];
        CGSize size = [titleStr sizeWithFont:[UIFont systemFontOfSize:14.0]];
        NSInteger subViewWidth = size.width + 45;
        totalWidth += subViewWidth;
        
        MIBBSegmentSubview *tab = [[MIBBSegmentSubview alloc] initWithFrame:CGRectMake(i*self.viewWidth/self.segmentIndexCount, 0, subViewWidth, self.viewHeight - 1)];
        
        tab.backgroundColor = [UIColor whiteColor];
        tab.titleLabel.text = [self.titleArray objectAtIndex:i];
        tab.titleLabel.font = [UIFont systemFontOfSize:14.0];
        tab.titleLabel.textColor = [UIColor grayColor];
        
        NSNumber *type = [_segmentTypeArray objectAtIndex:i];
        tab.type = type.integerValue;
        if (type.integerValue == RoundArrowType)
        {
            //            tab = [self setRoundArrowTab:tab titleSize:size];
            tab.imageView.frame = CGRectMake(12, 15, 10, 10);
            tab.imageView.image = [UIImage imageNamed:@"img_kuang"];
            tab.titleLabel.left = 30;
        }
        else if(type.integerValue == DownArrowType)
        {
            tab.imageView.image = [UIImage imageNamed:@"img_arrow_down"];
        }
        else
        {
            tab.imageView.image = [UIImage imageNamed:@"img_arrow_up"];
        }
        
        [_segmentBtnArray addObject:tab];
        tab.tag = 10000+i;
        UITapGestureRecognizer *loginRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTab:)];
        [tab addGestureRecognizer:loginRecoginzer];
        
        [self addSubview:tab];
        if (currentTab)
        {
            tab.left = currentTab.right;
        }
        currentTab = tab;
    }
    [self layout:totalWidth];
}

- (void)layout:(NSInteger)totalWidth
{
    if (totalWidth < PHONE_SCREEN_SIZE.width)
    {
        NSInteger left = PHONE_SCREEN_SIZE.width - totalWidth;
        NSInteger tabLeft = left/self.titleArray.count;
        for (NSInteger i = 0; i < [_segmentBtnArray count]; i++)
        {
            MIBBSegmentSubview
            *tab = [_segmentBtnArray objectAtIndex:i];
            tab.viewWidth = tab.viewWidth + tabLeft;
            if (i > 0) {
                MIBBSegmentSubview *currentTab = [_segmentBtnArray objectAtIndex:i - 1];
                tab.left = currentTab.right;
            }
            [tab setLayout:tabLeft];
        }
    }
}

- (MIBBSegmentSubview *)setRoundArrowTab:(MIBBSegmentSubview *)tab titleSize:(CGSize)size
{
    tab.imageView.frame = CGRectMake(15, 16, 10, 10);
    tab.imageView.layer.borderWidth = 0.6;
    tab.imageView.layer.borderColor = [MIUtility colorWithHex:0x383838].CGColor;
    tab.imageView.layer.cornerRadius = 5;
    
    //    tab.backView = [[UIView alloc] init];
    //    tab.backView.frame = CGRectMake(16.5, 17.5, 6, 6);
    //    tab.backView.layer.borderWidth = 0.1;
    //    tab.backView.layer.borderColor = [MIUtility colorWithHex:0x383838].CGColor;
    //    tab.backView.layer.cornerRadius = 5;
    //    [tab addSubview:tab.backView];
    
    tab.titleLabel.frame = CGRectMake(tab.imageView.viewWidth + tab.imageView.frame.origin.x + 5, 0, size.width, tab.frame.size.height);
    return tab;
}

- (void)setSelectedItems:(NSArray *)itemsIndexArray
{
    [self clearAllItem];
    for (NSInteger i = 0; i < [itemsIndexArray count]; i++)
    {
        NSNumber *index = [itemsIndexArray objectAtIndex:i];
        if (_segmentBtnArray.count > index.integerValue)
        {
            MIBBSegmentSubview *tab = [_segmentBtnArray objectAtIndex:index.integerValue];
            if (tab.type == UpArrowType1 || tab.type == UpArrowType2)
            {
                tab.imageView.image = [UIImage imageNamed:@"img_arrow_up_selected"];
                tab.titleLabel.textColor = [MIUtility colorWithHex:0xff6600];
                _statusObj.inStockStatus = @(tab.tag - 10000);
            }
            else if(tab.type == DownArrowType)
            {
                tab.imageView.image = [UIImage imageNamed:@"img_arrow_down_selected"];
                tab.titleLabel.textColor = [MIUtility colorWithHex:0xff6600];
                _statusObj.inStockStatus = @(tab.tag - 10000);
            }
            else
            {
                //            tab.backView.backgroundColor = [MIUtility colorWithHex:0xff4965];
                //            tab.imageView.layer.borderColor = [MIUtility colorWithHex:0xff4965].CGColor;
                tab.imageView.image = [UIImage imageNamed:@"img_kuang_selected"];
                tab.imageView.frame = CGRectMake(12, 15, 10, 10);
                tab.titleLabel.textColor = [MIUtility colorWithHex:0xff6600];
                _statusObj.inStockStatus = @(1);
            }
            tab.status = BBSelectedStateSelected;
        }
    }
}

- (void)clearAllItem
{
    for (NSInteger i = 0; i < [_segmentBtnArray count]; i++)
    {
        MIBBSegmentSubview *bindTab = [_segmentBtnArray objectAtIndex:i];
        if (bindTab.status == BBSelectedStateSelected)
        {
            bindTab.status = BBSelectedStateNormal;
            if (bindTab.type == DownArrowType)
            {
                bindTab.imageView.image = [UIImage imageNamed:@"img_arrow_down"];
                bindTab.titleLabel.textColor = [UIColor grayColor];
            }
            else if(bindTab.type == UpArrowType1 || bindTab.type == UpArrowType2)
            {
                bindTab.imageView.image = [UIImage imageNamed:@"img_arrow_up"];
                bindTab.titleLabel.textColor = [UIColor grayColor];
            }
            else
            {
                
                //                bindTab.backView.backgroundColor =[UIColor whiteColor];
                //                bindTab.imageView.layer.borderColor = [MIUtility colorWithHex:0x383838].CGColor;
                bindTab.imageView.image = [UIImage imageNamed:@"img_kuang"];
                bindTab.titleLabel.textColor = [UIColor grayColor];
            }
        }
    }
}

- (void)clearSortItem
{
    for (NSInteger i = 0; i < [_segmentBtnArray count]; i++)
    {
        MIBBSegmentSubview *bindTab = [_segmentBtnArray objectAtIndex:i];
        if (bindTab.status == BBSelectedStateSelected)
        {
            if (bindTab.type == DownArrowType)
            {
                bindTab.imageView.image = [UIImage imageNamed:@"img_arrow_down"];
                bindTab.titleLabel.textColor = [UIColor grayColor];
                bindTab.status = BBSelectedStateNormal;
            }
            else if(bindTab.type == UpArrowType1 || bindTab.type == UpArrowType2)
            {
                bindTab.imageView.image = [UIImage imageNamed:@"img_arrow_up"];
                bindTab.titleLabel.textColor = [UIColor grayColor];
                bindTab.status = BBSelectedStateNormal;
            }
            else
            {
                bindTab.titleLabel.textColor = [UIColor grayColor];
                bindTab.imageView.image = [UIImage imageNamed:@"img_kuang"];
                bindTab.status = BBSelectedStateNormal;
            }
        }
    }
    _statusObj.inStockStatus = @(0);
}

- (void)clickTab:(UITapGestureRecognizer *)ges
{
    MIBBSegmentSubview *tab = (MIBBSegmentSubview
                               
                               *)ges.view;
    if (tab.type != RoundArrowType)
    {
        if (tab.status == BBSelectedStateSelected)
        {
            
            return;
        }
        [self clearSortItem];
        if (tab.type == UpArrowType1 || tab.type == UpArrowType2)
        {
            tab.imageView.image = [UIImage imageNamed:@"img_arrow_up_selected"];
        }
        else
        {
            tab.imageView.image = [UIImage imageNamed:@"img_arrow_down_selected"];
            
        }
        tab.titleLabel.textColor = [MIUtility colorWithHex:0xff6600];
        tab.status = BBSelectedStateSelected;
        _statusObj.inStockStatus = @(tab.tag - 10000);
    }
    else
    {
        if (tab.status == BBSelectedStateNormal)
        {
            //            tab.backView.backgroundColor = [MIUtility colorWithHex:0xff4965];
            //            tab.imageView.layer.borderColor = [MIUtility colorWithHex:0xff4965].CGColor;
            tab.imageView.image = [UIImage imageNamed:@"img_kuang_selected"];
            tab.imageView.frame = CGRectMake(12, 15, 10, 10);
            tab.titleLabel.textColor = [MIUtility colorWithHex:0xff6600];
            tab.status = BBSelectedStateSelected;
            _statusObj.filterStatus = @(1);
        }
        else
        {
            //            tab.backView.backgroundColor =[UIColor whiteColor];
            //            tab.imageView.layer.borderColor = [MIUtility colorWithHex:0x383838].CGColor;
            tab.imageView.image = [UIImage imageNamed:@"img_kuang"];
            tab.titleLabel.textColor = [UIColor grayColor];
            tab.status = BBSelectedStateNormal;
            _statusObj.filterStatus = @(0);
        }
    }
    if (_selectedBlock) {
        _selectedBlock(_statusObj);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
