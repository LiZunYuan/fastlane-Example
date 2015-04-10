//
//  NSData+CocoaDevUsersAdditions.h
//  MISpring
//
//  Created by XU YUJIAN on 13-1-17.
//  Copyright (c) 2013年 Husor Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (NSDataExtension)

// Returns range [start, null byte), or (NSNotFound, 0).
- (NSRange) rangeOfNullTerminatedBytesFrom:(int)start;

// Canonical Base32 encoding/decoding.
+ (NSData *) dataWithBase32String:(NSString *)base32;
- (NSString *) base32String;

// COBS is an encoding that eliminates 0x00.
- (NSData *) encodeCOBS;
- (NSData *) decodeCOBS;

// ZLIB
- (NSData *) zlibInflate;
- (NSData *) zlibDeflate;

// GZIP
- (NSData *) gzipInflate;
- (NSData *) gzipDeflate;

//CRC32
- (unsigned int)crc32;
/*
 // Hash
 - (NSData*) md5Digest;
 - (NSString*) md5DigestString;
 - (NSData*) sha1Digest;
 - (NSString*) sha1DigestString;
 - (NSData*) ripemd160Digest;
 - (NSString*) ripemd160DigestString;
 */

- (NSData *)AES128EncryptWithKey:(NSString *)key;
- (NSData *)AES128DecryptWithKey:(NSString *)key;
//@end

//@interface NSData(NSDataEx)

//- (NSData*) des3:(NSString*)key encrypt:(BOOL)isEncrypt;

// 转为base64编码
- (NSString*) base64Encode;
// 转为javaScript函数
- (NSString *) javaScriptStringEncodeWithCallback:(NSString *)callback;

@end
