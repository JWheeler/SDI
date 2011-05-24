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

- (id)init
{
    self = [super init];
    if (self) 
    {
        memset(m_pbSessionKey, 0, sizeof(m_pbSessionKey));
    }
    
    return self;
}

#pragma mark - 커스텀 메서드

// 복호화.
- (NSString *)decrypt:(NSString *)encryptedMsg
{
    char plainMsg[8192] = {0,};
    unsigned int nPlainMsgLen;
    
    IW_RETURN ret = IW_Decrypt((unsigned char *)plainMsg, 
                               &nPlainMsgLen, 
                               sizeof(plainMsg), 
                               m_pbSessionKey, 
                               sizeof(m_pbSessionKey), 
                               ALG_SEED, 
                               [encryptedMsg UTF8String]);
    
    /**
     *  [한글 인코딩]
     *  1. CP949: CFStringConvertEncodingToNSStringEncoding(0x0422)
     *  2. EUC-KR: -2147481280
     *  3. NSASCIIStringEncoding
     *  4. NSUTF8StringEncoding
     */
    NSString *retVal = [NSString stringWithCString:plainMsg encoding:NSUTF8StringEncoding];
    
    if (IW_SUCCESS == ret)
    {
        Debug(@"Decrypted data: %@", retVal);
        
        // 확인용.
        //[LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:retVal];
        
        return retVal;
    }
    else
    {
        NSMutableString *retVal = [NSMutableString string];
        [retVal appendFormat:@"복호화에 실패했습니다. [Error Code: %i]", ret];
        Debug(@"%@", retVal);
        
        // 확인용.
        //[LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:retVal];
        
        return nil;
    }
}

// 하이브리드 암호화.
- (NSString *)hybridEncrypt:(NSString *)plainMsg
{    
    char encodedEncData[8192] = {0,};
    const char *szPlainMsg = [plainMsg UTF8String];
    // TODO: 공개키 사용 정책 확인!
    // 다음 변수는 사용 안함, 현재는 소스코드에 집적 입력함!
    //const char *szPubKey = [m_pubKey UTF8String];
    
    int ret = IW_HybridEncrypt(encodedEncData, 
                               sizeof(encodedEncData), 
                               m_pbSessionKey, 
                               szPlainMsg, 
                               mbstowcs(NULL, szPlainMsg, 0),
                               "ADCBiAKBgHgWQm5CVQBNaGlIgTgv06HhOXQqSuuBPY2EvPvPsEL120jnT5HCU7lMbP8qVvb2qpGmxN+3PUVUXG1yHKqEGkNc77/eOq4KReHFeezH2wPoLnRkivm0pE4MfWwL2N6la5G1lktZdbtsWMAT7GJeEpbbDkTqatbf4XQkG2Cixq/jAgMBAAEA", 
                               ALG_SEED);
    
    NSString *encData = [NSString stringWithFormat:@"%s", encodedEncData];
    Debug(@"Encrypted data: %@", encData);
    
    // Base64 encode된 문자열의 ?, = 등의 특수문자를 URLEncode처리.
    NSString *escaped = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,                                                               
                                                                            (CFStringRef)encData, 
                                                                            NULL, 
                                                                            CFSTR("!*'();:@&=+$,/?%#[]"), 
                                                                            kCFStringEncodingUTF8);
    
    if (IW_SUCCESS == ret)
    {
        Debug(@"Escaped(in encrypted) data: %@", escaped);
        // 확인용.
        //[LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:escaped];
        
        return escaped;
    }
    else
    {
        NSMutableString *retVal = [NSMutableString string];
        [retVal appendFormat:@"암호화에 실패했습니다. [Error Code: %i]", ret];
        Debug(@"%@", retVal);
        
        // 확인용.
        //[LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:retVal];
        
        return nil;
    }
}

@end
