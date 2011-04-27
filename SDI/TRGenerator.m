//
//  TRGenerator.m
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 7..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "TRGenerator.h"
#import "NSObject+JSON.h"
//#import "DHConstants.h"
//#import "DataHandler.h"


@implementation TRGenerator

#pragma mark -
#pragma mark TR(전문) 조립을 위한 유틸리티 메서드.

// 클래스의 디클레어드 프라퍼티 목록.
- (NSMutableArray *)getProperties:(NSString *)className 
{
	unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([NSClassFromString(className) class], &outCount);
	NSMutableArray *propertyArray = [[[NSMutableArray alloc] init] autorelease];
	
	while (outCount--) 
    {
		objc_property_t property = properties[outCount];
		[propertyArray addObject:[[NSString alloc] initWithFormat:@"%s", property_getName(property)]];
		
		// 디버그용.
		//fprintf(stdout, "%s %s\n", property_getName(property), property_getAttributes(property));
		//LPLog(@"%s %s\n", property_getName(property), property_getAttributes(property));
    }
	free(properties);
	
	return propertyArray;
}


// 공백 추가.
- (NSString *)addWhiteSpaceCharterSetWithCount:(int)count 
{
	NSString *whiteSpace = [[[NSString alloc] init] autorelease];
	
	for (int i = 0; i < count; ++i) {
		whiteSpace = [whiteSpace stringByAppendingString:@" "];
	}
	
	return whiteSpace;
}


// 문자 "0" 추가.
- (NSString *)addStringZeroWithCount:(int)count 
{
	NSString *stringZero = [[[NSString alloc] init] autorelease];
	
	for (int i = 0; i < count; ++i) 
    {
		stringZero = [stringZero stringByAppendingString:@"0"];
	}
	
	return stringZero;	
}


// 널 처리용 문자.
- (NSString *)addStringNullWithCount:(int)count 
{
	NSString *stringNull = [[[NSString alloc] init] autorelease];
	
	for (int i = 0; i < count; ++i) 
    {
		stringNull = [stringNull stringByAppendingString:@"."];
	}
	
	return stringNull;	
}


// 문자열 뒤집기.
- (NSString *)reverseString:(NSString *)string 
{
	NSMutableString *reversedString;
	int len = [string length];
	reversedString = [NSMutableString stringWithCapacity:len];     
	
	while (len > 0)
		[reversedString appendString:[NSString stringWithFormat:@"%C", [string characterAtIndex:--len]]];   
	
	return reversedString;
}


// 데이터 길이를 문자열로 포맷팅.
- (NSString *)formatStringforNumber:(int)dataLength withCipher:(int)cipher 
{
	
	NSString *stringDataLength = [[[NSString alloc] initWithFormat:@"%d", dataLength] autorelease];
	stringDataLength = [self reverseString:stringDataLength];
	
	for (int i = 0; i == (cipher - [stringDataLength length]); i++) 
    {
		stringDataLength = [stringDataLength stringByAppendingString:@"0"];
	}
	
	return [self reverseString:stringDataLength];
}


// 앱의 버전.
- (NSString *)getVersion 
{
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
	return version;
}

// Node.js 서버에서 사용하는 프리 헤더 추가.
- (NSString *)appendPreHeader:(NSString *)json
{
    NSInteger jsonLength = [json length];
    
    NSString *preHeader = [NSString stringWithFormat:NODE_PRE_HEADER, jsonLength];
    NSString *retFormat = [[preHeader stringByAppendingString:json] autorelease];
    
    return retFormat;
}


#pragma mark -
#pragma mark (전문) 조립 메서드.
#pragma mark TCP 소켓을 사용하는 TR 포맷이 아닌 WebSocket을 위한 변형된 TR 포맷을 사용함!
#pragma mark TR의 필드명은 서버 기준임!

// 딕셔너리 타입의 TR 반환.
- (NSMutableDictionary *)genTR:(id)obj withClassName:(NSString *)className 
{
	NSMutableDictionary *trObject = [NSMutableDictionary dictionary];
	
	// 통신헤더 클래스의 프라퍼티 목록.
	NSMutableArray *objProperties = [self getProperties:className];
	
	for (int i = 0; i < [objProperties count]; i++) 
    {
        NSString *key = [objProperties objectAtIndex:i];
        NSString *val = [obj valueForKey:key];
        
        if (val != nil) 
        {
            [trObject setObject:val forKey:key];
        }
        else
        {
            Debug(@"Warning: Value is nil!");
        }
	}
	
	return trObject;
}


// Initiate, Terminate Packet.
- (NSString *)genITPacket:(NSString *)function 
{
	// 통신 헤더.
	CommHeader *commHeader = [[CommHeader alloc] init];
	commHeader.lengcode = [self formatStringforNumber:COMM_HEADER_LEN withCipher:5];
	commHeader.funccode = function;
	commHeader.media_ix = @"333";
	commHeader.mgl = @"000000";
	commHeader.compress = @"0";
	commHeader.pub_auth = @"0";
	commHeader.tradetype = @"6";
	commHeader.conninfo = @"7777";
	
	// JSON 포맷.
	NSString *json = [[self genTR:commHeader withClassName:@"CommHeader"] JSONRepresentation];
	
	return json;
}


// 통신 헤더.
- (NSString *)genCommHeader:(CommHeader *)commHeader 
{
	NSMutableDictionary *trObject = [NSMutableDictionary dictionary];
	
	// 통신헤더 클래스의 프라퍼티 목록.
	NSMutableArray *commHeaderProperties = [self getProperties:@"CommHeader"];
	
	for (int i = 0; i < [commHeaderProperties count]; i++) 
    {
		NSString *key = [commHeaderProperties objectAtIndex:i];
		NSString *val = [commHeader valueForKey:key];
		[trObject setObject:val forKey:key];
	}

	// JSON 포맷.
	NSString *json = [trObject JSONRepresentation];
	
	return json;
}


// TODO: 값 세팅...
// 리얼 시세를 위한 SB 등록.
//- (NSString *)genSB:(NSString *)type andTRCode:(NSString *)trCode withStockCode:(NSMutableArray *)sbBodies 
//{
//	// SBBody 갯수: 반복 횟수.
//	int sbBodyNum = [sbBodies count];
//	
//	// 통신 헤더.
//	CommHeader *commHeader = [[CommHeader alloc] init];
//	commHeader.lengcode = @"00000";
//	commHeader.funccode = @"R";
//	commHeader.media_ix = @"333";
//	commHeader.mgl = @"666666";
//	commHeader.compress = @"0";
//	commHeader.pub_auth = @"0";
//	commHeader.tradetype = @"6";
//	commHeader.conninfo = @"7777";
//	
//	// 데이터 헤더.
//	DataHeader *dataHeader = [[DataHeader alloc] init];
//	dataHeader.handle = @"1111";
//	dataHeader.trcode = trCode;
//	dataHeader.dispno = @"4444";
//	dataHeader.tradetime = @"20110109";
//	dataHeader.custmerno = @"0123456789";
//	dataHeader.msg = @"test";
//	dataHeader.termno = @"012345678912";
//	dataHeader.macaddr = [DataHandler sharedDataHandler].macAddress;
//	dataHeader.termialix = @"1";
//	dataHeader.version = @"1000101";
//	dataHeader.model = @"iPhone 4";
//	
//	// SB 헤더.
//	SBHeader *sbHeader = [[SBHeader alloc] init];
//	sbHeader.length = [self formatStringforNumber:((SB_HEADER_LEN - LENGTH_FIELD_LEN) + 
//												   (SB_BODY_LEN * sbBodyNum)) 
//									   withCipher:5];
//	sbHeader.flag = type;
//	sbHeader.filler = @"";
//	sbHeader.number = [NSString stringWithFormat:@"%d", sbBodyNum];
//	
//	// 통신 헤더의 lengcode 설정.
//	commHeader.lengcode = [self formatStringforNumber:((COMM_HEADER_LEN - LENGTH_FIELD_LEN) + 
//													   DATA_HEADER_LEN + 
//													   (SB_HEADER_LEN + (SB_BODY_LEN * sbBodyNum))) 
//										   withCipher:5];
//	
//	// SB 바디: 데이터의 반복 부분.
//	NSMutableArray *arrayBody = [NSMutableArray array];
//	int i = 0;
//	for (SBBody *sbBody in sbBodies) 
//    {
//		[arrayBody addObject:[self genTR:sbBody withClassName:@"SBBody"]];
//		i++;
//	}
//	
//	// 전문 조립: 통신 헤더 + 데이터 헤더 + SB 헤더 + SB 바디.
//	NSMutableDictionary *trObject = [NSMutableDictionary dictionary];
//	[trObject  addEntriesFromDictionary:[self genTR:commHeader withClassName:@"CommHeader"]];	
//	[trObject  addEntriesFromDictionary:[self genTR:dataHeader withClassName:@"DataHeader"]];
//	[trObject  addEntriesFromDictionary:[self genTR:sbHeader withClassName:@"SBHeader"]];
//	[trObject setObject:arrayBody forKey:@"codeset"];
//	
//	// JSON 포맷.
//	NSString *json = [trObject JSONRepresentation];
//	
//	return json;
//}

// 리얼 시세를 위한 SB 최초접속/접속종료.
- (NSString *)genInitOrFinishSB:(NSString *)trCode andCMD:(NSString *)cmd
{
    // TODO: 메서드로 공통화 시킬 것!
    // SBHeader.
    SBHeader *sbHeader = [[SBHeader alloc] init];
    sbHeader.GID = [DataHandler sharedDataHandler].GID;
    sbHeader.MGL = [DataHandler sharedDataHandler].MGL;
    sbHeader.SID = [DataHandler sharedDataHandler].SID;
    
    // SBBody.
    SBBody *sbBody = [[SBBody alloc] init];
    sbBody.TRCD = trCode;
    sbBody.CMD = cmd;
    sbBody.mdClsf = MDCLSF_iPHONE;
    
    // 전문 조립.
    NSMutableDictionary *trObject = [NSMutableDictionary dictionary];
    [trObject addEntriesFromDictionary:[self genTR:sbHeader withClassName:@"SBHeader"]];
    [trObject addEntriesFromDictionary:[self genTR:sbBody withClassName:@"SBBody"]];
     
    // JSON 포맷.
    NSString *json = [trObject JSONRepresentation];
    
    // Node.js 서버용으로 포맷팅.
    NSInteger jsonLength = [json length];
    NSString *preHeader = [NSString stringWithFormat:NODE_PRE_HEADER, jsonLength];
    NSString *retFormat = [preHeader stringByAppendingString:json];
    
    Debug(@"retFormat: %@", retFormat);
    
    return retFormat;
}

// 리얼 시세를 위한 SB 등록/해제.
- (NSString *)genRegisterOrClearSB:(NSString *)cmd andTRCode:(NSString *)trCode withCodeSet:(NSMutableArray *)sbBodies
{
    // SBHeader.
    SBHeader *sbHeader = [[SBHeader alloc] init];
    sbHeader.GID = [DataHandler sharedDataHandler].GID;
    sbHeader.MGL = [DataHandler sharedDataHandler].MGL;
    sbHeader.SID = [DataHandler sharedDataHandler].SID;
    
    // SBRegBodyHeader.
    SBRegBodyHeader *sbRegBodyHeader = [[SBRegBodyHeader alloc] init];
    sbRegBodyHeader.TRCD = trCode;
    sbRegBodyHeader.CMD = cmd;
    
    // SBRegBody: 데이터의 반복 부분.
	NSMutableArray *arrayBody = [NSMutableArray array];
	int i = 0;
	for (SBRegBody *sbRegBody in sbBodies) 
    {
		[arrayBody addObject:[self genTR:sbRegBody withClassName:@"SBRegBody"]];
		i++;
	}
    
    // 전문 조립.
    NSMutableDictionary *trObject = [NSMutableDictionary dictionary];
    [trObject addEntriesFromDictionary:[self genTR:sbHeader withClassName:@"SBHeader"]];
    [trObject addEntriesFromDictionary:[self genTR:sbRegBodyHeader withClassName:@"SBRegBodyHeader"]];
    [trObject setObject:arrayBody forKey:@"CODESET"];
    
    // JSON 포맷.
    NSString *json = [trObject JSONRepresentation];
    
    // Node.js 서버용으로 포맷팅.
    NSInteger jsonLength = [json length];
    NSString *preHeader = [NSString stringWithFormat:NODE_PRE_HEADER, jsonLength];
    NSString *retFormat = [preHeader stringByAppendingString:json];
    
    Debug(@"retFormat: %@", retFormat);
    
    return retFormat;
}

@end
