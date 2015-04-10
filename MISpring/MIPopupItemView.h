//
//  MIPopupItemView.h
//  MISpring
//
//  Created by husor on 15-2-10.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PopupMenuSelected)();

@interface PopupMenuItem : NSObject
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, copy) PopupMenuSelected block;

+(PopupMenuItem *)itemWithIcon:(NSString *)icon desc:(NSString *)desc block:(PopupMenuSelected) block;
@end

@interface MIPopupItemView : UIView
{
    CGFloat _viewHeigh;
    CGFloat _top;
}
@property (nonatomic, strong) NSArray *popupMenuItems;
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic,strong)UIImageView *triangleImgView;
@property (nonatomic, assign) BOOL isShowSelf;
-(void)setImgAndDescWithArray:(NSMutableArray *)array;
-(void)showSelf;
-(void)hideSelf;

@end
