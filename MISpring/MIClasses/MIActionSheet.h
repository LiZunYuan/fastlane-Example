//
//  MIActionSheet.h
//  MISpring
//
//  Created by Yujian Xu on 13-4-28.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>

typedef void (^MIActionSheetBlock)(NSInteger index);

@interface MIActionSheet : UIActionSheet<UIActionSheetDelegate>{
    NSMutableArray *_buttonActionHandler;
}

- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonBlock:(MIActionSheetBlock)block;
- (NSInteger)addButtonWithTitle:(NSString *)title withBlock:(MIActionSheetBlock)block;

@end
