//
//  JDYSharedService.h
//  TOPIOSSdk
//
//  Created by emerson_li on 13-4-3.
//  Copyright (c) 2013年 tmall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDYSharedService : NSObject

//如果用户登陆，返回NSDictionary,如果用户未登陆，或者JDY版本过低无法响应该接口，返回nil
+(id) getJDYLoginUser;

@end
