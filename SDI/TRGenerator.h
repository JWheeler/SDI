//
//  TRGenerator.h
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 7..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "CommHeader.h"
#import "DataHeader.h"
#import "SBHeader.h"
#import "SBBody.h"
#import "SBRegBodyHeader.h"
#import "SBRegBody.h"


@interface TRGenerator : NSObject 
{
	
}

- (NSMutableArray *)getProperties:(NSString *)className;
- (NSString *)addWhiteSpaceCharterSetWithCount:(int)count;
- (NSString *)addStringZeroWithCount:(int)count;
- (NSString *)addStringNullWithCount:(int)count;
- (NSString *)reverseString:(NSString *)string;
- (NSString *)formatStringforNumber:(int)dataLength withCipher:(int)cipher;
- (NSString *)getVersion;
- (NSString *)appendPreHeader:(NSString *)json;

- (NSMutableDictionary *)genTR:(id)obj withClassName:(NSString *)className;
- (NSString *)genITPacket:(NSString *)function;
- (NSString *)genCommHeader:(CommHeader *)commHeader;
//- (NSString *)genSB:(NSString *)type andTRCode:(NSString *)trCode withStockCode:(NSMutableArray *)sbBodies;
- (NSString *)genInitOrFinishSB:(NSString *)trCode andCMD:(NSString *)cmd;
- (NSString *)genRegisterOrClearSB:(NSString *)cmd andTRCode:(NSString *)trCode withCodeSet:(NSMutableArray *)sbBodies;

@end
