//
//  MIActionSheet.m
//  MISpring
//
//  Created by Yujian Xu on 13-4-28.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIActionSheet.h"

@implementation MIActionSheet

- (id)initWithTitle:(NSString *)title{
    if (self = [super initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]) {
        _buttonActionHandler = [[NSMutableArray alloc] init];
        self.delegate = self;
    }
    return self;
}
- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonBlock:(MIActionSheetBlock)block{
    if(self = [super initWithTitle:title delegate:nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:nil]){
        _buttonActionHandler = [[NSMutableArray alloc] init];
        self.delegate = self;
//        [_buttonActionHandler insertObject:(__bridge id)Block_copy((__bridge void *)block) atIndex:self.cancelButtonIndex];
//        [_buttonActionHandler insertObject:[block copy] atIndex:self.cancelButtonIndex];
        [_buttonActionHandler insertObject:block atIndex:self.cancelButtonIndex];
    }
    return self;
}
- (NSInteger)addButtonWithTitle:(NSString *)title withBlock:(MIActionSheetBlock)block{
    NSInteger index = [self addButtonWithTitle:title];
//    [_buttonActionHandler insertObject:(__bridge id)Block_copy((__bridge void *)block) atIndex:index];
    [_buttonActionHandler insertObject:block atIndex:index];
    return index;
}
- (void)dealloc{
    _buttonActionHandler = nil;
}

#pragma UIActionSheetDelegate
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_buttonActionHandler.count > buttonIndex) {
        MIActionSheetBlock block = [_buttonActionHandler objectAtIndex:buttonIndex];
        if (block) {
            block(buttonIndex);
        }
    }
}

@end
