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

- (char *)hybridEncrypt:(NSString *)plainMsg;
- (NSMutableString *)decrypt:(char *)encryptedMsg;

- (void)testEncryption;

@end
