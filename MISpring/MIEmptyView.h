//
//  MIEmptyView.h
//  MISpring
//
//  Created by yujian on 14-12-18.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITextButton.h"

typedef enum : NSUInteger {
    FavorEmptyType = 1,
    BrandFavorEmptyType,
} MIEmptyViewType;

@interface MIEmptyView : UIView

@property (nonatomic, assign) MIEmptyViewType type;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet MITextButton *platformButton;
- (IBAction)goToPaltformAction:(id)sender;

@end
