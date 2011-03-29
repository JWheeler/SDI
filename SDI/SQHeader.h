//
//  SQHeader.h
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 9..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SQHeader : NSObject 
{
							/** Totatl size: 27 */
	NSString *length;		/** C(1) length */
	NSString *function;		/** C(12) function */
	NSString *trcode;		/** C(8) function */
	NSString *type;			/** C(1) 구분 */
	NSString *code;			/** C(12) Code: 종목코드 */
}

@property (nonatomic, retain) NSString *length;
@property (nonatomic, retain) NSString *function;
@property (nonatomic, retain) NSString *trcode;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *code;

@end
