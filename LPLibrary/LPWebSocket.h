//
//  LPWebSocket.h
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 1. 18..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@class AsyncSocket;
@class LPWebSocket;

@protocol LPWebSocketDelegate<NSObject>
@optional 
- (void)webSocket:(LPWebSocket *)webSocket didFailWithError:(NSError *)error;
- (void)webSocketDidOpen:(LPWebSocket *)webSocket;
- (void)webSocketDidClose:(LPWebSocket *)webSocket;
- (void)webSocket:(LPWebSocket *)webSocket didReceiveMessage:(NSString *)message;
- (void)webSocketDidSendMessage:(LPWebSocket *)webSocket;
@end


@interface LPWebSocket : NSObject 
{
	id<LPWebSocketDelegate> delegate;
    NSURL *url;
    AsyncSocket *socket;
    BOOL connected;
    NSString *origin;
    
    NSArray *runLoopModes;
}

@property (nonatomic,assign) id<LPWebSocketDelegate> delegate;
@property (nonatomic,readonly) NSURL *url;
@property (nonatomic,retain) NSString *origin;
@property (nonatomic,readonly) BOOL connected;
@property (nonatomic,retain) NSArray *runLoopModes;

+ (id)webSocketWithURLString:(NSString *)urlString delegate:(id<LPWebSocketDelegate>)delegate;
- (id)initWithURLString:(NSString *)urlString delegate:(id<LPWebSocketDelegate>)delegate;

- (void)open;
- (void)close;
- (void)send:(NSString *)message;

@end


enum {
    LPWebSocketErrorConnectionFailed = 1,
    LPWebSocketErrorHandshakeFailed = 2
};

extern NSString *const LPWebSocketException;
extern NSString *const LPWebSocketErrorDomain;
