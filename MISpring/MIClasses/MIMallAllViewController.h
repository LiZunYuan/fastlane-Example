//
//  MIBaseViewController+MIMallAllViewController.h
//  MISpring
//
//  Created by Mac Chow on 13-3-21.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMallReloadRequest.h"
#import "MIMallGetRequest.h"
#import "MIMallGetModel.h"

@interface MIMallAllViewController : MIBaseViewController

@property(nonatomic, strong) NSString *keywords;
@property(nonatomic, strong) NSMutableArray * sections;
@property(nonatomic, strong) NSMutableDictionary * sectionsData;
@property(nonatomic, strong) MIMallReloadRequest * mallReloadAllRequest;
@property(nonatomic, strong) MIMallGetRequest *searchMallsRequest;

@end
