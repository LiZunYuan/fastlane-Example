//
//  MITbkItemModel.h
//  MISpring
//
//  Created by lsave on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MITbkItemModel : NSObject

@property(nonatomic, retain) NSString * numIid;
@property(nonatomic, retain) NSString * title;
@property(nonatomic, retain) NSString * picUrl;
@property(nonatomic, retain) NSString * nick;
@property(nonatomic, retain) NSString * price;
@property(nonatomic, retain) NSString * promotionPrice;
@property(nonatomic, retain) NSString * commissionDesc;
@property(nonatomic, retain) NSNumber * volume;
@property(nonatomic, retain) NSString * clickUrl;
@property(nonatomic, retain) NSString * shopUrl;
@property(nonatomic, retain) NSString * itemUrl;

@end
