//
//  UIDevice+UIDeviceExt.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import "UIDevice+UIDeviceExt.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mount.h>
#import <mach/mach.h>

@implementation UIDevice (IdentifierAddition)

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
+ (NSString *)macAddress{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (BOOL)isDeviceiPad{
    BOOL iPadDevice = NO;
    
    // Is userInterfaceIdiom available?
    if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)])
    {
        // Is device an iPad?
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            iPadDevice = YES;
    }
    
    return iPadDevice;
}

+ (NSString *) machineModel{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *machineModel = [NSString stringWithUTF8String:machine];
    free(machine);
    return machineModel;
}

+ (NSString *) machineModelName{
    NSString *machineModel = [UIDevice machineModel];
    
    // iPhone
    if ([machineModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([machineModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([machineModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([machineModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([machineModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([machineModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([machineModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";

    // iPod
    if ([machineModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([machineModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([machineModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([machineModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    
    // iPad
    if ([machineModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([machineModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([machineModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([machineModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    
    if ([machineModel isEqualToString:@"iPad3,1"])      return @"iPad-3G (WiFi)";
    if ([machineModel isEqualToString:@"iPad3,2"])      return @"iPad-3G (4G)";
    if ([machineModel isEqualToString:@"iPad3,3"])      return @"iPad-3G (4G)";
    
    // Simulator
    if ([machineModel isEqualToString:@"i386"])         return @"Simulator";
    if ([machineModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    return machineModel;
}
// 是否能发短信 不准确 清产品确认该问题
+ (BOOL) canDeviceSendMessage{
    NSString *machineModelName = [UIDevice machineModelName];
    if ([machineModelName hasPrefix:@"iPhone"]) {
        return YES;
    }
    if ([machineModelName hasPrefix:@"iPod"] || [machineModelName hasPrefix:@"Simulator"]) {
        return NO;
    }
    if ([machineModelName hasPrefix:@"iPad"]) {
        if ([machineModelName rangeOfString:@"CDMA"].location != NSNotFound ||
            [machineModelName rangeOfString:@"GSM"].location != NSNotFound ||
            [machineModelName rangeOfString:@"3G"].location != NSNotFound ||
            [machineModelName rangeOfString:@"4G"].location != NSNotFound) {
            return YES;
        }else {
            return NO;
        }
    }
    return YES;
}
// 对低端机型的判断
+ (BOOL)isLowLevelMachine{
    NSString *machineModel = [UIDevice machineModelName];
    
    NSArray *lowLevel = [NSArray arrayWithObjects:@"iPhone 1G", @"iPhone 3G", @"iPhone 3GS",
                         @"iPod Touch 1G", @"iPod Touch 2G", @"iPod Touch 3G",
                         @"iPad",
                         nil];
    
    for (NSString *lower in lowLevel) {
        if ([machineModel isEqualToString:lower]) {
            return YES;
        }
    }
    
    return NO;
}

+(NSNumber *)freeSpace{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/private/var", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }

    return [NSNumber numberWithLongLong:freespace];
}

+(NSNumber *)totalSpace{
	struct statfs buf;	
	long long totalspace = -1;
	if(statfs("/private/var", &buf) >= 0){
		totalspace = (long long)buf.f_bsize * buf.f_blocks;
	} 
	return [NSNumber numberWithLongLong:totalspace];
}

// 获取运营商信息
+ (NSString *)carrierName{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    
    if (carrier == nil) {
        return nil;
    }
    NSString *carrierName = [carrier carrierName];
    MILog(@"Carrier Name: %@ mcc: %@ mnc: %@", carrierName, [carrier mobileCountryCode], [carrier mobileNetworkCode]);
    return carrierName;
}

+ (NSString *)carrierCode{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    
    if (carrier == nil) {
        return nil;
    }
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    NSString *carrierCode = [NSString stringWithFormat:@"%@%@", mcc, mnc];
    return carrierCode;
}
+ (CGFloat) getBatteryValue{
    UIDevice* device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    return device.batteryLevel;
}
+ (NSInteger) getBatteryState{
    UIDevice* device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    return device.batteryState;
}

// 内存信息
+ (NSUInteger)freeMemory{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * pagesize;
}

+ (NSUInteger)usedMemory{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0;
}
+ (CGSize)screenSize{
    CGRect rect = [UIScreen mainScreen].bounds;
    return CGSizeMake(rect.size.width, rect.size.height - PHONE_STATUSBAR_HEIGHT);
}
+ (CGFloat)screenWidth{
    return [UIDevice screenSize].width;
}
+ (CGFloat)screenHeight{
    return [UIDevice screenSize].height;
}
+ (CGFloat)mainScreenHeight
{
    CGRect rect = [UIScreen mainScreen].bounds;
    return rect.size.height;
}
+ (BOOL)isIphone5{
    return [[[UIDevice machineModel] lowercaseString] rangeOfString:[@"iPhone5" lowercaseString]].length > 0;
}
+ (BOOL)isRetina4inch{
    return (568 == SCREEN_HEIGHT || 1136 == SCREEN_HEIGHT || 1334 == SCREEN_HEIGHT || 1920 == SCREEN_HEIGHT);
}
@end
