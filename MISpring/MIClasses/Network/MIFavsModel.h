//
//  MIFavsModel.h
//  MiZheHD
//
//  Created by 徐 裕健 on 13-8-3.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIFavsModel : NSObject<NSCoding>
@property(nonatomic, strong) NSString * iid;             //商城或店铺的id
@property(nonatomic, strong) NSString * name;            //商城或店铺的名称
@property(nonatomic, strong) NSString * domain;          //商城的域名
@property(nonatomic, strong) NSString * deletable;       //是否能删除
@property(nonatomic, strong) NSString * commission;      //返利比例
@property(nonatomic, strong) NSString * commissionMode;  //返利类型，1为米币，0为现金
@property(nonatomic, strong) NSString * commissionType;  //返利子类型，当mode==0的时候，2表示最高返利多少元，1表示按比例返利
@property(nonatomic, strong) NSString * type;            //商城或者店铺，0表示店铺，1表示商城，2表示淘宝
@property(nonatomic, strong) NSNumber * mallType;        //1表示支持移动商城返利，2表示不支持移动商城返利
@property(nonatomic, strong) NSString * logo;            //商城或者店铺的Logo
@end
