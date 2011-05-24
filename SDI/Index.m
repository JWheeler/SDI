//
//  Index.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "Index.h"


@implementation Index

@synthesize index;
@synthesize fluctuation;
@synthesize fluctuationRate;

- (void)dealloc
{
    [index release];
    [fluctuation release];
    [fluctuationRate release];
    [super dealloc];
}

#pragma mark - 커스텀 메서드

// 등락비율 계산.
- (NSString *)calcFluctionRate
{
    return nil;
}

// 입력된 데이터의 포맷팅.
// 예: 212262 -> 2,122.62
- (NSString *)changeFormat:(NSString *)unfromatted
{
    return nil; 
}

@end
