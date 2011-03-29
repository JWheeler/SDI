//
//  CommHeader.h
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 8..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//	TODO: 프라퍼티 길이 체크 로직 추가 해야함!
//

#import <Foundation/Foundation.h>


@interface CommHeader : NSObject 
{							/** Totatl size: 16 */
	NSString *lengcode;		/** C(5) length */
	NSString *funccode;		/** C(1) function */
	NSString *media_ix;		/** C(3) 매체구분 */
	NSString *mgl;			/** C(6) MGL: 4+1+1 */
	NSString *compress;		/** C(1) 암호/압축 */
	NSString *pub_auth;		/** C(1) 공인인증 */
	NSString *tradetype;	/** C(1) 거래유형 */
	NSString *conninfo;		/** C(4) 접속정보 */
}

@property (nonatomic, retain) NSString *lengcode;
@property (nonatomic, retain) NSString *funccode; 
@property (nonatomic, retain) NSString *media_ix;
@property (nonatomic, retain) NSString *mgl;
@property (nonatomic, retain) NSString *compress; 
@property (nonatomic, retain) NSString *pub_auth; 
@property (nonatomic, retain) NSString *tradetype; 
@property (nonatomic, retain) NSString *conninfo;

@end
