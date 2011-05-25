//
//  User.h
//  YFPortal
//
//  Created by Jong Pil Park on 10. 10. 19..
//  Copyright 2010 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject 
{
	NSString *ssn;					// 실명번호(주민등록번호).
	NSString *userID;				// 사용자 ID.
	NSString *password;				// 접속 비밀번호.
	NSString *certPassword;			// 인증서 비밀번호.
	NSString *username;				// 사용자 이름.
	NSMutableDictionary *account;	// 사용자 계좌 정보.
	NSString *loginType;			// 로그인유형(0:ID/PW/조회전용, 1:ID/PW/CERT).
	NSString *loginState;			// 로그인상태(0:로그인 성공, 1:로그인 실패).
	BOOL isLogin;					// 로그인 여부.
	
	// TODO: 기타 로그인 상태(로그인 시간 등) 관련 프라퍼티 선언!
}

@property (nonatomic, retain) NSString *ssn;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *certPassword;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSMutableDictionary *account;
@property (nonatomic, retain) NSString *loginType;
@property (nonatomic, retain) NSString *loginState;
@property (assign) BOOL isLogin;	

+ (User *)sharedUser;
//- (void)parseAccount:(NSMutableDictionary *)dict;

@end
