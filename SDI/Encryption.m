//
//  Encryption.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 11..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "Encryption.h"
#include "_Issacwebapi.h"

#define SESSION_KEY_LEN 20


@implementation Encryption

@synthesize sessionKey;

- (void)dealloc
{
    [sessionKey release];
    [super dealloc];
}

#pragma mark - 커스텀 메서드

// 세션키 생성.
- (NSString *)genSessionKey
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:SESSION_KEY_LEN];
    
    for (int i = 0; i < SESSION_KEY_LEN; i++) 
    {
        [randomString appendFormat:@"%c", [letters characterAtIndex:rand()%[letters length]]];
    }
    
    Debug(@"\n---------------------------------------------------------------\
          \nCurrent sessionKey: %@\
          \n---------------------------------------------------------------", randomString);
    
    return randomString;
}

// 대칭키 복호화.
// !!!: 아이폰에서 생성한 세션키로 복호화 한다.
- (NSMutableString *)decrypt:(char *)encryptedMsg
{
    //unsigned char symKey[20] = "\x7e\xa5\xbf\x7e\xa8\x04\x85\x19\x15\x0e\x44\x46\xd9\xe6\x18\x1c";
    const unsigned char *string = (const unsigned char *) [self.sessionKey UTF8String];
    int symKeyLen = 20;
    
    unsigned char decryptedMsg[1024] = {0,};
    unsigned int decryptedMsg_len = 0;
    int ret;
    
    // 복호화 함수 호출
    ret = IW_Decrypt(decryptedMsg, &decryptedMsg_len, 1024, string, symKeyLen, ALG_SEED, encryptedMsg);
    
    if (IW_SUCCESS == ret)
    {
        NSMutableString *retVal = [NSMutableString stringWithUTF8String:(const char*)encryptedMsg];
        
        // 확인용.
        [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:retVal];
        
        return retVal;
    }
    else
    {
        NSMutableString *retVal = [NSMutableString string];
        [retVal appendFormat:@"대칭키 복호화에 실패했습니다. [Error Code: %i]", ret];
        Debug(@"%@", retVal);
        
        // 확인용.
        [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:retVal];
        
        return nil;
    }
}

// 하이브리드 암호화.
// !!!: 공개키로 세션키를 암호화하여 서버에 전달한다.
- (NSMutableString *)hybridEncrypt:(NSString *)plainMsg
{
    const char *szPlainMsg = [plainMsg UTF8String];
    //int	nPlainMsgLen = mbstowcs(NULL, szPlainMsg, 0);
    
    // 복호화를 위한 세션키.
    //unsigned char sessionKey[20] = {0,};
    void *pKey = (void *) [[self genSessionKey] UTF8String];
    char encodedEncData[1024] = {0,};
    int ret;
    ret = IW_HybridEncryptEx(encodedEncData,
                           sizeof(encodedEncData), 
                             pKey,
                           SESSION_KEY_LEN,
                           szPlainMsg,
                           strlen(szPlainMsg),
                           "ADCBiAKBgHgWQm5CVQBNaGlIgTgv06HhOXQqSuuBPY2EvPvPsEL120jnT5HCU7lMbP8qVvb2qpGmxN+3PUVUXG1yHKqEGkNc77/eOq4KReHFeezH2wPoLnRkivm0pE4MfWwL2N6la5G1lktZdbtsWMAT7GJeEpbbDkTqatbf4XQkG2Cixq/jAgMBAAEA",      // 공개키.
                           ALG_SEED);

    if (IW_SUCCESS == ret)
    {
        //char *retVal = encodedEncData;
        
        // 확인용.
        [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:[NSMutableString stringWithUTF8String:(char *)encodedEncData]];
        
        return [NSData dataWithBytes:encodedEncData length:1024];//[NSMutableString stringWithUTF8String:(const char *)encodedEncData];
    }
    else
    {
        NSMutableString *retVal = [NSMutableString string];
        [retVal appendFormat:@"하이브리드 암호화에 실패했습니다. [Error Code: %i]", ret];
        Debug(@"%@", retVal);
        
        // 확인용.
        [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:retVal];
        
        return nil;
    }
}

// 대칭키 복호화.
// !!!: 아이폰에서 생성한 세션키로 복호화 한다.
- (NSMutableString *)hybridDecrypt:(NSData *)encryptedMsg
{
    //unsigned char symKey[20] = "\x7e\xa5\xbf\x7e\xa8\x04\x85\x19\x15\x0e\x44\x46\xd9\xe6\x18\x1c";
    const unsigned char *string = (const unsigned char *) [self.sessionKey UTF8String];
    int symKeyLen = 20;
    
    unsigned char decryptedMsg[1024] = {0,};
    unsigned int decryptedMsg_len = 0;
    int ret;
    
    // 복호화 함수 호출
    ret = IW_Decrypt(decryptedMsg, &decryptedMsg_len, 1024, string, symKeyLen, ALG_SEED, encryptedMsg);
    
    if (IW_SUCCESS == ret)
    {
        NSMutableString *retVal = [NSMutableString stringWithUTF8String:(const char*)encryptedMsg];
        
        // 확인용.
        [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:retVal];
        
        return retVal;
    }
    else
    {
        NSMutableString *retVal = [NSMutableString string];
        [retVal appendFormat:@"대칭키 복호화에 실패했습니다. [Error Code: %i]", ret];
        Debug(@"%@", retVal);
        
        // 확인용.
        [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:retVal];
        
        return nil;
    }
}

// 하이브리드 암호화.
// !!!: 공개키로 세션키를 암호화하여 서버에 전달한다.
- (NSData *)hybridEncryptEx:(NSString *)plainMsg
{
    const char *szPlainMsg = [plainMsg UTF8String];
    //int	nPlainMsgLen = mbstowcs(NULL, szPlainMsg, 0);
    
    // 복호화를 위한 세션키.
    //unsigned char sessionKey[20] = {0,};
    void *pKey = (void *) [[self genSessionKey] UTF8String];
    char encodedEncData[1024] = {0,};
    int ret;
    ret = IW_HybridEncryptEx(encodedEncData,
                             sizeof(encodedEncData), 
                             pKey,
                             SESSION_KEY_LEN,
                             szPlainMsg,
                             strlen(szPlainMsg),
                             "ADCBiAKBgHgWQm5CVQBNaGlIgTgv06HhOXQqSuuBPY2EvPvPsEL120jnT5HCU7lMbP8qVvb2qpGmxN+3PUVUXG1yHKqEGkNc77/eOq4KReHFeezH2wPoLnRkivm0pE4MfWwL2N6la5G1lktZdbtsWMAT7GJeEpbbDkTqatbf4XQkG2Cixq/jAgMBAAEA",      // 공개키.
                             ALG_SEED);
    
    if (IW_SUCCESS == ret)
    {
        //char *retVal = encodedEncData;
        
        // 확인용.
        [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:[NSMutableString stringWithUTF8String:(char *)encodedEncData]];
        
        return [NSData dataWithBytes:encodedEncData length:1024];//[NSMutableString stringWithUTF8String:(const char *)encodedEncData];
    }
    else
    {
        NSMutableString *retVal = [NSMutableString string];
        [retVal appendFormat:@"하이브리드 암호화에 실패했습니다. [Error Code: %i]", ret];
        Debug(@"%@", retVal);
        
        // 확인용.
        [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:retVal];
        
        return nil;
    }
}

// 테스트.
- (void)testEncryption
{
    NSData *test = [self hybridEncryptEx:@"암호화 테스트"];
    sleep(5);

    [self decrypt:(char *)test];
    
}

@end
