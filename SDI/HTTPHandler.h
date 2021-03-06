//
//  HTTPHandler.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 13..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "JSON.h"


@interface HTTPHandler : NSObject 
{

}

@property (nonatomic, retain) NSDictionary *reponseDict;
@property (nonatomic, retain) NSString *reponse;

- (void)req:(NSString *)trCode;
- (void)reqForEncrypt:(NSString *)data;
- (void)reqForWeb:(NSString *)trCode;
- (void)reqEncryptForWeb:(NSString *)data;

@end
