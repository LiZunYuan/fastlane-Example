//
//  MIMallInfoModel.h
//  MISpring
//
//  Created by Mac Chow on 13-4-8.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIMallInfoModel : NSObject

@property(nonatomic, strong) NSString * name;
@property(nonatomic, strong) NSString * logo;
@property(nonatomic, strong) NSString * desc;             //商城信息简介
@property(nonatomic, strong) NSString * commissionNote;   //返利注意事项
@property(nonatomic, strong) NSString * commissionDesc;   //返利详情
@property(nonatomic, strong) NSString * visited;          //总共有多少人去商城购物
@property(nonatomic, strong) NSNumber * type;             //商城返利比例
@property(nonatomic, strong) NSNumber * commission;       //商城返利比例
@property(nonatomic, strong) NSNumber * mobileCommission; //移动商城返利比例
@property(nonatomic, strong) NSNumber * commissionMode;   //商城返利类型，1为米币，0为现金
@property(nonatomic, strong) NSNumber * commissionType;   //商城返利现金的子类型，1表示单位为分，0表示为返利比例
@property(nonatomic, strong) NSString * domain;


@end