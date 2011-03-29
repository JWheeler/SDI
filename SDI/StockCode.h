//
//  StockCode.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 23..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StockCode : NSObject {

}

@property (nonatomic, retain) NSArray *headers;                 // 필드헤더.

@property (nonatomic, retain) NSString *stockCode;              // 종목코드.
@property (nonatomic, retain) NSString *stockName;              // 종목명.
@property (nonatomic, retain) NSString *marketCode;             // 장구분코드(K, Q, T).
@property (nonatomic, retain) NSString *orderUnit;              // 주문단위.
@property (nonatomic, retain) NSString *depositRatio;           // 증거금율(A, B, C, D, E).
@property (nonatomic, retain) NSString *creditDepositRatio;     // 신용증거금율.
@property (nonatomic, retain) NSString *investWarning;          // 투자주의/경고(감리).
@property (nonatomic, retain) NSString *isTrade;                // 투자경고(위험)거래정지구분.

@end
