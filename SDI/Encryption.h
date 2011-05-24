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
    unsigned char m_pbSessionKey[16];
}

- (NSString *)decrypt:(NSString *)encryptedMsg;
- (NSString *)hybridEncrypt:(NSString *)plainMsg;

@end
