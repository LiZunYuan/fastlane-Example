//
//  MITbItemSortsView.h
//  MISpring
//
//  Created by 贺晨超 on 13-9-16.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MITbItemSortsViewDelegate <NSObject>
- (void)didSelectTbItemSortsKey:(NSString *)sortsKey;
@end

@interface MITbItemSortsView : UIView
{
    NSString *_sortKey;
    int _currentTag;
}

@property (nonatomic, weak)   id<MITbItemSortsViewDelegate> delegate;
@property (strong, nonatomic) UIButton *defaultButton;
@property (strong, nonatomic) UIButton *volumeButton;
@property (strong, nonatomic) UIButton *priceButton;
@property (strong, nonatomic) UIButton *creditButton;
@property (strong, nonatomic) NSString *priceSort;
@property (strong, nonatomic) NSString *rebateSort;

- (id)initWithFrame:(CGRect)frame;

@end
