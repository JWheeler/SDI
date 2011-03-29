//
//  NSData+ NSDataStrings.m
//  SocketClient
//
//  Created by Jong Pil Park on 10. 6. 16..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSData+NSDataStrings.h"


@implementation NSData (NSDataStrings)

- (NSString *)stringWithHexBytes {
	static const char hexdigits[] = "0123456789ABCDEF";
	const size_t numBytes = [self length];
	const unsigned char* bytes = [self bytes];
	char *strbuf = (char *)malloc(numBytes * 2 + 1);
	char *hex = strbuf;
	NSString *hexBytes = nil;
	
	for (int i = 0; i<numBytes; ++i) {
		const unsigned char c = *bytes++;
		*hex++ = hexdigits[(c >> 4) & 0xF];
		*hex++ = hexdigits[(c ) & 0xF];
	}
	*hex = 0;
	hexBytes = [NSString stringWithUTF8String:strbuf];
	free(strbuf);
	return hexBytes;
}

@end
