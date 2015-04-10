//
//  MIUncaughtExceptionHandler.m
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIUncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

void HandleException(NSException *exception);
void SignalHandler(int signal);

NSString * const MIUncaughtExceptionHandlerSignalExceptionName = @"MIUncaughtExceptionHandlerSignalExceptionName";
NSString * const MIUncaughtExceptionHandlerSignalKey = @"MIUncaughtExceptionHandlerSignalKey";
NSString * const MIUncaughtExceptionHandlerAddressesKey = @"MIUncaughtExceptionHandlerAddressesKey";

volatile int32_t MIUncaughtExceptionCount = 0;
const int32_t MIUncaughtExceptionMaximum = 10;

const NSInteger MIUncaughtExceptionHandlerSkipAddressCount = 0;
const NSInteger MIUncaughtExceptionHandlerReportAddressCount = 10;

@implementation MIUncaughtExceptionHandler

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    //Notice that we skip the first few addresses: this is because they will be the addresses of the signal or exception handling functions (not very interesting). Since we want to keep the data minimal (for display in a UIAlert dialog) I choose not to display the exception handling functions.
    for (
         i = MIUncaughtExceptionHandlerSkipAddressCount;
         i < MIUncaughtExceptionHandlerSkipAddressCount + MIUncaughtExceptionHandlerReportAddressCount;
         i++) {
	 	[backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

+ (void)InstallUncaughtExceptionHandler
{
    // After install handler, Responding to the exceptions and signals can then happen in the implementation of the HandleException and SignalHandler
    // install a handler for uncaught Objective-C exceptions
	NSSetUncaughtExceptionHandler(&HandleException);
    
    // install handlers for BSD signals
	signal(SIGABRT, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGPIPE, SignalHandler);
}

@end

void HandleException(NSException *exception)
{
    MILog(@"CRASH: %@", exception);
    MILog(@"Description: %@", [exception name]);
    MILog(@"Description: %@", [exception description]);
    MILog(@"Stack Trace: %@", [exception callStackSymbols]);

    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate date];
    NSString *dateStr = [[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:date]];

    // 崩溃日志中添加exception name (zzl-2012-8-10)
    NSString *crashLog = [NSString stringWithFormat:@"%@\n%@%@",dateStr,[exception name], [exception callStackSymbols]];
    NSString *path = [NSString stringWithFormat:@"%@/%@",[MIMainUser documentPath], kCrashLogPath];
    NSError *error;
    if (![crashLog writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
        MILog(@"write to file error:%@",error);
    }
    
    NSSetUncaughtExceptionHandler(NULL);
	signal(SIGABRT, SIG_DFL);
	signal(SIGILL, SIG_DFL);
	signal(SIGSEGV, SIG_DFL);
	signal(SIGFPE, SIG_DFL);
	signal(SIGBUS, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
	
	if ([[exception name] isEqual:MIUncaughtExceptionHandlerSignalExceptionName])
	{
		kill(getpid(), [[[exception userInfo] objectForKey:MIUncaughtExceptionHandlerSignalKey] intValue]);
	}
	else
	{
        // re-raise the exception or resend the signal, to make the application to crash as norma
		[exception raise];
	}
    
}

void SignalHandler(int signal)
{	
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:MIUncaughtExceptionHandlerSignalKey];
    
	NSArray *callStack = [MIUncaughtExceptionHandler backtrace];
	[userInfo setObject:callStack forKey:MIUncaughtExceptionHandlerAddressesKey];
    
    
    NSException* exception = [NSException exceptionWithName:MIUncaughtExceptionHandlerSignalExceptionName
                                                     reason:[NSString stringWithFormat: NSLocalizedString(@"Signal %d was raised.", nil), signal]
                                                   userInfo:userInfo];
	HandleException(exception);
}


