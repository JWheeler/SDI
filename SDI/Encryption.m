//
//  Encryption.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 11..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "Encryption.h"


@implementation Encryption

- (void)testEncryption
{
    // 암복화에 사용핛 길이 16byte의 대칭키 선언
    unsigned char symKey[20] = "\x7e\xa5\xbf\x7e\xa8\x04\x85\x19\x15\x0e\x44\x46\xd9\xe6\x18\x1c";
    int symKeyLen = 16;
    char	encryptedMsg[1024] = {0,};
    int ret;
    NSString	*plainMsg = [[NSString alloc] initWithString:@"암호화핛 텍스트"];
    const char *szPlainMsg = [plainMsg UTF8String];
    int	nPlainMsgLen = mbstowcs(NULL, szPlainMsg, 0);
    // 암호화 함수 호출
    ret = IW_Encrypt(encryptedMsg, sizeof(encryptedMsg), symKey, symKeyLen,
                     ALG_ARIA, (unsigned char *)szPlainMsg, nPlainMsgLen);
    [plainMsg release];
    if( IW_SUCCESS != ret )
    {
        NSMutableString *outVal = [NSMutableString string];
        [outVal appendFormat:@"Error Code: %i", ret];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:outVal delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
//    unsigned char decryptedMsg[1024] = {0,};
//    unsigned int	decryptedMsg_len	= 0;
//    // 복호화 함수 호출
//    ret = IW_Decrypt(decryptedMsg, &decryptedMsg_len, 1024, symKey,
//                     symKeyLen, ALG_ARIA, encryptedMsg);
//    if( IW_SUCCESS == ret )
//    {
//        outVal = [ NSMutableString stringWithUTF8String:(const char *) decryptedMsg ];
//    }
//    else
//    {
//        outVal = [NSMutableString string];
//        [outVal appendFormat:@"Error Code: %i", ret];
//    }
//    [encryptedMsg release];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
//                                                    message:outVal delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,
//                          nil];
//    [alert show];
//    [alert release];
}

@end
