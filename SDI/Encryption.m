//
//  Encryption.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 11..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "Encryption.h"
#include "_Issacwebapi.h"


@implementation Encryption

- (void)testEncryption
{
    char plainMsg[128] = "This is HybridEncrypted Msg.";
    unsigned char sessionKey[20] = {0,};
    char encodedEncData[1024] = {0,};
    int ret;
    ret = IW_HybridEncrypt(encodedEncData,
                           sizeof(encodedEncData),
                           sessionKey,
                           plainMsg,
                           strlen(plainMsg),
                           "ADCBiAKBgHgWQm5CVQBNaGlIgTgv06HhOXQqSuuBPY2EvPvPsEL120jnT5HCU7lMbP8qVvb2qpGmxN+3PUVUXG1yHKqEGkNc77/eOq4KReHFeezH2wPoLnRkivm0pE4MfWwL2N6la5G1lktZdbtsWMAT7GJeEpbbDkTqatbf4XQkG2Cixq/jAgMBAAEA",
                           ALG_ARIA);
    if (IW_SUCCESS == ret)
    {
        NSMutableString *outVal = [NSMutableString stringWithUTF8String:(const char *)encodedEncData];
        //[hybridEncryptedText setText:outVal];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:outVal
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        //[self testDecryption:encodedEncData];
    }
    else
    {
        NSMutableString *outVal = [NSMutableString string];
        [outVal appendFormat:@"Error Code: %i", ret];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:outVal
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)testDecryption:(char *)encryptedMsg
{
    // 암복화에 사용핛 길이 16byte의 대칭키 선언
    unsigned char symKey[200] = "ADCBiAKBgHgWQm5CVQBNaGlIgTgv06HhOXQqSuuBPY2EvPvPsEL120jnT5HCU7lMbP8qVvb2qpGmxN+3PUVUXG1yHKqEGkNc77/eOq4KReHFeezH2wPoLnRkivm0pE4MfWwL2N6la5G1lktZdbtsWMAT7GJeEpbbDkTqatbf4XQkG2Cixq/jAgMBAAEA";
    int symKeyLen = 16;
    unsigned char decryptedMsg[1024] = {0,};
    unsigned int decryptedMsg_len	= 0;
    int ret;
    NSMutableString *outVal = [NSMutableString string];
//    NSString *plainMsg = encryptedData; //[[NSString alloc] initWithString:@"암호화핛 텍스트"];
//    const char *encryptedMsg = encryptedData; //[plainMsg UTF8String];
    // 복호화 함수 호출
    ret = IW_Decrypt(decryptedMsg, &decryptedMsg_len, 1024, symKey, symKeyLen, ALG_ARIA, encryptedMsg);
    if (IW_SUCCESS == ret)
    {
        outVal = [NSMutableString stringWithUTF8String:(const char *)decryptedMsg];
    }
    else
    {
        outVal = [NSMutableString string];
        [outVal appendFormat:@"Error Code: %i", ret];
    }
    //[encryptedMsg release];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                    message:outVal 
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
@end
