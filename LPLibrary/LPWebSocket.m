//
//  LPWebSocket.m
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 1. 18..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "LPWebSocket.h"
#import "AsyncSocket.h"


NSString *const LPWebSocketErrorDomain = @"LPWebSocketErrorDomain";
NSString *const LPWebSocketException = @"LPWebSocketException";

enum 
{
    LPWebSocketTagHandshake = 0,
    LPWebSocketTagMessage = 1
};


@implementation LPWebSocket

@synthesize delegate; 
@synthesize url;
@synthesize origin;
@synthesize connected; 
@synthesize runLoopModes;


#pragma mark -
#pragma mark 초기화 메서드

+ (id)webSocketWithURLString:(NSString *)urlString delegate:(id<LPWebSocketDelegate>)aDelegate 
{
    return [[[LPWebSocket alloc] initWithURLString:urlString delegate:aDelegate] autorelease];
}


- (id)initWithURLString:(NSString *)urlString delegate:(id<LPWebSocketDelegate>)aDelegate 
{
    self = [super init];
    if (self) 
    {
        self.delegate = aDelegate;
        url = [[NSURL URLWithString:urlString] retain];
        if (![url.scheme isEqualToString:@"ws"]) 
        {
            [NSException raise:LPWebSocketException format:[NSString stringWithFormat:@"Unsupported protocol %@", url.scheme] arguments:nil];
        }
        socket = [[AsyncSocket alloc] initWithDelegate:self];
        self.runLoopModes = [NSArray arrayWithObjects:NSRunLoopCommonModes, nil]; 
    }
    return self;
}


#pragma mark -
#pragma mark 델리게이트 메서드

- (void)_dispatchFailure:(NSNumber *)code 
{
    if (delegate && [delegate respondsToSelector:@selector(webSocket:didFailWithError:)]) 
    {
        [delegate webSocket:self didFailWithError:[NSError errorWithDomain:LPWebSocketErrorDomain code:[code intValue] userInfo:nil]];
    }
}


- (void)_dispatchClosed 
{
    if (delegate && [delegate respondsToSelector:@selector(webSocketDidClose:)]) 
    {
        [delegate webSocketDidClose:self];
    }
}


- (void)_dispatchOpened 
{
    if (delegate && [delegate respondsToSelector:@selector(webSocketDidOpen:)]) 
    {
        [delegate webSocketDidOpen:self];
    }
}


- (void)_dispatchMessageReceived:(NSString *)message 
{
    if (delegate && [delegate respondsToSelector:@selector(webSocket:didReceiveMessage:)]) 
    {
        [delegate webSocket:self didReceiveMessage:message];
    }
}


- (void)_dispatchMessageSent 
{
    if (delegate && [delegate respondsToSelector:@selector(webSocketDidSendMessage:)]) 
    {
        [delegate webSocketDidSendMessage:self];
    }
}


#pragma mark -
#pragma mark 프라이빗 메서드

- (void)_readNextMessage 
{
    [socket readDataToData:[NSData dataWithBytes:"\xFF" length:1] withTimeout:-1 tag:LPWebSocketTagMessage];
}


#pragma mark -
#pragma mark 퍼블릭 메서드

- (void)close 
{
    [socket disconnectAfterReadingAndWriting];
}


- (void)open 
{
    if (!connected) 
    {
        [socket connectToHost:url.host onPort:[url.port intValue] withTimeout:5 error:nil];
        if (runLoopModes) [socket setRunLoopModes:runLoopModes];
    }
}


- (void)send:(NSString *)message 
{
    NSMutableData *data = [NSMutableData data];
	// 데이터 시작: 0x00 byte.
    [data appendBytes:"\x00" length:1];
	// 데이터는 UTF8 text.
    [data appendData:[message dataUsingEncoding:NSUTF8StringEncoding]];
	// 데이터 종료: 0xFF byte.
    [data appendBytes:"\xFF" length:1];
    [socket writeData:data withTimeout:-1 tag:LPWebSocketTagMessage];
}


#pragma mark -
#pragma mark AsyncSocket 델리게이트 메서드

-(void)onSocketDidDisconnect:(AsyncSocket *)sock 
{
    connected = NO;
}


-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err 
{
    if (!connected) 
    {
        [self _dispatchFailure:[NSNumber numberWithInt:LPWebSocketErrorConnectionFailed]];
    } 
	else 
    {
        [self _dispatchClosed];
    }
}


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port 
{
    NSString *requestOrigin = self.origin;
    if (!requestOrigin) requestOrigin = [NSString stringWithFormat:@"http://%@", url.host];
	
    NSString *requestPath = url.path;
    if (url.query) 
    {
		requestPath = [requestPath stringByAppendingFormat:@"?%@", url.query];
    }
    NSString *getRequest = [NSString stringWithFormat:@"GET %@ HTTP/1.1\r\n"
							"Upgrade: WebSocket\r\n"
							"Connection: Upgrade\r\n"
							"Host: %@\r\n"
							"Origin: %@\r\n"
							"\r\n",
							requestPath, url.host, requestOrigin];
    [socket writeData:[getRequest dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:LPWebSocketTagHandshake];
}


- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag 
{
    if (tag == LPWebSocketTagHandshake) 
    {
        [sock readDataToData:[@"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:LPWebSocketTagHandshake];
    } 
	else if (tag == LPWebSocketTagMessage) 
    {
        [self _dispatchMessageSent];
    }
}


- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag 
{
    if (tag == LPWebSocketTagHandshake) 
    {
        NSString *response = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        if ([response hasPrefix:@"HTTP/1.1 101 Web Socket Protocol Handshake\r\nUpgrade: WebSocket\r\nConnection: Upgrade\r\n"]) 
        {
            connected = YES;
            [self _dispatchOpened];
            
            [self _readNextMessage];
        } 
		else 
        {
            [self _dispatchFailure:[NSNumber numberWithInt:LPWebSocketErrorHandshakeFailed]];
        }
    } 
	else if (tag == LPWebSocketTagMessage) 
    {
		// 데이터 시작: 0x00 byte.
        char firstByte = 0xFF;
        [data getBytes:&firstByte length:1];
        if (firstByte != 0x00) return; // 메시지 버림.
        NSString *message = [[[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(1, [data length] - 2)] encoding:NSUTF8StringEncoding] autorelease];
        [self _dispatchMessageReceived:message];
        [self _readNextMessage];
    }
}


#pragma mark -
#pragma mark Destructor

- (void)dealloc 
{
    socket.delegate = nil;
    [socket disconnect];
    [socket release];
    [runLoopModes release];
    [url release];
    [super dealloc];
}

@end
