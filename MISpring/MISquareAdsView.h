//
//  MISquareAdsView.h
//  MISpring
//
//  Created by yujian on 14-12-15.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MISquareAdsView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *squareLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *squareRightTopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *squareRightBottomImageView;

- (void)loadData:(NSArray *)dataArray;

@end
