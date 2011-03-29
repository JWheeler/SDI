//
//  SBBody.h
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 9..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBBody : NSObject 
{
    NSString *TRCD;     // TR Code.
    NSString *CMD;      // 구분(1: 등록, 2: 해제, 3: 최초접속/해제)
    NSString *mdClsf;   // 매체 구분(아이폰: 364, 안드로이드: 366, 아이패드: 382, 안드로이드패드: 383).
}

@property (nonatomic, retain) NSString *TRCD;
@property (nonatomic, retain) NSString *CMD;
@property (nonatomic, retain) NSString *mdClsf;

@end
