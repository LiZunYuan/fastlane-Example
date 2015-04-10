//
//  MIMallGetModel.h
//  MISpring
//
//  Created by lsave on 13-3-16.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIMallModel.h"

@interface MIMallGetModel : NSObject

@property(nonatomic, retain) NSNumber * count;
@property(nonatomic, retain) NSNumber * page;
@property(nonatomic, retain) NSNumber * pageSize;
@property(nonatomic, retain) NSArray * malls; ///数据类型为MIMallModel

@end
