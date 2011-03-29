//
//  StockCode.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 23..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "StockCode.h"


@implementation StockCode

@synthesize headers;

@synthesize stockCode;
@synthesize stockName;
@synthesize marketCode;
@synthesize orderUnit;
@synthesize depositRatio;
@synthesize creditDepositRatio;
@synthesize investWarning;
@synthesize isTrade;

- (void)dealloc
{
    [stockCode release];
    [stockName release];
    [marketCode release];
    [orderUnit release];
    [depositRatio release];
    [creditDepositRatio release];
    [investWarning release];
    [isTrade release];
    [super dealloc];
}

- (id)init
{
    if ((self = [super init])) 
    {
        self.headers = [NSArray arrayWithObjects:@"stockCode", @"stockName", @"marketCode", @"orderUnit", @"depositRatio", @"creditDepositRatio", @"investWarning", @"isTrade",nil];
    }
    
    return self;
}
    
@end
