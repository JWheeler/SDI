//
//  Utils.m
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 9..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "Utils.h"


@implementation Utils

// 아이폰 IP.
+ (NSString *)getIPAdress {
	InitAddresses();
	GetIPAddresses();
	GetHWAddresses();
	
	return [NSString stringWithFormat:@"%s", ip_names[1]];
}


// 아이폰 Mac.
+ (NSString *)getMacAddress {
	InitAddresses();
	GetIPAddresses();
	GetHWAddresses();
	
	NSString *mac = [NSString stringWithFormat:@"%s", hw_addrs[1]];
	
	// ":" 제거.
	return [mac stringByReplacingOccurrencesOfString:@":" withString:@""];
}

@end
