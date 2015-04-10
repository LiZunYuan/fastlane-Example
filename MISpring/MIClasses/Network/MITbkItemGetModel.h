//
//  MITbkItemGetModel.h
//  MISpring
//
//  Created by lsave on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MITbkItemGetModel : NSObject

@property(nonatomic, retain) NSNumber * count;
@property(nonatomic, retain) NSNumber * page;
@property(nonatomic, retain) NSNumber * pageSize;
@property(nonatomic, retain) NSArray * tbkItems;

@end
