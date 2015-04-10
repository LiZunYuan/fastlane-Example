//
//  MIEmailsSuffixTableView.m
//  MISpring
//
//  Created by 曲俊囡 on 14-6-9.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIEmailsSuffixTableView.h"

@implementation MIEmailsSuffixTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        _commendEamilSuffixArray = [[NSArray alloc] initWithObjects:@"@qq.com",@"@163.com",@"@126.com",@"@sina.com",@"@hotmail.com",@"@yahoo.com.cn",@"@yahoo.cn",@"@sohu.com",@"@gmail.com",@"@139.com", nil];
        _emailSuffixArray = [[NSMutableArray alloc] initWithCapacity:2];
        self.delegate = self;
        self.dataSource = self;
        self.layer.shadowRadius = 4;
        self.layer.shadowColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0, 1);
        
        self.loadLocalData = NO;
        self.emailAndPhone = NO;
    }
    return self;
}

- (void)loadArrayDataWith:(NSString *)text
{
    [self.emailSuffixArray removeAllObjects];
    if (text.trim.length > 0) {
        if (self.loadLocalData)
        {
            [self loadLocalAccountData:text];
        }
        
        if ([text rangeOfString:@"@"].location != NSNotFound)
        {
            NSString *currentSuffix = [text substringFromIndex:[text rangeOfString:@"@"].location];
            for (NSString *comSuffix in self.commendEamilSuffixArray)
            {
                if ([comSuffix rangeOfString:currentSuffix].location != NSNotFound && ![comSuffix isEqualToString:currentSuffix])
                {
                    NSString *optionalString = [[text substringToIndex:[text rangeOfString:@"@"].location] stringByAppendingString:comSuffix];
                    if (self.emailSuffixArray.count == 0)
                    {
                        [self.emailSuffixArray addObject:optionalString];
                    }
                    else
                    {
                        BOOL canAdd = YES;
                        for (int i = 0; i < self.emailSuffixArray.count; i++)
                        {
                            NSString *currentEmail = [self.emailSuffixArray objectAtIndex:i];
                            if ([currentEmail isEqualToString:optionalString])
                            {
                                canAdd = NO;
                            }
                        }
                        if (canAdd) {
                            [self.emailSuffixArray addObject:optionalString];
                        }
                    }
                }
            }
        }
        else
        {
            if (self.emailAndPhone == NO) {
                for (NSString *comSuffix in self.commendEamilSuffixArray)
                {
                    NSString *optionalString = [text stringByAppendingString:comSuffix];
                    [self.emailSuffixArray addObject:optionalString];
                }
            }
        }

    }
    
//    self.viewHeight = self.emailSuffixArray.count * 44;
    if (self.emailSuffixArray.count)
    {
        self.alpha = 1;
    }
    else
    {
        self.alpha = 0;
    }
    [self reloadData];
}


#pragma mark - Table view delegate
/**
 * The cell has to be deselected otherwise iOS will re-select the cell after re-using it and thus the text field in the last re-used cell will become first responder
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.emailSuffixArray.count > indexPath.row) {
        if ([_emailDelegate respondsToSelector:@selector(finishChoosingEmail:)])
        {
            [_emailDelegate finishChoosingEmail:[self.emailSuffixArray objectAtIndex:indexPath.row]];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.emailSuffixArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellReuseIdentifier"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TableViewCellReuseIdentifier"];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    if (self.emailSuffixArray.count > indexPath.row) {
        cell.textLabel.text = [self.emailSuffixArray objectAtIndex:indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)loadLocalAccountData:(NSString *)text
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginSuccessUsers"])
    {
        NSMutableArray *loginSuccessArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginSuccessUsers"];
        for (int i = 0; i < loginSuccessArray.count; i++)
        {
            NSString *loginAccountText = [loginSuccessArray objectAtIndex:i];
            if ([loginAccountText rangeOfString:text].location != NSNotFound)
            {
                [self.emailSuffixArray addObject:loginAccountText];
            }
        }
    }
}

@end
