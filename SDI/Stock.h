//
//  Stock.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 21..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Stock : NSObject 
{
    
}

@property (nonatomic, retain) NSString *stockCode;          // 주식코드.
@property (nonatomic, retain) NSString *stockName;          // 주식이름.
@property (nonatomic, retain) NSNumber *currentPrice;       // 현재가.
@property (nonatomic, retain) NSString *symbol;             // 등락 구분(전일대비구분): 상한(1), 상승(2), 보합(3), 하한(4), 하락(5).
@property (nonatomic, retain) NSNumber *fluctuation;        // 등락.
@property (nonatomic, retain) NSNumber *fluctuationRate;    // 등락율.
@property (nonatomic, retain) NSNumber *tradeVolume;        // 거래량(변동).

@end
