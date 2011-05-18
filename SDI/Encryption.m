//
//  Encryption.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 11..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "Encryption.h"
#import "Random.h"
#include "_Issacwebapi.h"


@implementation Encryption

@synthesize sessionKey;

PRIVATEKEY *privKey;

- (void)dealloc
{
    [sessionKey release];
    [super dealloc];
}

// 세션키 생성.
- (void)genSessionKey
{
    // 랜덤 테스트.
    initRandomSeed( (long) [[NSDate date] timeIntervalSince1970] );
    float myRandomNumber = nextRandomFloat() * 74;
    Debug(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%f", myRandomNumber);
}

// 대칭키 복호화.
// !!!: 아이폰에서 생성한 세션키로 복호화 한다.
- (NSMutableString *)decrypt:(char *)encryptedMsg
{
    unsigned char symKey[20] = "\x7e\xa5\xbf\x7e\xa8\x04\x85\x19\x15\x0e\x44\x46\xd9\xe6\x18\x1c";
    int symKeyLen = 16;
    
    unsigned char decryptedMsg[1024] = {0,};
    unsigned int decryptedMsg_len = 0;
    int ret;
    
    // 복호화 함수 호출
    ret = IW_Decrypt(decryptedMsg, &decryptedMsg_len, 1024, symKey, symKeyLen, ALG_SEED, encryptedMsg);
    
    if (IW_SUCCESS == ret)
    {
        NSMutableString *retVal = [NSMutableString stringWithUTF8String:(const char *)encryptedMsg];
        
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
// !!!: 서버의 공개키로 세션키를 암호화하여 서버에 전달한다.
- (char *)hybridEncrypt:(NSString *)plainMsg
{
    const char *szPlainMsg = [plainMsg UTF8String];
    int	nPlainMsgLen = mbstowcs(NULL, szPlainMsg, 0);
    
    // 복호화를 위한 세션키.
    //unsigned char sessionKey[20] = {0,};
    char encodedEncData[1024] = {0,};
    int ret;
    ret = IW_HybridEncryptEx(encodedEncData,
                           sizeof(encodedEncData),
                           "\x7e\xa5\xbf\x7e\xa8\x04\x85\x19\x15\x0e\x44\x46\xd9\xe6\x18\x1c",
                           20,
                           szPlainMsg,
                           nPlainMsgLen,
                           "ADCBiAKBgHgWQm5CVQBNaGlIgTgv06HhOXQqSuuBPY2EvPvPsEL120jnT5HCU7lMbP8qVvb2qpGmxN+3PUVUXG1yHKqEGkNc77/eOq4KReHFeezH2wPoLnRkivm0pE4MfWwL2N6la5G1lktZdbtsWMAT7GJeEpbbDkTqatbf4XQkG2Cixq/jAgMBAAEA",
                           ALG_SEED);
    
    [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림1" andMessage:[NSString stringWithFormat:@"%p", sessionKey]];

    if (IW_SUCCESS == ret)
    {
        char *retVal = encodedEncData;
        
        // 확인용.
        [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:[NSMutableString stringWithUTF8String:(const char *)encodedEncData]];
        
        return retVal;
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
   char *encryptData =  [self hybridEncrypt:@"하이브리드 암호화 테스트!!!"];
    
    sleep(5);
    [self decrypt:encryptData];
}

@end
