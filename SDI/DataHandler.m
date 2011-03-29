//
//  DataHandler.m
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 7..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "DataHandler.h"
#import "JSON.h"
#import "DHConstants.h"
#import "TRGenerator.h"


@implementation DataHandler

@synthesize macAddress;
@synthesize MID;
@synthesize GID;
@synthesize MGL;
@synthesize SID;

#pragma mark -
#pragma mark 데이터핸들러.

static DataHandler *sharedDataHandler = nil;

+ (DataHandler *)sharedDataHandler 
{
	@synchronized(self) 
    {
		if (sharedDataHandler == nil) 
        {
			[[self alloc] init];
		}
	}
	
	return sharedDataHandler;
}


// 초기화.
- (id)init 
{
	if ((self = [super init])) 
    {
		// 최조 접속 여부.
        isInit = YES;
		
		// 웹소켓 생성 및 서버 접속.
		webSocket = [[LPWebSocket alloc] initWithURLString:SERVER_URL delegate:self];
		[webSocket open];
		
		// 아이폰의 맥어드레스.
		self.macAddress = [Utils getMacAddress];
	}
	
	return self;
}


// 객체 할당(alloc) 시 호출됨.
// 객체 할당과 초기화 시 sharedDataHandler 인스턴스가 nil인지 확인.
+ (id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) 
    {
        if (sharedDataHandler == nil) 
        {
            sharedDataHandler = [super allocWithZone:zone];
            return sharedDataHandler;
        }
    }
	
    return nil;
}


- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}


- (id)retain 
{
    return self;
}


- (unsigned)retainCount 
{
	// 릴리즈되어서는 안될 객체 표시.
    return UINT_MAX;  
} 


- (void)release 
{
    // 아무일도 안함.
}


- (id)autorelease 
{
    return self;
}


#pragma mark -
#pragma mark LPWebSocket 델리게이트 메서드.

- (void)webSocketDidClose:(LPWebSocket *)aWebSocket 
{
	Debug(@"Connection closed");
}


- (void)webSocket:(LPWebSocket *)aWebSocket didFailWithError:(NSError *)error 
{
    if (error.code == LPWebSocketErrorConnectionFailed) 
    {
		// 접속 에러.
		Debug(@"Connection failed");
    } 
	else if (error.code == LPWebSocketErrorHandshakeFailed) 
    {
		// 핸드쉐이크 에러.
		Debug(@"Handshake failed");
    } 
	else 
    {
		// 에러.
		Debug(@"Error");
    }
}


- (void)webSocket:(LPWebSocket *)aWebSocket didReceiveMessage:(NSString *)message 
{
    [self receiveMessage:message];
}


- (void)webSocketDidOpen:(LPWebSocket *)aWebSocket 
{
    Debug(@"Connected: %@", SERVER_URL);
}


- (void)webSocketDidSendMessage:(LPWebSocket *)aWebSocket 
{
    messages--;
    if (messages == 0) 
    {
        // TODO: 인디게이터 중지.
    }
}


#pragma mark -
#pragma mark 웹소켓 접속 관련 메서드.

- (void)reconnect 
{
    if (!webSocket.connected) 
    {
        [webSocket open];
    }
}

- (void)close
{
    if (webSocket.connected) {
        [webSocket close];
    }
}


#pragma mark -
#pragma mark 데이터 전송 및 수신 메서드.

- (void)sendMessage:(NSString *)message 
{
    Debug(@"\n---------------------------------------------------------------\
          \nSend message: %@\
          \n---------------------------------------------------------------", message);
	
	if (webSocket.connected) 
    {
        messages++;
        // TODO: 인디게이터 중지 코드 추가할 것.
        [webSocket send:message];
    } 
	else 
    {
        Debug(@"Cannot send message, not connected");
    } 
}


- (void)receiveMessage:(NSString *)message 
{
    Debug(@"\n---------------------------------------------------------------\
          \nReceived message: %@\
          \n---------------------------------------------------------------", message);
    
    // 메시지 필터링.
    message = [self filteredMessage:message];
    
    // 메시지 nil 체크.
    if (message == nil) { return; };
    
    // SBJsonParser 생성.
    SBJsonParser *jsonParser = [[[SBJsonParser alloc] init] autorelease];
    
    // 응답 문자열로부터 딕셔너리 획득. 
    NSDictionary *dic = (NSDictionary *)[jsonParser objectWithString:message error:NULL];
    Debug(@"%@", dic);
    
    if (isInit) 
    {
        isInit = NO;
        
        if ([dic objectForKey:@"MID"] != nil) { self.MID = [dic objectForKey:@"MID"]; }
        if ([dic objectForKey:@"GID"] != nil) { self.GID = [dic objectForKey:@"GID"]; }
        if ([dic objectForKey:@"MGL"] != nil) { self.MGL = [dic objectForKey:@"MGL"]; }
        if ([dic objectForKey:@"SID"] != nil) { self.SID = [dic objectForKey:@"SID"]; }
        
        if (self.MID != nil && self.GID != nil && self.MGL != nil && self.SID != nil) 
        {
            // 2 단계: SB 최초 접속 등록.
            TRGenerator *tr =  [[TRGenerator alloc] init];
            [self sendMessage:[tr genInitOrFinishSB:TRCD_MAINSTRT andCMD:SB_CMD_INIT_OR_FINISH]];
        }
        else
        {
            // 에러 처리.  얼럿 등...
        }
    }
    else
    {
        // 화면에 전달할 데이터를 trCode를 기준으로 노티피케이션.
        if ([dic objectForKey:@"TRCD"]) 
        {
            NSString *trCode = [dic objectForKey:@"TRCD"];
            Debug(@"trCode: %@", trCode);
            
            // trCode에 따른 데이터 노티피케이션.
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:trCode object:self userInfo:dic];
        }
    }
}

#pragma mark -
#pragma mark 커스텀 메서드

- (BOOL)matchString:(NSString *)theString withString:(NSString *)withString 
{
	NSRange range = [theString rangeOfString:withString];
	int length = range.length;
	
	if (length == 0) { return NO; }
	
	return YES;
}

// 예외 처리: Node.js에서 추가한 헤더 제거.
// !!! 클라이언트에서 이렇게 처리하는 것보다 서버에서 한 번에 처리하는 것이 더 좋을 듯...
- (NSString *)filteredMessage:(NSString *)message
{    
    if ([self matchString:message withString:@"~j~"]) 
    {
        NSArray *listMessages = [message componentsSeparatedByString:@"~j~"];
        message = (NSString *)[listMessages lastObject];
    }
    else
    {
        message = nil;
    }
    
    Debug(@"\n---------------------------------------------------------------\
          \nFiltered message: %@\
          \n---------------------------------------------------------------", message);
        
    return message;
}

@end
