//
//  MIMainUser.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-27.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import "MIMainUser.h"
#import "MIUserGetModel.h"
#import "MITencentAuth.h"
#import "MISinaWeibo.h"

// 标示用户是否已经登录过
#define kUserLoginStatus @"kUserLoginStatus"

// mainUser持久化文件名
#define kMainUserFileName @"user"

// 公共目录名
#define kCommonDir @"common"

static MIMainUser* _instance = nil;

@interface MIMainUser (Private)

// 从持久化数据中读取mainUser
+ (MIMainUser *)readFromDisk:(NSString *)userId;

// 持久化路径
- (NSString *)persistPath:(NSNumber *)userId;

@end

@implementation MIMainUser
@synthesize userId = _userId;
@synthesize loginStatus = _loginStatus;
@synthesize loginAccount = _loginAccount;
@synthesize DESPassword = _DESPassword;
@synthesize sessionKey = _sessionKey;
@synthesize nickName = _nickName;
@synthesize headURL = _headURL;
@synthesize alipay = _alipay;
@synthesize phoneNum = _phoneNum;
@synthesize incomeSum = _incomeSum;
@synthesize expensesSum = _expensesSum;
@synthesize coin = _coin;
@synthesize grade = _grade;
@synthesize userTag = _userTag;

+ (MIMainUser *) getInstance {
	@synchronized(self) {
		if (_instance == nil) {
            // 看是否有最近的登录用户Id
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            MILoginStatus loginStatus = [defaults integerForKey:kUserLoginStatus];
            
            if (loginStatus != MILoginStatusNotLogined) {
                _instance = [MIMainUser readFromDisk];
                if (!_instance) {
                    _instance = [[MIMainUser alloc] init]; // assignment not done here
                }
            } else {
                // 从未登录过的逻辑
                _instance = [[MIMainUser alloc] init];
            }
		}
	}
    
	return _instance;
}


+ (id) allocWithZone:(NSZone*) zone {
	@synchronized(self) {
		if (_instance == nil) {
			_instance = [super allocWithZone:zone];  // assignment and return on first allocation
			return _instance;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone*) zone {
	return _instance;
}

- (id) init
{
	if (self = [super init]){
        [self clear];
    }
    
	return self;
}

- (void) clear
{
    self.userId = nil;
    self.loginAccount = nil;
    self.DESPassword = nil;
    self.sessionKey = nil;
    self.nickName = nil;
    self.headURL = nil;
    self.alipay = nil;
    self.phoneNum = nil;
    self.incomeSum = nil;
    self.expensesSum = nil;
    self.coin = nil;
    self.grade = nil;
    self.userTag = nil;
    self.loginStatus = MILoginStatusNotLogined;
}

#pragma mark - Public
- (void)persist {
    MILoginStatus loginStatus = self.loginStatus;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:loginStatus forKey:kUserLoginStatus];
    [defaults synchronize];
    
    if (loginStatus != MILoginStatusNotLogined) {
        NSString *persistPath = [MIMainUser persistPath];
        [NSKeyedArchiver archiveRootObject:self toFile:persistPath];
    }
}

- (void)saveUserInfo:(MIUserGetModel *)userInfo
{
    MIMainUser *mainUser = _instance;
    mainUser.userId = userInfo.uid;
    mainUser.loginAccount = [userInfo.userName lowercaseString];
    mainUser.nickName = userInfo.nick;
    mainUser.headURL = userInfo.avatar;
    mainUser.alipay = userInfo.alipay;
    mainUser.phoneNum = userInfo.tel;
    mainUser.incomeSum = userInfo.incomeSum;
    mainUser.expensesSum = userInfo.expensesSum;
    mainUser.coin = userInfo.coin;
    mainUser.grade = userInfo.grade;
    mainUser.userTag = userInfo.userTag;
    [self persist];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)logout {
    @synchronized(self)
    {
        MIMainUser *mainUser = _instance;
        [mainUser clear];
        NSString *persistPath = [MIMainUser persistPath];
        [NSKeyedArchiver archiveRootObject:self toFile:persistPath];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:kUserLoginStatus];
        [defaults synchronize];

        //清理所有cookies及缓存
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray* allCookies = [cookies cookies];
        for (NSHTTPCookie* cookie in allCookies) {
            [cookies deleteCookie:cookie];
        }

        [[MISinaWeibo getInstance] logOut];
        [[MITencentAuth getInstance] logOut];
    }
}

#pragma mark -
#pragma mark NSCoding methods
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.loginStatus = [decoder decodeIntegerForKey:@"loginStatus"];
        self.sessionKey = [decoder decodeObjectForKey:@"sessionKey"];
        self.loginAccount = [decoder decodeObjectForKey:@"loginAccount"];
        self.DESPassword = [decoder decodeObjectForKey:@"DESPassword"];
        self.nickName = [decoder decodeObjectForKey:@"nickName"];
        self.headURL = [decoder decodeObjectForKey:@"headURL"];
        self.alipay = [decoder decodeObjectForKey:@"alipay"];
        self.phoneNum = [decoder decodeObjectForKey:@"phoneNum"];
        self.incomeSum = [decoder decodeObjectForKey:@"incomeSum"];
        self.expensesSum = [decoder decodeObjectForKey:@"expensesSum"];
        self.coin = [decoder decodeObjectForKey:@"coin"];
        self.grade = [decoder decodeObjectForKey:@"grade"];
        self.userTag = [decoder decodeObjectForKey:@"userTag"];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeInteger:self.loginStatus forKey:@"loginStatus"];
    [encoder encodeObject:self.sessionKey forKey:@"sessionKey"];
    [encoder encodeObject:self.loginAccount forKey:@"loginAccount"];
    [encoder encodeObject:self.DESPassword forKey:@"DESPassword"];
    [encoder encodeObject:self.nickName forKey:@"nickName"];
    [encoder encodeObject:self.headURL forKey:@"headURL"];
    [encoder encodeObject:self.alipay forKey:@"alipay"];
    [encoder encodeObject:self.phoneNum forKey:@"phoneNum"];
    [encoder encodeObject:self.incomeSum forKey:@"incomeSum"];
    [encoder encodeObject:self.expensesSum forKey:@"expensesSum"];
    [encoder encodeObject:self.coin forKey:@"coin"];
    [encoder encodeObject:self.grade forKey:@"grade"];
    [encoder encodeObject:self.userTag forKey:@"userTag"];
}

// 从持久化数据中读取mainUser
+ (MIMainUser *)readFromDisk{
    NSString *userFile = [MIMainUser persistPath];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:userFile];
}

- (BOOL) checkLoginInfo
{
    //必须是保证用户ID正常的才可以购买商品获取返利
	if (self.userId && self.userId.integerValue > 0 && self.sessionKey && self.sessionKey.length > 0) {
		return YES;
	}
	
	return NO;
}

// App Document 路径
+ (NSString *)documentPath{
    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [searchPath objectAtIndex:0];
    return path;
}

// 公共文件夹路径
+ (NSString *)commonPath{
    NSString *path = [[MIMainUser documentPath] stringByAppendingPathComponent:kCommonDir];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:path]) {
        NSError *error = nil;
        [fileMgr createDirectoryAtPath:path
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
        if (error) {
            MILog(@"创建 commonPath 失败 %@", error);
        }
    }
    
    return path;
}

// 持久化路径
+ (NSString *)persistPath{
    //这里还搞不清楚为啥路径中要包含数字才可以持续持久化，否则不会存档
    NSString *dirPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"123456"];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:dirPath]) {
        NSError *error = nil;
        [fileMgr createDirectoryAtPath:dirPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
        if (error) {
            MILog(@"创建 userDocumentPath 失败 %@", error);
        }
    }

    NSString *path = [dirPath stringByAppendingPathComponent:kMainUserFileName];
    return path;
}


@end
