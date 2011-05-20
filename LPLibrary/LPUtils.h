//
//  Utils.h
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 9..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPAddress.h"

enum 
{
    LPAlertTypeFirst = 0,
    LPAlertTypeSecond = 1
};


@interface LPUtils : NSObject 
{

}

+ (NSString *)formatNumber:(int)num;
+ (NSString *)getIPAdress;
+ (NSString *)getMacAddress;
+ (void)showAlert:(int)type andTag:(int)tag withTitle:(NSString *)title andMessage:(NSString *)message;
+ (NSString *)reverseString:(NSString *)string;
+ (NSString *)formatStringNumber:(NSString *)string withCipher:(int)cipher;
+ (BOOL)matchString:(NSString *)theString withString:(NSString*)withString;
+ (NSString *)stringToHex:(NSString *)string;
+ (float)convertStringToNumber:(NSString *)string;

@end
