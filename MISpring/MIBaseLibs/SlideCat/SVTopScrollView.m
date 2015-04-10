//
//  SVTopScrollView.m
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "SVTopScrollView.h"


//按钮空隙
#define BUTTONGAP 20
//滑条宽度
#define CONTENTSIZEX (SCREEN_WIDTH - 38)
//按钮id
#define BUTTONID (label.tag-100)
//滑动id
#define BUTTONSELECTEDID (scrollViewSelectedChannelID - 100)

@implementation SVTopScrollView

@synthesize catArray;
@synthesize scrollViewSelectedChannelID;

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, CONTENTSIZEX, 38)];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        userSelectedChannelID = 100;
        scrollViewSelectedChannelID = 100;

        
        self.buttonOriginXArray = [NSMutableArray array];
        self.buttonWithArray = [NSMutableArray array];
    }
    return self;
}

- (void)initWithNameButtons
{
    [self removeAllSubviews];
    [_buttonOriginXArray removeAllObjects];
    [_buttonWithArray removeAllObjects];
    float xPos = 5;
    for (NSInteger i = 0; i < [self.catArray count]; i++) {
        NSString *title = [self.catArray objectAtIndex:i];
        UILabel *label = [[UILabel alloc] init];
        label.userInteractionEnabled = YES;
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14.0];
        label.text = title;
        label.tag = i+100;
        if (i == 0) {
            label.textColor = [MIUtility colorWithHex:0xff5500];
            scrollViewSelectedChannelID = label.tag;
        } else {
            label.textColor = [MIUtility colorWithHex:0xa0a0a0];
        }
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectNameButton:)];
        [label addGestureRecognizer:tapGestureRecognizer];
        
        NSInteger buttonWidth = [label.text sizeWithFont:label.font
                            constrainedToSize:CGSizeMake(150, 30)
                                lineBreakMode:NSLineBreakByClipping].width;
        
        label.frame = CGRectMake(xPos, 4, buttonWidth+BUTTONGAP, 30);
        
        [_buttonOriginXArray addObject:@(xPos)];
        
        xPos += buttonWidth+BUTTONGAP;
        
        [_buttonWithArray addObject:@(label.frame.size.width)];
        
        [self addSubview:label];
    }
    
    self.contentSize = CGSizeMake(xPos, 38);
    
    if (_buttonWithArray.count > 0) {
        shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, [[_buttonWithArray objectAtIndex:0] floatValue], 38)];
        [shadowImageView setImage:[UIImage imageNamed:@"bg_catbar_item"]];
        [self addSubview:shadowImageView];
    }
}

//点击顶部条滚动标签
- (void)selectNameButton:(UITapGestureRecognizer *)sender
{
    UILabel *label = (UILabel *)sender.view;

    [self scrollRectToVisible:label.frame animated:YES];
    
    //如果更换按钮
    if (label.tag != userSelectedChannelID) {
        //取之前的按钮
        UILabel *lastLabel = (UILabel *)[self viewWithTag:userSelectedChannelID];
        lastLabel.textColor = [MIUtility colorWithHex:0xa0a0a0];
        
        //赋值按钮ID
        userSelectedChannelID = label.tag;
        label.textColor = [MIUtility colorWithHex:0xff5500];
        [UIView animateWithDuration:0.25 animations:^{
            if (_buttonWithArray.count > BUTTONID) {
                [shadowImageView setFrame:CGRectMake(label.frame.origin.x, 0, [[_buttonWithArray objectAtIndex:BUTTONID] floatValue], 38)];
            }
        } completion:^(BOOL finished) {
            if (finished) {
//                MISVTopObject *model = (MISVTopObject *)[self.catArray objectAtIndex:BUTTONID];
//                [MobClick event:kTemaiCatClicks label:model.catName];
                if ([_screenDelegate respondsToSelector:@selector(selectedIndex)]) {
                   // [_screenDelegate selectedCatId:model.catId catName:model.catName];
                    [_screenDelegate selectedIndex:BUTTONID];
                }
                //赋值滑动列表选择频道ID
                scrollViewSelectedChannelID = label.tag;

            }
        }];
    }
}
//滚动内容页顶部滚动
- (void)setButtonUnSelect
{
    //滑动撤销选中按钮
    UILabel *lastLabel = (UILabel *)[self viewWithTag:scrollViewSelectedChannelID];
    lastLabel.textColor = [MIUtility colorWithHex:0xa0a0a0];
}

- (void)setButtonSelect
{
    //滑动选中按钮
    
    
    UILabel *lastLabel = (UILabel *)[self viewWithTag:scrollViewSelectedChannelID];
    
    [UIView animateWithDuration:0.25 animations:^{
        if (_buttonWithArray.count > lastLabel.tag-100) {
            [shadowImageView setFrame:CGRectMake(lastLabel.frame.origin.x, 0, [[_buttonWithArray objectAtIndex:lastLabel.tag-100] floatValue], 38)];
        }
    } completion:^(BOOL finished) {
        if (finished) {
            if (lastLabel.tag != userSelectedChannelID) {
                lastLabel.textColor = [MIUtility colorWithHex:0xff5500];
                userSelectedChannelID = lastLabel.tag;
            }
        }
    }];
    [self scrollRectToVisible:lastLabel.frame animated:YES];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
