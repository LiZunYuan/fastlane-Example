//
//  MIPayGetModel.h
//  MISpring
//
//  Created by Yujian Xu on 13-3-29.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIPayGetModel : NSObject

@property(nonatomic, strong) NSNumber * count;
@property(nonatomic, strong) NSNumber * page;
@property(nonatomic, strong) NSNumber * pageSize;
@property(nonatomic, strong) NSArray * pays;       //数据类型为MIPayModel.h
@end
