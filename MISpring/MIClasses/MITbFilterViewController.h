//
//  MITbFilterViewController.h
//  MISpring
//
//  Created by 贺晨超 on 13-9-22.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

@protocol MITaobaoFilterViewControllerDelegate <NSObject>
- (void)searchFilterUIViewDidCancel: (NSMutableArray *)filterInfo;
@end

@interface MITbFilterViewController : MIBaseViewController<UITextFieldDelegate>

@property(nonatomic, strong) NSString * isTmall;
@property(nonatomic, strong) NSString * minPrice;
@property(nonatomic, strong) NSString * maxPrice;
@property(nonatomic, strong) UISwitch * isTmallSwitch;
@property(nonatomic, strong) UITextField * minPriceTextField;
@property(nonatomic, strong) UITextField * maxPriceTextField;

@property (nonatomic, weak) id<MITaobaoFilterViewControllerDelegate> delegate;

@end
