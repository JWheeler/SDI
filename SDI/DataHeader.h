//
//  DataHeader.h
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 8..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataHeader : NSObject 
{
							/** Totatl size: 105 */
	NSString *handle;		/** C(4) handle */
	NSString *trcode;		/** C(8) TR Code */
	NSString *dispno;		/** C(4) 화면번호 */
	NSString *tradetime;	/** C(6) 거래시간 */
	NSString *custmerno;	/** C(10) 고객번호 */
	NSString *msg;			/** C(4) 메시지 */
	NSString *termno;		/** C(12) 단말번호 */
	NSString *macaddr;		/** C(12) MAC 어드레스 */
	NSString *termialix;	/** C(1) 단말 ID */
	NSString *version;		/** C(6) 버전 */
	NSString *model;		/** C(20) 모델 */
	// 클라이언트는 사용 안해도 된다.
	//NSString *filler;		/** C(3) filler: 자리 맞추기 */
}

@property (nonatomic, retain) NSString *handle;
@property (nonatomic, retain) NSString *trcode;
@property (nonatomic, retain) NSString *dispno;
@property (nonatomic, retain) NSString *tradetime;
@property (nonatomic, retain) NSString *custmerno;
@property (nonatomic, retain) NSString *msg;
@property (nonatomic, retain) NSString *termno;
@property (nonatomic, retain) NSString *macaddr;
@property (nonatomic, retain) NSString *termialix;
@property (nonatomic, retain) NSString *version;
@property (nonatomic, retain) NSString *model;
//@property (nonatomic, retain) NSString *filler;

@end
