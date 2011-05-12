//
//  Utils.m
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 9..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "LPUtils.h"


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

@end
