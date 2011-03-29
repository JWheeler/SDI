//
//  SBInit.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 28..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBRegBodyHeader : NSObject 
{
    NSString *TRCD;     // TR Code: MAINSTRT
    NSString *CMD;      // 구분(1: 등록, 2: 해제, 3: 최초접속/해제)
}

@property (nonatomic, retain) NSString *TRCD;
@property (nonatomic, retain) NSString *CMD;

@end
