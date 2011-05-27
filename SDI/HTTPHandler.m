//
//  HTTPHandler.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 13..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "HTTPHandler.h"
#import "Encryption.h"


@implementation HTTPHandler

@synthesize reponseDict;
@synthesize reponse;

- (void)dealloc
{
    [reponseDict release];
    [reponse release];
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

#pragma mark - 커스텀 메서드.

// 종목의 현재가 검색: 비동기.
//- (void)searchCurrentPrice:(NSString *)stockCode
//{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:SEARCH_CURRENT_PRICE, stockCode]];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setDelegate:self];
//    [request startAsynchronous];
//}

// RQ 요청: App 용 통합 버전. -----------------------------------------------------
// trCode는 실제 query string 이다.
- (void)req:(NSString *)trCode
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:RQRP_SERVER_URL, trCode]];
    Debug(@"Request URL: %@", url);
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

// 암호화된 데이터 전송.
- (void)reqForEncrypt:(NSString *)data
{
    // 데이터 암호화.
    Encryption *encrypt = [[Encryption alloc] init];
    NSString *encryptData = [encrypt hybridEncrypt:data];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:RQRP_ENCRYPT_SERVER_URL, encryptData]];
    Debug(@"Request URL: %@", url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) 
    {
        NSString *responseString = [request responseString];
        
        // 데이터 복호화.
        NSString *decryptedData = [encrypt decrypt:responseString];
        
        // SBJsonParser 생성.
        SBJsonParser *jsonParser = [[[SBJsonParser alloc] init] autorelease];
        
        // 응답 문자열로부터 딕셔너리 획득. 
        self.reponseDict = (NSDictionary *)[jsonParser objectWithString:decryptedData error:NULL];
        Debug(@"%@", self.reponseDict);
    }
    else
    {
        Debug(@"Connection error!");
    }
}
// RQ 요청: App 용 통합 버전. -----------------------------------------------------

// RQ 요청: Web 용 통합 버전. -----------------------------------------------------
- (void)reqForWeb:(NSString *)trCode
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:RQRP_SERVER_URL, trCode]];
    Debug(@"Request URL: %@", url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) 
    {
        self.reponse = [request responseString];
        
        Debug(@"%@", self.reponseDict);
    }
    else
    {
        Debug(@"Connection error!");
    }
}

// 암호화된 데이터 전송.
- (void)reqEncryptForWeb:(NSString *)data
{
    // 데이터 암호화.
    Encryption *encrypt = [[Encryption alloc] init];
    NSString *encryptData = [encrypt hybridEncrypt:data];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:RQRP_ENCRYPT_SERVER_URL, encryptData]];
    Debug(@"Request URL: %@", url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) 
    {
        
        // 데이터 복호화.
        self.reponse = [encrypt decrypt:[request responseString]];
        
        Debug(@"%@", self.reponseDict);
    }
    else
    {
        Debug(@"Connection error!");
    }
}
// RQ 요청: Web 용 통합 버전. -----------------------------------------------------

@end
