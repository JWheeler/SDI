//
//  HTTPHandler.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 13..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "HTTPHandler.h"


@implementation HTTPHandler

@synthesize reponseDict;

- (void)dealloc
{
    [reponseDict release];
    [super dealloc];
}

#pragma mark - ASIHTTPRequest 델리게이트 메서드.

// 비동기 요청.
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // 텍스트 데이터.
    NSString *responseString = [request responseString];
    
    // 바이너리 데이터.
    //NSData *responseData = [request responseData];
    
    //Debug(@"Received message: %@", responseString);
    
    // SBJsonParser 생성.
    SBJsonParser *jsonParser = [[[SBJsonParser alloc] init] autorelease];
    
    // 응답 문자열로부터 딕셔너리 획득. 
    self.reponseDict = (NSDictionary *)[jsonParser objectWithString:responseString error:NULL];
    Debug(@"%@", self.reponseDict);
}

// 요청 실패.
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    if (error != nil) 
    {
        Debug(@"Connection error!");
    }
}

#pragma mark - 커스터 메서드.

// 종목의 현재가 검색: 비동기.
//- (void)searchCurrentPrice:(NSString *)stockCode
//{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:SEARCH_CURRENT_PRICE, stockCode]];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setDelegate:self];
//    [request startAsynchronous];
//}

// 종목의 현재가 검색: 동기.
- (void)searchCurrentPrice:(NSString *)stockCode
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:SEARCH_CURRENT_PRICE, stockCode]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) 
    {
        NSString *responseString = [request responseString];
        
        // SBJsonParser 생성.
        SBJsonParser *jsonParser = [[[SBJsonParser alloc] init] autorelease];
        
        // 응답 문자열로부터 딕셔너리 획득. 
        self.reponseDict = (NSDictionary *)[jsonParser objectWithString:responseString error:NULL];
        Debug(@"%@", self.reponseDict);
    }
    else
    {
        Debug(@"Connection error!");
    }
}

@end
