//
//  SBRegisterBody.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 29..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBRegBody : NSObject 
{
    NSString *idx;		// 구분(0: 장내, 장외).
	NSString *code;		// 종목코드(단축코드).
}

@property (nonatomic, retain) NSString *idx;
@property (nonatomic, retain) NSString *code;

@end
