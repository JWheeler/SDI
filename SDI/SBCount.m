//
//  SBRegCount.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 30..
//  Copyright (c) 2011 Lilac Studio. All rights reserved.
//

#import "SBCount.h"


@implementation SBCount

@synthesize trCode = _trCode;
@synthesize idx = _idx;
@synthesize code = _code;
@synthesize regCount = _regCount;

// 초기화.
- (id)initWithTRCode:(NSString *)trCode idx:(NSString *)idx code:(NSString *)code
{
    self = [super init];
    if (self)
    {
        // SB 등록 카운트 초기화.
        self.regCount = [NSNumber numberWithInt:1];
        
        self.trCode = trCode;
        self.idx = idx;
        self.code = code;
    }
    
    return self;
}

// regCount +1 증가.
- (void)increaseRegCount
{
    self.regCount = [NSNumber numberWithInt:[self.regCount intValue] + 1];
    [self debugRegCount];
}

// regCount -1 감소.
- (void)decreaseRegCount
{
    if ([self.regCount intValue] > 0) 
    {
        self.regCount = [NSNumber numberWithInt:[self.regCount intValue] - 1];
    }
    [self debugRegCount];
    
    // regCount가 0이면 SB 해제.
    if ([self.regCount intValue] == 0) 
    {
        [self clearSB];
    }
}

// SB 등록 해제.
- (void)clearSB
{
    // TODO: SB 등록해제 TR 전송.
    Debug(@"SB 등록해제!");
}

// 현재 regCount 확인.
- (void)debugRegCount
{
    Debug(@"\n---------------------------------------------------------------\
          \nTR Code: %@\
          \nIDX: %@\
          \nStock code: %@\
          \nCurrent regCount: %@\
          \n---------------------------------------------------------------", self.trCode, self.idx, self.code, self.regCount);
}

@end
