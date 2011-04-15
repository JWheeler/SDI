//
//  DataHandler.h
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 7..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPWebSocket.h"


@interface DataHandler : NSObject <LPWebSocketDelegate, UIAlertViewDelegate> 
{
	LPWebSocket *webSocket;		// 웹소켓.
	int messages;				// 메시지 카운트.
	BOOL isInit;				// 접속 초기화 여부.
	NSString *macAddress;		// 아이폰의 맥어드레스.
    NSString *MID;              // Machine ID: 서버마다 고유한 4자리의 ID를 갖는다(SDIt, SDI1 등).
    NSString *GID;              // 서버마다 10개의 Node.js 서버가 서비스를 하고 그 중 몇 번째 Node 이진 표시.
    NSString *MGL;              // Node 마다 200 개의 Connection을 관리하며 해당 ㅓㅈㅂ속이 Node가 관리하는 Connection Pool의 몇 번째 접속이지 표시.
    NSString *SID;              // Socket.io가 관리하는 고유의 Session ID로 같은 Node 안에서는 Connection 마다 Unique한 값을 갖는다.
}

@property (nonatomic, retain) NSString *macAddress;
@property (nonatomic, retain) NSString *MID;
@property (nonatomic, retain) NSString *GID;
@property (nonatomic, retain) NSString *MGL;
@property (nonatomic, retain) NSString *SID;

+ (DataHandler *)sharedDataHandler;

- (void)reconnect;
- (void)close;
- (void)sendMessage:(NSString *)message;
- (void)receiveMessage:(NSString *)message;
- (BOOL)matchString:(NSString *)theString withString:(NSString *)withString;
- (NSString *)filteredMessage:(NSString *)message;

@end
