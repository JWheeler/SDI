//
//  Stock.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 21..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "Stock.h"


@implementation Stock

@synthesize stockCode;
@synthesize stockName;
@synthesize currentPrice;
@synthesize symbol;
@synthesize fluctuation;
@synthesize fluctuationRate;
@synthesize tradeVolume;

- (void)dealloc
{
    [stockCode release];
    [stockName release];
    [currentPrice release];
    [symbol release];
    [fluctuation release];
    [fluctuationRate release];
    [tradeVolume release];
    [super dealloc];
}

@end
