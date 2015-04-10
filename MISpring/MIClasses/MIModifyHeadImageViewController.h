//
//  MIModifyHeadImageViewController.h
//  MISpring
//
//  Created by 曲俊囡 on 13-12-12.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"

@interface MIModifyHeadImageViewController : MIBaseViewController

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) UIImageView *rooImageView;
@property (nonatomic, retain) UIImage *croppedImage;

- (id)initWithImage:(UIImage *)aImage;

@end
