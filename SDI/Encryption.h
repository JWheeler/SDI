//
//  Encryption.h
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 11..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Encryption : NSObject 
{

}

@property (nonatomic, retain) NSString *sessionKey;

- (NSString *)genSessionKey;
- (NSMutableString *)decrypt:(char *)encryptedMsg;
- (NSMutableString *)hybridEncrypt:(NSString *)plainMsg;
- (NSMutableString *)hybridDecrypt:(NSData *)encryptedMsg;
- (NSData *)hybridEncryptEx:(NSString *)plainMsg;

- (void)testEncryption;

@end
