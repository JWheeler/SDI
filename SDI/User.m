//
//  User.m
//  YFPortal
//
//  Created by Jong Pil Park on 10. 10. 19..
//  Copyright 2010 Lilac Studio. All rights reserved.
//

#import "User.h"
//#import "TRRpHeaderLogin.h"
//#import "TRRpBodyLogin.h"


@implementation User

@synthesize ssn;
@synthesize userID;
@synthesize password;
@synthesize certPassword;
@synthesize username;
@synthesize account;
@synthesize loginType;
@synthesize loginState;
@synthesize isLogin;

static User *sharedUser = nil;

+ (User *)sharedUser 
{
	// 객체에 락을 걸고, 동시에 멀티 스레드에서 메소드에 접근하기 위해 synchronized 사용. 
	@synchronized(self) 
    {
		if(sharedUser == nil) 
        {
			[[self alloc] init];
		}
	}
	return sharedUser;
}

// 초기화.
- (id)init 
{
	if ((self = [super init])) 
    {
		self.account = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

// 객체 할당(alloc) 시 호출됨.
// 객체 할당과 초기화 시 sharedUser 인스턴스가 nil인지 확인.
+ (id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) 
    {
        if (sharedUser == nil) 
        {
            sharedUser = [super allocWithZone:zone];
            return sharedUser;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}

- (id)retain 
{
    return self;
}

- (unsigned)retainCount 
{
	// 릴리즈되어서는 안될 객체 표시.
    return UINT_MAX;  
} 

- (void)release 
{
    // 아무일도 안함.
}

- (id)autorelease 
{
    return self;
}

// TODO: 중계서버가 기존 소켓서버가 아닌 웹서버이고 데이터 포맷은 JSON 임, 그에 맞춰 수정할 것!
// 파싱된 전문 중 사용자정보 설정.
//- (void)parseAccount:(NSMutableDictionary *)dict 
//{
//	int dictCount = [dict count];
//	NSString *key;
//	
//	for (int i = 0; i < dictCount; i++) 
//    {
//		if (i == 0) 
//        {
//			key = @"headerObj";
//			self.ssn = ((TRRpHeaderLogin *)[dict objectForKey:key]).jumin;
//			self.userID = ((TRRpHeaderLogin *)[dict objectForKey:key]).userId;
//			self.username = ((TRRpHeaderLogin *)[dict objectForKey:key]).userName;
//		}
//		else 
//        {
//			key = [NSString stringWithFormat:@"%d", (i -1)];
//			[self.account setObject:(TRRpBodyLogin *)[dict objectForKey:key] forKey:key];
//		}
//	}
//}

@end
