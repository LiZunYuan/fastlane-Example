//
//  MITbkItemDetailGetModel.h
//  MISpring
//
//  Created by 徐 裕健 on 13-12-10.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MITbkItemModel.h"

@interface MITbkItemDetailGetModel : NSObject
@property (nonatomic, strong) NSNumber *success;
@property (nonatomic, strong) MITbkItemModel *tbkItemDetail;

@end
