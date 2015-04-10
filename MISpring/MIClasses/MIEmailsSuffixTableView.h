//
//  MIEmailsSuffixTableView.h
//  MISpring
//
//  Created by 曲俊囡 on 14-6-9.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIChoosedEmailDelegate <NSObject>

@optional
- (void)finishChoosingEmail:(NSString *)text;

@end

@interface MIEmailsSuffixTableView : UITableView<UITableViewDataSource,UITableViewDelegate,MIChoosedEmailDelegate>

@property (nonatomic, assign) id<MIChoosedEmailDelegate> emailDelegate;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSArray *commendEamilSuffixArray;
@property (nonatomic, strong) NSMutableArray *emailSuffixArray;

@property (nonatomic, assign) BOOL emailAndPhone;       // 输入可能是email或者phone
@property (nonatomic, assign) BOOL loadLocalData;       // 加载本地保存数据

- (void)loadArrayDataWith:(NSString *)text;


@end
