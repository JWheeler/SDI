//
//  Utils.m
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 9..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "LPUtils.h"
#import "IPAddress.h"


@implementation LPUtils

// 숫자 포맷팅(콤마).
+ (NSString *)formatNumber:(int)num 
{
	NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];  
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	NSString *formattedOutput = [formatter stringFromNumber:[NSNumber numberWithInt:num]];
	//Debug(@"Formatting number: %@", formattedOutput);
	
	return formattedOutput;
}

// 아이폰 IP.
+ (NSString *)getIPAdress 
{
	InitAddresses();
	GetIPAddresses();
	GetHWAddresses();
	
	return [NSString stringWithFormat:@"%s", ip_names[1]];
}

// 아이폰 Mac.
+ (NSString *)getMacAddress 
{
	InitAddresses();
	GetIPAddresses();
	GetHWAddresses();
	
	NSString *mac = [NSString stringWithFormat:@"%s", hw_addrs[1]];
	
	// ":" 제거.
	return [mac stringByReplacingOccurrencesOfString:@":" withString:@""];
}

// 얼럿뷰.
+ (void)showAlert:(int)type andTag:(int)tag withTitle:(NSString *)title andMessage:(NSString *)message
{
	// 확인 버튼만 있는 경우.
	if (type == LPAlertTypeFirst) {
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:title
							  message:message 
							  delegate:self 
							  cancelButtonTitle:@"확인" 
							  otherButtonTitles:nil, nil];
        alert.tag = tag;
		[alert show];
		[alert release];
	}
	
	// 확인/취소 버튼 모두 있는 경우.
	if (type == LPAlertTypeSecond) {
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:title 
							  message:message
							  delegate:self 
							  cancelButtonTitle:@"취소" 
							  otherButtonTitles:@"확인", nil];
        alert.tag = tag;
		[alert show];
		[alert release];
	}
}

// 문자열 뒤집기.
+ (NSString *)reverseString:(NSString *)string 
{
	NSMutableString *reversedString;
	int len = [string length];
	reversedString = [NSMutableString stringWithCapacity:len];     
	
	while (len > 0)
		[reversedString appendString:[NSString stringWithFormat:@"%C", [string characterAtIndex:--len]]];   
	
	return reversedString;
}

// 데이터 길이를 문자열로 포맷팅.
+ (NSString *)formatStringNumber:(NSString *)string withCipher:(int)cipher 
{
	int stringLength = [string length];
	NSString *reverseString = [self reverseString:string];
	
	for (int i = 0; i < (cipher - stringLength); i++) 
    {
		reverseString = [reverseString stringByAppendingString:@"0"];
	}
	
	return [self reverseString:reverseString];
}

// 해당 문자열이 포함되어 있는지 비교.
+ (BOOL)matchString:(NSString *)theString withString:(NSString*)withString 
{
	NSRange range = [theString rangeOfString:withString];
	int length = range.length;
	
	if (length == 0) 
    {
		return NO;
	}
	
	return YES;
}

/**
 -----------------------------------------------------------------
 NSString > char*
 -----------------------------------------------------------------
 NSString *nsString = @"My NSString" ;
 const char *cString = [nsString cStringUsingEncoding:ASCIIEncoding];
 
 // 또는
 const char *cString = [nsString UTF8String];
 
 -----------------------------------------------------------------
 char* > NSString
 -----------------------------------------------------------------
 const char *cString = "HELLO!!" ;
 NSString *nsString = [NSString stringWithUTF8String:cString];
 
 // 또는
 NSString *nsString = [[NSString alloc] initWithUTF8String:cString]
 */

// NSString을 Hexa string로 변환.
+ (NSString *)stringToHex:(NSString *)string 
{	
	const char *utf8 = [string UTF8String];
    NSMutableString *hex = [NSMutableString string];
    while (*utf8) [hex appendFormat:@"%02X", *utf8++ & 0x00FF];
	
    return [NSString stringWithFormat:@"%@", hex];
}

// 0으로 시작하는 문자열을 숫자(float)로 변환(예: 00500 -> 500).
+ (float)convertStringToNumber:(NSString *)string
{
    int index = 0;
    for (int i = 0; i < [string length]; i++) 
    {
        
        if (![[NSString stringWithFormat:@"%C", [string characterAtIndex:i]] isEqualToString:@"0"]) 
        {
            index = i;
            break;
        }
        else
        {
            index = [string length];
        }
    }
    
    NSString *chunk = [[[NSString alloc] init] autorelease];
	chunk = [string substringFromIndex:index];
    
    return [chunk floatValue];
}

@end
