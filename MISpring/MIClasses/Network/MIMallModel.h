//
//  MIMallModel.h
//  MISpring
//
//  Created by lsave on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIMallModel : NSObject<NSCoding>

@property(nonatomic, strong) NSString * mallId;
@property(nonatomic, strong) NSString * name;
@property(nonatomic, strong) NSString * seoName;
@property(nonatomic, strong) NSString * pinyin;
@property(nonatomic, strong) NSNumber * mode;            //返利类型，1为米币，0为现金
@property(nonatomic, strong) NSString * summary;
@property(nonatomic, strong) NSString * cate;
@property(nonatomic, strong) NSString * commission;      //返利比例
@property(nonatomic, strong) NSString * mobileCommission;
@property(nonatomic, strong) NSString * commissionType;  //返利子类型，当mode==0是，2表示最高返利多少元，0表示按比例返利
@property(nonatomic, strong) NSNumber * type;
@property(nonatomic, strong) NSNumber * pos;
@property(nonatomic, strong) NSString * logo;
@property(nonatomic, strong) NSNumber * gmtModified;

@end
