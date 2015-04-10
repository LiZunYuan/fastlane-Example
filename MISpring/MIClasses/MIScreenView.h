//
//  MIScreenView.h
//  MISpring
//
//  Created by 曲俊囡 on 14-5-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIScreenSelectedDelegate.h"
#import "MIScreenbutton.h"

typedef enum : NSInteger{
    MINormalType,
    MIZhiCatType,
}ScreenViewType;

@interface MIScreenView : UIView<MIScreenSelectedDelegate>

@property (nonatomic, assign) id<MIScreenSelectedDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) ScreenViewType type;

- (id)initWithArray:(NSArray *)cats;
- (void)reloadContenWithCats:(NSArray *)cats;

- (void)synButtonSelectWithIndex:(NSInteger)index;

@end
