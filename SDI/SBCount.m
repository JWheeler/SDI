//
//  SBRegCount.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 30..
//  Copyright (c) 2011 Lilac Studio. All rights reserved.
//

#import "SBCount.h"
#import "DataHandler.h"
#import "TRGenerator.h"


@implementation SBCount

@synthesize trCode = _trCode;
@synthesize idx = _idx;
@synthesize code = _code;
@synthesize regCount = _regCount;

- (id)init
{
    self = [super init];
    if (self) 
    {
    }
    
    return self;
}

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
        // ???: 처리하는 부분을 SBManager 클래스로 옮길지 결정!
        // 현재 클래스에서 구현함!. 등록된 객체는 실제 삭제하지 않고 regCount = 0으로만 설정.
        [self clearSB];
    }
}

// SB 등록 해제.
- (void)clearSB
{
    // TODO: 관심종목 관리화면과 연계하여 처리할 것!
    Debug(@"SB 등록해제!");
    NSMutableArray *sbBodies = [NSMutableArray array];
    SBRegBody *sbRegBody = [[SBRegBody alloc] init];
    sbRegBody.idx = self.idx;
    sbRegBody.code = self.code;
    [sbBodies addObject:sbRegBody];
    [sbRegBody release];
    
    TRGenerator *tr = [[TRGenerator alloc] init];
    [[DataHandler sharedDataHandler] sendMessage:[tr genRegisterOrClearSB:SB_CMD_CLEAR andTRCode:self.trCode withCodeSet:sbBodies]];
    [sbBodies release];
    [tr release];
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
