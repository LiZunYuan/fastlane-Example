//
//  MITbkItemPicsCell.h
//  MISpring
//
//  Created by 徐 裕健 on 13-9-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MITbkItemPicsCell : UITableViewCell<UIScrollViewDelegate>

@property(nonatomic, strong) NSArray *itemImgs;
@property(nonatomic, strong) UILabel *itemTitle;
@property(nonatomic, strong) UIScrollView *picScrollView;

@property(nonatomic, strong) UIImageView *popupImageView;
@property(nonatomic, strong) UIView *popupImageViewContainer;

@end
